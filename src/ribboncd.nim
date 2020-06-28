
import asynchttpserver
import asyncdispatch
import strformat
import config
#import github_validator
import logger
import rosencrantz

const config_file = "ribboncd.conf.yml"

let cfg = config.load_config(config_file)
let log = logger.newRLogger(cfg)

let server = newAsyncHttpServer()

let handler = get[
  path(cfg.service.path)[
    ok("Hello, world!")
  ]
]

echo("[ribbon.cd] My most dear lady!")
log.write(fmt"Starting service on port {cfg.service.port}")
waitFor server.serve(Port(cfg.service.port), handler)
