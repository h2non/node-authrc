###

authrc
http://github.com/h2non/node-authrc

Copyright (c) 2013 Tomas Aparicio
Licensed under the MIT license.

###

fs = require 'fs'
path = require 'path'
HostAuth = require './hostauth'
{ version, authRcFile } = require './constants'
{ readJSON } = require './common'

module.exports = class

  @version: version
  file: null
  data: {} 

  constructor: (filepath) ->
    @file = path.normalize(filepath) if filepath

    if filepath and fs.existsSync(filepath)
      @file = filepath
    else
      @file = getAuthFilePath()

    if authFileExists(@file) 
      @data = readJSON(@file)

  get: (host, data = @data) ->
    new HostAuth(data, host)

getLocalFilePath = (filePath) ->
  path.join path.dirname(filePath) or process.cwd(), authRcFile

getGlobalFilePath = () ->
  path.join(getHomePath(), authRcFile)

authFileExists = (filepath) ->
  fs.existsSync(getLocalFilePath(filepath)) or fs.existsSync(getGlobalFilePath())

getAuthFilePath = (filepath) ->
  authFile = getLocalFilePath(filepath)
  return authFile if fs.existsSync(authFile)

  authFile = getGlobalFilePath()
  return authFile if fs.existsSync(authFile)

  return false