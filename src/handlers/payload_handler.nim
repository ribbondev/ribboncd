
import asynchttpserver
import asyncdispatch
import strformat
import json

import ../util/config
import ../github/github_validator
#import ../github/github_events
import ../util/logger

let cfg = config.get_config()
let log = logger.get_logger()

const gh_event_header = "X-GitHub-Event"
const gh_delivery_header = "X-GitHub-Delivery"
const gh_hmac_sig_header = "X-Hub-Signature"

const http_response_invalid_headers = "invalid headers"
const http_response_handled = "handled"
const http_response_forbidden = "unable to authenticate secret"

proc json_respond(req: Request, code: HttpCode, msg: string) {.async.} =
  let msg = %* {"status": msg}
  let headers = newHttpHeaders([("Content-Type", "application/json")])
  await req.respond(code, $msg, headers)

proc has_expected_headers(headers: HttpHeaders): bool =
  if not headers.hasKey(gh_event_header): return false
  if not headers.hasKey(gh_delivery_header): return false
  if not headers.hasKey(gh_hmac_sig_header): return false
  return true

proc handle_gh_payload*(req: Request) {.async.} =
  # ensure X-GitHub-Event, X-GitHub-Delivery and X-Hub-Signature are set
  let host = req.hostname
  let headers = req.headers
  if not has_expected_headers(headers):
    log.warn(fmt"Received payload with incorrect headers from: {host}")
    await json_respond(req, Http400, http_response_invalid_headers)
    return
  # log the three headers
  let event = headers[gh_event_header]
  let delivery = headers[gh_delivery_header]
  let sig = headers[gh_hmac_sig_header]
  log.write(fmt"Received payload: DeliveryId={delivery}, Event={event}, Signature={sig}")
  # verify X-Hub-Signature using github_validator
  if not validate_secret(cfg.github.webhook_secret, req.body, sig):
    log.warn(fmt"Request with invalid signature: {sig}")
    await json_respond(req, Http403, http_response_forbidden)
    return
  # if X-GitHubEvent is release, handle GithubReleaseMessage

  # if X-GitHubEvent is ping, handle GithubPingMessage

  # return ok
  await json_respond(req, Http200, http_response_handled)
  # else Log unhandled event type

