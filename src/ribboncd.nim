
import asynchttpserver
import asyncdispatch
import strformat
import rosencrantz

import ribboncd/util/config
import ribboncd/handlers/payload_handler
import ribboncd/util/logger

let cfg = config.get_config()
let log = logger.get_logger()
let server = newAsyncHttpServer()

let handler = post[
  path(cfg.service.path)[
    accept("application/json")[
      makeHandler do:
        await handle_gh_payload(req, ctx)
    ]
  ]
]

echo("[ribbon.cd] My most dear lady!")
log.write(fmt"Starting service on port {cfg.service.port}")
waitFor server.serve(Port(cfg.service.port), handler)
