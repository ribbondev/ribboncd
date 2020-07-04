
import asynchttpserver
import asyncdispatch
import strformat

import util/config
import handlers/payload_handler
import util/logger

var cfg = config.get_config()
let log = logger.get_logger()
let server = newAsyncHttpServer()

proc core_handler(req: Request) {.async, gcsafe.} =
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


echo("[ribbon.cd] My most dear lady!")
log.write(fmt"Starting service on port {cfg.service.port}")
waitFor server.serve(Port(cfg.service.port), core_handler)
