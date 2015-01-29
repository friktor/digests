module.exports = class badFileType extends Error
  constructor: (@message) ->
    @name = "badFileType"
    Error.captureStackTrace(this, badFileType)