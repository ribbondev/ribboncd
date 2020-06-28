
import asynchttpserver
import asyncdispatch
#import strformat
#import config
#import github_validator
#import github_events
#import logger
import rosencrantz

#let cfg = config.get_config()
#let log = logger.get_logger()

proc handle_gh_payload*(req: ref Request, ctx: Context): Future[Context] {.async.} =
  return ctx

#const gh_event_header = "X-GitHub-Event"
#const gh_delivery_header = "X-GitHub-Delivery"
#const gh_hmac_sig_header = "X-Hub-Signature"

