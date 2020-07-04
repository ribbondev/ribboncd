
import asynchttpserver
import asyncdispatch
import rosencrantz
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
  discard config.load_config(config_file)
  let server = newAsyncHttpServer()
  let handler = post[
    path("/")[
      makeHandler do:
        await handle_gh_payload(req, ctx)
    ]
  ]
  return server.serve(Port(testserver_port), handler)
  
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