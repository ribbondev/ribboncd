import logging
import config

const log_file = "ribboncd.log"
const max_lines = 5000

type RLogger* = ref object
  log_to_file*: bool
  console*: ConsoleLogger
  file*: RollingFileLogger

proc newRLogger*(config: RcdConfig): RLogger =
  let fmt = "[ribbon.cd] $datetime - $levelName: "
  let console_logger = newConsoleLogger(fmtStr=fmt)
  var file_logger: RollingFileLogger = nil
  if config.service.log == true:
    file_logger = newRollingFileLogger(
      file=log_file,
      mode=fmAppend,
      fmtStr=fmt,
      maxLines=max_lines)
  return RLogger(
    log_to_file: config.service.log,
    console: console_logger,
    file: file_logger)

proc write*(logger: RLogger, msg: string) =
  logger.console.log(lvlInfo, msg)
  if logger.log_to_file and logger.file != nil:
    logger.file.log(lvlInfo, msg)

proc warn*(logger: RLogger, msg: string) =
  logger.console.log(lvlWarn, msg)
  if logger.log_to_file and logger.file != nil:
    logger.file.log(lvlWarn, msg)

proc error*(logger: RLogger, msg: string) =
  logger.console.log(lvlError, msg)
  if logger.log_to_file and logger.file != nil:
    logger.file.log(lvlError, msg)

proc fatal*(logger: RLogger, msg: string) =
  logger.console.log(lvlFatal, msg)
  if logger.log_to_file and logger.file != nil:
    logger.file.log(lvlFatal, msg)

proc debug*(logger: RLogger, msg: string) =
  logger.console.log(lvlDebug, msg)
  if logger.log_to_file and logger.file != nil:
    logger.file.log(lvlDebug, msg)
