## :ribbon: / ribbon.cd
Simple continuous deployment server for github webhooks. `linux` `windows` `nim` `github`

## Features
- Trigger deployment jobs from github release webhooks
- Perform arbitrary deployment jobs via shell commands
- Configure repository targets and associated deployment jobs using yaml

## Build requirements
- Nim compiler in path: http://nim-lang.org/
- Taskfile task runner in path: https://taskfile.dev/

## Build, test & run
```sh
# create configuration file
cp ribboncd.example.conf.yml ribboncd.conf.yml
# edit me

# install nim dependencies
task install

# build executable
task build

# run the unit tests
task test

# run executable
task run

# bundle release
task release
# install me

# remove generated files
task clean
```
