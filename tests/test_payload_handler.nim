
import asynchttpserver
import asyncdispatch
import unittest
import httpclient
import json
import strformat
import util/config
import handlers/payload_handler

const testserver_domain = "localhost"
const testserver_port = 8000

proc start_testserver(): Future[void] =
  const config_file = "ribboncd.example.conf.yml"
  let cfg = config.load_config(config_file)
  let server = newAsyncHttpServer()
  let test_handler = proc(req: Request) {.async, gcsafe, closure.} =
    let `method` = req.req_method
    let path = req.url.path
    var contentType: string = ""
    if req.headers.hasKey("Content-Type"):
      contentType = req.headers["Content-Type"]
    if `method` == HttpPost and 
      path == cfg.service.path and 
      contentType == "application/json":
      await handle_gh_payload(req)
    else:
      await req.respond(Http404, "Oops!")
  return server.serve(Port(testserver_port), test_handler)
  
suite "payload_handler.handle_gh_payload":
  
  test "request does not include expected errors, returns Http400":
    # start server
    discard start_testserver()
    # make reqs
    let headers = newHttpHeaders({"Content-Type": "application/json" })
    let client = newAsyncHttpClient(headers=headers)
    let url = fmt"http://{testserver_domain}:{testserver_port}/"
    let body = %* {}
    let response = client.request(
      url = url,
      httpMethod = HttpPost,
      body = $body)
    # wait until reqs performed
    while true:
      poll(timeout = 5000)
      if response.finished:
        break
    # assert
    check(response.read().status == $Http400)

  test "valid request with incorrect signature, returns Http403":
    # start server
    discard start_testserver()
    # make reqs
    let headers = newHttpHeaders({
      "Content-Type": "application/json",
      "X-GitHub-Event": "release",
      "X-GitHub-Delivery": "nya",
      "X-Hub-Signature": "INVALID"
    })
    let client = newAsyncHttpClient(headers=headers)
    let url = fmt"http://{testserver_domain}:{testserver_port}/"
    let body = %* {}
    let response = client.request(
      url = url,
      httpMethod = HttpPost,
      body = $body)
    # wait until reqs performed
    while true:
      poll(timeout = 5000)
      if response.finished:
        break
    # assert
    check(response.read().status == $Http403)
