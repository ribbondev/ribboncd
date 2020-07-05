import strformat
import nimcrypto
import strutils

proc constant_cmp*(left: string, right: string): bool =
  let llen = len(left)
  if len(right) != llen:
    return false
  var iter_val = 0
  for i in 0..<llen:
    iter_val = iter_val or (int(left[i]) xor int(right[i]))
  return iter_val == 0

proc validate_secret*(secret: string, payload: string, github_sig: string): bool =
  # hmac of secret and payload should equal github_sig
  let digest = $sha1.hmac(secret, payload)
  let sig = fmt"sha1={digest}"
  return constant_cmp(sig.toLowerAscii(), github_sig)
