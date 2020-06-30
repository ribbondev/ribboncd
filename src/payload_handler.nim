
import asynchttpserver
import asyncdispatch
import strformat
#import config
#import github_validator
#import github_events
import logger
import rosencrantz
import json
import tables

#let cfg = config.get_config()
let log = logger.get_logger()

const gh_event_header = "X-GitHub-Event"
const gh_delivery_header = "X-GitHub-Delivery"
const gh_hmac_sig_header = "X-Hub-Signature"

const http_response_invalid_headers = "invalid headers"

proc json_respond(req: ref Request, code: HttpCode, msg: string) {.async.} =
  let msg = %* {"status": msg}
  let headers = newHttpHeaders([("Content-Type", "application/json")])
  await req[].respond(code, $msg, headers)

proc has_expected_headers(headers: HttpHeaders): bool =
  if not headers.table.hasKey(gh_event_header): return false
  if not headers.table.hasKey(gh_delivery_header): return false
  if not headers.table.hasKey(gh_hmac_sig_header): return false
  return true

proc handle_gh_payload*(req: ref Request, ctx: Context): Future[Context] {.async.} =
  # ensure X-GitHub-Event, X-GitHub-Delivery and X-Hub-Signature are set
  let host = req[].hostname
  let headers = req[].headers
  if not has_expected_headers(headers):
    log.warn(fmt"Received payload with incorrect headers from: {host}")
    await json_respond(req, Http400, http_response_invalid_headers)
  # log the three headers
  # verify X-Hub-Signature using github_validator
  # if X-GitHubEvent is release, handle GithubReleaseMessage

  # if X-GitHubEvent is ping, handle GithubPingMessage

  # else Log unhandled event type
  return ctx

