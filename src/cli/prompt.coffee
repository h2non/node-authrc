promptly = require 'promptly'
validator = require './validator'
{ exit, isArray, isString } = require '../common'

module.exports =

  hostname: (callback) ->
    prompt 'Enter the host name: ', handleResponse callback

  username: (callback) ->
    prompt 'Enter the user name: ', handleResponse callback

  password: (callback, message) ->
    if isString callback
      callbackFn = message
      message = callback
      callback = callbackFn

    prompt "Enter #{message or 'the password'}: ", { validator: validator.password }, 'password', handleResponse (value) ->
      password = value
      prompt "Confirm #{message or 'the password'}: ", { validator: validator.password }, 'password', handleResponse (value) ->
        if validator.notEqual password, value
          exit 1, 'The passwords did not match. Try again'.red
        callback(password)

  confirm: (message, callback) ->
    prompt "#{message} [Y/n]:", 'confirm', handleResponse callback

  choose: (message, list, callback) ->
    prompt "#{message}:", 'choose', list, handleResponse callback


handleResponse = (callback) ->
  (err, value) -> 
    exit 1, "Error: #{err}".red if err
    callback(value)

prompt = (message, callback, list, type, options) ->
  # simple input arguments normalizer based on its type
  args = Array::slice.call(arguments)
  { type, fnArgs } = do (args) ->
    temp = {}
    fnArgs = []

    getType = (value) ->
      type = typeof value
      type = 'null' if type is null
      type = 'array' if isArray value
      type

    args.forEach (value, i) ->
      switch getType value
        when 'string'
          if i is 0
            temp.message = value
          else
            temp.type = value
        when 'function' then temp.callback = value
        when 'array' then temp.list = value
        when 'object' then temp.options = value

    temp.type ?= 'prompt'
    fnArgs.push value for param, value of temp when param isnt 'type'

    { type: temp.type, fnArgs: fnArgs }

  promptly[type].apply null, fnArgs