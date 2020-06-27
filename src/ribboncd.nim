
import asynchttpserver, asyncdispatch
import strformat
import config
import validate_secret
import rosencrantz

const config_file = "ribboncd.conf.yml"

let cfg = config.load_config(config_file)
echo(cfg.service.path)
echo(cfg.github.webhook_secret)
echo(cfg.deployments[0].target)
echo(cfg.deployments[0].shell_commands)

let server = newAsyncHttpServer()

let handler = get[
  path(cfg.service.path)[
    ok("Hello, world!")
  ]
]

echo("[ribbon.cd] My most dear lady!")
echo(fmt"[ribbon.cd] Starting service on port {cfg.service.port}")
waitFor server.serve(Port(cfg.service.port), handler)
