import logging
import config

const log_file = "ribboncd.log"
const max_lines = 5000

type RLogger* = ref object
  log_to_file*: bool
  console*: ConsoleLogger
  file*: RollingFileLogger

proc newRLogger*(config: RcdConfig): RLogger =
  let fmt = "[ribbon.cd] $time : $levelName - "
  let console_logger = newConsoleLogger(fmtStr=fmt)
  var file_logger: RollingFileLogger = nil
  if config.service.log == true:
    file_logger = newRollingFileLogger(
      filename=log_file,
      mode=fmAppend,
      fmtStr="[ribbon.cd] $datetime : $levelName - ",
      maxLines=max_lines)
  return RLogger(
    log_to_file: config.service.log,
    console: console_logger,
    file: file_logger)

template write_ex(logger: RLogger, level: Level, msg: string) =
  logger.console.log(level, msg)
  if logger.log_to_file and logger.file != nil:
    logger.file.log(level, msg)

proc write*(logger: RLogger, msg: string) =
  write_ex(logger, lvlInfo, msg)

proc warn*(logger: RLogger, msg: string) =
  write_ex(logger, lvlWarn, msg)

proc error*(logger: RLogger, msg: string) =
  write_ex(logger, lvlError, msg)

proc fatal*(logger: RLogger, msg: string) =
  write_ex(logger, lvlFatal, msg)

proc debug*(logger: RLogger, msg: string) =
  write_ex(logger, lvlDebug, msg)
