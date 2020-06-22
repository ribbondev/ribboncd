## RibbonCD
Simple continuous deployment through github webhooks. `linux` `windows` `nim`

## Build requirements
- Nim compiler in path: http://nim-lang.org/
- Taskfile task runner in path: https://taskfile.dev/

## Build, test & run
```sh
# install nim dependencies
task install

# build
task build

# run
task run

# bundle release
task release

# remove generated files
task clean
```
