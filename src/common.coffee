fs = require 'fs'
path = require 'path'
{ inputEnc } = require './constants'
{ parse, format } = require 'url'

module.exports = class Common

  @getHomePath: ->
    path.normalize process.env[(if (process.platform is 'win32') then 'USERPROFILE' else 'HOME')] or ''

  @getEnvVar: (name) =>
    process.env[@trim name]

  @isRegex: (regexString) ->
    (/^\/.*\/$/).test regexString

  @validRegex: (string) =>
    return no unless @isRegex string
    try 
      new RegExp string
      return yes
    catch err
      return no

  @parseUri: (string) ->
    host = parse(string)
    # add support for aditional protocols
    if not host.protocol or string.indexOf('://') is -1
      host = arguments.callee 'http://' + string
    host

  @isUri: (string) =>
    { protocol, hostname } = @parseUri string
    protocol? and hostname?

  @formatUri: (object) ->
    format(object)

  @readJSON: (filepath) => 
    JSON.parse fs.readFileSync(filepath, { encoding: inputEnc })

  @writeJSON: (filepath, data, callback) ->
    data = do ->
      obj = {}
      obj[key] = data[key] for own key of data when data[key]?
      obj

    fs.writeFile filepath, JSON.stringify(data, null, 4), { mode: parseInt('700', 8) }, (err) ->
      if typeof callback is 'function'
        if err
          callback err 
        else
          callback null, data

  @fileExists: (path) ->
    return false if not fs.existsSync path
    stat = fs.lstatSync(path)
    stat.isFile() or stat.isSymbolicLink()

  @dirExists: (path) ->
    return false if not fs.existsSync(path)
    fs.lstatSync(path).isDirectory()

  @lowerCase: (string) =>
    string = string.toLowerCase() if @isString(string)
    string

  @trim: (string) =>
    if @isString(string)
      string = string.trim()
    string

  @isString: (string) ->
    typeof string is 'string'

  @isObject: (obj) ->
    typeof obj is 'object' and obj isnt null

  @isArray: (obj) =>
    @isObject(obj) and obj.toString() is '[object Array]'

  @isFn: (obj) ->
    typeof obj is 'function'

  @omit: (obj, props...) ->
    newObj = {}
    for own key of obj when props.indexOf(key) is -1
      newObj[key] = obj[key]
    newObj

  @extend: (target, obj) ->
    for prop of obj
      if obj.hasOwnProperty(prop)
        target[prop] = obj[prop]
    target

  @cloneDeep: (obj) =>
    return obj if obj is undefined or obj is null
    return obj if typeof obj is 'number'
    return obj if @isString(obj)
    return new Date(obj.getTime()) if Object::toString.call(obj) is '[object Date]'

    clone = if @isArray(obj) then obj.slice() else do (obj) ->
      o = {}
      for k of obj
        o[k] = obj[k]
      o

    for own key of clone
      clone[key] = arguments.callee.call @, clone[key]

    clone

