## RibbonCD
Simple continuous deployment through github webhooks. `linux` `windows` `nim` `github`

## Build requirements
- Nim compiler in path: http://nim-lang.org/
- Taskfile task runner in path: https://taskfile.dev/

## Build, test & run
```sh
# create configuration file
cp ribboncd.conf.yml.example ribboncd.conf.yml
# edit me

# install nim dependencies
task install

# build executable
task build

# run executable
task run

# bundle release
task release
# install me

# remove generated files
task clean
```
