## :ribbon: / ribbon.cd
An easy-to-use, minimalist continuous deployment server for github webhooks. `linux` `windows` `nim` `github`

## Features
- Listen for github release webhook payloads
- Authenticate github payloads by their secret token
- Perform arbitrary shell commands in response to github activity
- Intuitive yaml based configuration

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
