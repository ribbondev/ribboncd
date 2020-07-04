import unittest
import ribboncd/github/github_validator

suite "github_validator.constant_cmp":

  test "returns true when strings of varying lengths are equal":
    check(constant_cmp("", "") == true)
    check(constant_cmp("a", "a") == true)
    check(constant_cmp("-", "-") == true)
    check(constant_cmp("ab", "ab") == true)
    check(constant_cmp("abcd123", "abcd123") == true)
    check(constant_cmp("abcd 123 xyz /*+-", "abcd 123 xyz /*+-") == true)

  test "returns false when strings of verying lengths are not equal":
    check(constant_cmp("a", "") == false)
    check(constant_cmp("", "a") == false)
    check(constant_cmp("a", "b") == false)
    check(constant_cmp("b", "a") == false)
    check(constant_cmp("ab", "ac") == false)
    check(constant_cmp("ac", "ab") == false)
    check(constant_cmp("abc+def", "abc-def") == false)
    check(constant_cmp("abc def 123", "abc def 1234") == false)
    check(constant_cmp("abc def 1234", "abc def 123") == false)

suite "github_validator.validate_secret":
  
  test "returns true when github hash is hmac of secret and body":
    let secret = "secret123"
    let body = "{ x: 1, y: 1 }"
    let github_sig = "sha1=1C30FB84424FD7B175E64EDD94148CD9E2D58B97"
    check(validate_secret(secret, body, github_sig) == true)
