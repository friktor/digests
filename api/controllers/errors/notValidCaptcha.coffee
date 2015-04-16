module.exports = class notValidCaptcha extends Error
  constructor: (@message) ->
    @name = "notValidCaptcha"
    Error.captureStackTrace(this, notValidCaptcha)