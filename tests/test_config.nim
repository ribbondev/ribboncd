import unittest
import strutils
import util/config

suite "config.load_config":

  test "loads ribboncd.example.conf.yml":
    const config_file = "ribboncd.conf.yml.example"
    let cfg = config.load_config(config_file)
        
    # service section
    check(cfg.service.path == "/")
    check(cfg.service.port == 8000)

    # github section
    check(cfg.github.webhook_secret == "my-webhook-secret")

    # deployments section
    check(len(cfg.deployments) == 2)

    # deployment 1
    check(cfg.deployments[0].target == "test-app-1")
    check(cfg.deployments[0].cd == "/usr/bin/test-apps")
    let deployment_commands1 = cfg.deployments[0].shell_commands.splitLines()
    check(deployment_commands1[0] == "echo installing test-app-1")
    check(deployment_commands1[1] == "echo done")

    # deployment 2
    check(cfg.deployments[1].target == "test-app-2")
    check(cfg.deployments[1].cd == "/usr/bin/test-apps")
    let deployment_commands2 = cfg.deployments[1].shell_commands.splitLines()
    check(deployment_commands2[0] == "echo installing test-app-2")
    check(deployment_commands2[1] == "echo done")
