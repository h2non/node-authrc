promptly = require 'promptly'
validator = require './validator'
{ exit, isArray, isString } = require '../common'

module.exports =

  enter: (callback, message) ->
    { callback, message } = normalizeArgs.apply null, arguments
    prompt "#{message}:", handleResponse callback

  hostname: (callback) ->
    @enter 'Enter the host name', callback

  username: (callback) ->
    @enter 'Enter the user name', callback

  password: (callback, noValidate, message) ->
    { callback, message, noValidate } = normalizeArgs.apply null, arguments
    validateObj = { validator: validator.password } unless noValidate

    prompt "Enter #{message or 'the password'}: ", validateObj, 'password', handleResponse (value) ->
      password = value
      prompt "Confirm #{message or 'the password'}: ", validateObj, 'password', handleResponse (value) ->
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

getType = (value) ->
  type = typeof value
  type = 'null' if type is null
  type = 'array' if isArray value
  type

prompt = (message, callback, list, type, options) ->
  # simple input arguments normalizer based on its type
  args = Array::slice.call(arguments)
  { type, fnArgs } = do (args) ->
    temp = {}
    fnArgs = []

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

normalizeArgs = ->
  temp = {}

  Array::slice.call(arguments)
    .forEach (value, i) ->
      switch getType value
        when 'string' then temp.message = value
        when 'function' then temp.callback = value
        when 'boolean' then temp.noValidate = value

  temp

