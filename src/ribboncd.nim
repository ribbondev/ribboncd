
import asynchttpserver
import asyncdispatch
import strformat
import strutils
import os
import options

import util/config
import handlers/payload_handler
import util/logger

const releasable_action = "published"

let server = newAsyncHttpServer()

let cfg = get_config()
let log = get_logger()

# currently blocking execute
proc execute_commands(commands: string) =
  let lines = commands.splitLines()
  for line in lines:
    if line.strip() == "":
      continue
    log.write(fmt"Executing: {line}")
    discard execShellCmd(line)

proc core_handler(req: Request) {.async, gcsafe.} =
  let homeDir = getCurrentDir()
  let `method` = req.req_method
  let path = req.url.path
  var contentType: string = ""
  if req.headers.hasKey("Content-Type"):
    contentType = req.headers["Content-Type"]
  if `method` == HttpPost and 
    path == cfg.service.path and 
    contentType == "application/json":
    let payload = await handle_gh_payload(req)
    if payload.isNone():
      return
    let release = payload.get()
    if release.action != releasable_action:
      return
    for item in cfg.deployments:
      if item.target == release.repository.full_name:
        log.write(fmt"Found deployment job for: {item.target}")
        if not existsDir(item.cd):
          log.warn(fmt"Directory does not exist: {item.cd}")
          continue
        setCurrentDir(item.cd)
        execute_commands(item.shell_commands)
    setCurrentDir(homeDir)
  else:
    log.write(fmt"Invalid request at: {req.url.path}")
    await req.respond(Http404, "Oops! Something went wrong!")

echo("[ribbon.cd] My most dear lady!")
log.write(fmt"Starting service on port {cfg.service.port}")
waitFor server.serve(Port(cfg.service.port), core_handler)
