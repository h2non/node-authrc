fs = require 'fs'
path = require 'path'
{ parse, format } = require 'url'

module.exports = new class

  getHomePath: ->
    path.normalize process.env[(if (process.platform is 'win32') then 'USERPROFILE' else 'HOME')]

  isUri: (string) ->
    { protocol, hostname } = parse(string)
    protocol? and hostname?

  parseUri: (string) ->
    host = parse(string)
    # add support for aditional protocols
    if not host.protocol or string.indexOf('://') is -1
      host = arguments.callee('http://' + string)
    host

  formatUri: (object) ->
    format(object)

  readJSON: (filepath) ->
    JSON.parse(fs.readFileSync(filepath))

  writeJSON: (filepath, data, callback) ->
    fs.writeFile filepath, JSON.stringify(data, null, 4), (err) ->
      if typeof callback is 'function'
        return callback(err) if err
        callback()

  lowerCase: (string) =>
    string = string.toLowerCase() if @isString(string)
    string

  trim: (string) =>
    if @isString(string)
      string = string.trim()
    string

  isString: (string) ->
    typeof string is 'string'

  isObject: (obj) ->
    typeof obj is 'object' and obj isnt null

  isArray: (obj) =>
    @isObject(obj) and obj.toString() is '[object Array]'

  extend: (target, obj) ->
    for prop of obj
      target[prop] = obj[prop]
    target

  cloneDeep: (obj) =>
    toStr = Object::toString

    return obj if obj is undefined or obj is null
    return obj if typeof obj is 'number'
    return obj if @isString(obj)
    return new Date(obj.getTime()) if toStr.call(obj) is '[object Date]'

    clone = (if @isArray(obj) then obj.slice() else ((obj) ->
      o = {}
      for k of obj
        o[k] = obj[k]
      o
    (obj)))

    for key of clone
      if clone.hasOwnProperty(key)
        clone[key] = arguments.callee.call(@, clone[key])

    clone
