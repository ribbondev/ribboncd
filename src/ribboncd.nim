
import asynchttpserver, asyncdispatch
import config

const config_file = "ribboncd.conf.yml"

let cfg = config.load_config(config_file)
echo(cfg.service.path)
echo(cfg.github.webhook_secret)
echo(cfg.deployments[0].target)
echo(cfg.deployments[0].shell_commands)

let server = newAsyncHttpServer()

proc handle_request(req: Request) {.async.} =
  await req.respond(Http200, "Hello, world!")
 
waitFor server.serve(Port(cfg.service.port), handle_request)
 