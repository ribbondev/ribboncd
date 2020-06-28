
import asynchttpserver
import asyncdispatch
import strformat
import config
#import github_validator
#import github_events
import logger
import rosencrantz

const config_file = "ribboncd.conf.yml"

let cfg = config.load_config(config_file)
let log = logger.newRLogger(cfg)

let server = newAsyncHttpServer()

# log X-GitHub-Delivery per req
# support only X-Github-Event of release and ping
# validate X-Hub-Signature hmac
let handler = post[
  path(cfg.service.path)[
    ok("Hello, world!")
    #jsonBody(proc(m: GithubWebhookMessage): auto =
    #  ok("hello world")
    #)
  ]
]

echo("[ribbon.cd] My most dear lady!")
log.write(fmt"Starting service on port {cfg.service.port}")
waitFor server.serve(Port(cfg.service.port), handler)
