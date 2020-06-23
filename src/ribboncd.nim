
import yaml.serialization as yamls
import streams

const config_file = "ribboncd.conf.yml"

type ServiceConfig = ref object
  path*: string
  port*: int

type GithubConfig = ref object
  webhook_secret*: string
  
type DeploymentConfig = ref object
  target*: string
  cd*: string
  shell_commands*: string

type RcdConfig = ref object
  service*: ServiceConfig
  github*: GithubConfig
  deployments*: seq[DeploymentConfig]

proc load_config*(file_name: string): RcdConfig =
  var config: RcdConfig
  let stream = newFileStream(file_name)
  yamls.load(stream, config)
  stream.close()
  result = config

let config = load_config(config_file)
echo(config.service.path)
echo(config.github.webhook_secret)
echo(config.deployments[0].target)
echo(config.deployments[0].shell_commands)
