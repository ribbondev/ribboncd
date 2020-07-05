
import asynchttpserver
import asyncdispatch
import strformat
import json
import options
import ../util/config
import ../github/github_validator
import ../github/github_events
import ../util/logger

const gh_event_header = "X-GitHub-Event"
const gh_delivery_header = "X-GitHub-Delivery"
const gh_hmac_sig_header = "X-Hub-Signature"

const http_response_invalid_headers = "invalid headers"
const http_response_handled = "handled"
const http_response_forbidden = "unable to authenticate secret"
const http_response_bad_event = "unsupported event"

proc json_respond(req: Request, code: HttpCode, msg: string) {.async.} =
  let msg = %* {"status": msg}
  let headers = newHttpHeaders([("Content-Type", "application/json")])
  await req.respond(code, $msg, headers)

proc has_expected_headers(headers: HttpHeaders): bool =
  if not headers.hasKey(gh_event_header): return false
  if not headers.hasKey(gh_delivery_header): return false
  if not headers.hasKey(gh_hmac_sig_header): return false
  return true

proc handle_gh_payload*(req: Request): Future[Option[GithubReleaseMessage]] {.async.} =
  let cfg = get_config()
  let log = get_logger()
  let host = req.hostname
  let headers = req.headers

  if not has_expected_headers(headers):
    log.warn(fmt"Received payload with incorrect headers from: {host}")
    await json_respond(req, Http400, http_response_invalid_headers)
    return none(GithubReleaseMessage)
  
  let event = headers[gh_event_header]
  let delivery = headers[gh_delivery_header]
  let sig = headers[gh_hmac_sig_header]
  log.write(fmt"Received payload: {delivery}")
  
  if not validate_secret(cfg.github.webhook_secret, req.body, sig):
    log.warn(fmt"Invalid signature: {sig}")
    await json_respond(req, Http403, http_response_forbidden)
    return none(GithubReleaseMessage)
  
  if event == $GithubEvents.release:
    let releaseJson = parseJson(req.body)
    let release = to(releaseJson, GithubReleaseMessage)
    log.write(fmt"Release: {release.repository.full_name} by {release.sender.login}")
    log.write(fmt"Release action: {release.action} tag {release.release.tag_name}")
    await json_respond(req, Http200, http_response_handled)
    return some(release)
  
  elif event == $GithubEvents.ping:
    let pingJson = parseJson(req.body)
    let ping = to(pingJson, GithubPingMessage)
    log.write(fmt"Ping: {ping.repository.full_name} by: {ping.sender.login}")
    log.write(fmt"Zen: {ping.zen}")
    await json_respond(req, Http200, http_response_handled)
  
  else:
    log.warn(fmt"Unsupported event: {event}")
    await json_respond(req, Http400, http_response_bad_event)
