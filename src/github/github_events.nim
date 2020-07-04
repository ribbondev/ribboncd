
type GithubHookConfig* = ref object
  content_type: string
  insecure_ssl: string
  url: string

type GithubHook* = ref object
  `type`*: string
  id*: int
  name*: string
  active*: bool
  events*: seq[string]
  config*: GithubHookConfig
  updated_at*: string
  created_at*: string
  url*: string

type GithubRepository* = ref object
  id*: int
  name*: string
  full_name*: string
  private*: bool

type GithubSender* = ref object
  login*: string
  id*: int

type GithubRelease* = ref object
  url*: string
  id*: int
  tag_name*: string
  target_commitish*: string
  draft*: bool
  prerelease*: bool
  created_at*: string
  published_at*: string

type GithubPingMessage* = ref object
  zen*: string
  hook_id*: int
  hook*: GithubHook
  repository*: GithubRepository
  sender*: GithubSender

type GithubReleaseMessage* = ref object
  action*: string
  release*: GithubRelease
  repository*: GithubRepository
  sender*: GithubSender

type GithubEvents* = enum
    release = "release"
    ping = "ping"
