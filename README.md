## :ribbon: / ribbon.cd
Simple continuous deployment server for github webhooks. `linux` `windows` `nim` `github`

## Features
- Trigger deployment jobs from github release webhooks
- Perform arbitrary deployment jobs via shell commands
- Configure repository targets and associated deployment jobs using yaml

*Note: ribbon.cd simply executes arbitrary shell commands in response
to webhooks. It's use-case is not specifically tied to deploying code* 

## Build requirements
- Nim compiler in path: http://nim-lang.org/
- Taskfile task runner in path: https://taskfile.dev/

## Quickstart
```sh
# clone to target deployment server
git clone https://github.com/ribbondev/ribboncd
cd ribboncd

# install nim dependencies
task install

# build executable
task build

# run the unit tests
task test

# create configuration file
cp ribboncd.example.conf.yml ribboncd.conf.yml
# edit me

# run executable
task run

# bundle release
task release
# install me

# remove generated files
task clean
```

## Configuration
See [ribboncd.example.conf.yml](./ribboncd.example.conf.yml) for a documented example
