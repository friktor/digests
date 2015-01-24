module.exports = class notExists extends Error
  constructor: (@message) ->
    @name = "notExists"
    Error.captureStackTrace(this, notExists)