import yaml/serialization as yamls
import streams
import options

const config_file = "ribboncd.conf.yml"

type ServiceConfig* = object
  path*: string
  port*: int
  log*: bool

type GithubConfig* = object
  webhook_secret*: string
  
type DeploymentConfig* = object
  target*: string
  cd*: string
  shell_commands*: string

type RcdConfig* = object
  service*: ServiceConfig
  github*: GithubConfig
  deployments*: seq[DeploymentConfig]

proc load_config*(file_name: string): RcdConfig =
  var config: RcdConfig
  let stream = newFileStream(file_name)
  yamls.load(stream, config)
  stream.close()
  result = config

var cfg {.global, threadvar.}: Option[RcdConfig]

proc get_config*(): RcdConfig = 
  if cfg.isSome(): return cfg.get()
  cfg = some(load_config(config_file))
  return cfg.get()
