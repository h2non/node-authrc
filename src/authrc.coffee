fs = require 'fs'
path = require 'path'
fileChange = require './filechange'
Host = require './host'
{ version, authRcFile } = require './constants'
{ readJSON, writeJSON, extend, getHomePath, cloneDeep } = require './common'

module.exports = class

  @version: version
  file: null
  data: {}

  constructor: (filepath) ->
    filepath = path.normalize(filepath) if filepath
    @file = getAuthFilePath(filepath)

    if authFileExists(@file) 
      @data = readJSON(@file)
      fileChange @file, => 
        @data = readJSON(@file)

  host: (string, data = @data) =>
    new Host(data, string)

  add: (hostObj) =>
    extend(@data, hostObj)
    true

  save: (data = @data, callback) =>
    writeJSON(@file, data, callback)

  getContent: =>
    cloneDeep(@data)

  getHosts: =>
    Object.keys(@data)

  exists: =>
    Object.keys(@data).length isnt 0;

getLocalFilePath = (filepath) ->
  path.join path.dirname(filepath) or process.cwd(), authRcFile

getGlobalFilePath = () ->
  path.join(getHomePath(), authRcFile)

authFileExists = (filepath) ->
  fs.existsSync(getLocalFilePath(filepath)) or fs.existsSync(getGlobalFilePath())

getAuthFilePath = (filepath) ->
  authFile = getLocalFilePath(filepath)
  return authFile if fs.existsSync(authFile)

  authFile = getGlobalFilePath()
  return authFile if fs.existsSync(authFile)

  true
