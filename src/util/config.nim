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

var conf: Option[RcdConfig] = none(RcdConfig)

proc get_config*(): RcdConfig =
  if conf.isSome: return conf.get()
  let new_conf = load_config(config_file)
  conf = some(new_conf)
  return conf.get()
