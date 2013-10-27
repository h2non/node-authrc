path = require 'path'
fileChange = require './filechange'
Actions = require './actions'
Host = require './host'
{ version, authRcFile } = require './constants'
{ getHomePath, cloneDeep, fileExists, dirExists } = require './common'

module.exports = class Authrc extends Actions

  @version: version
  file: null
  data: {}

  # @throws Error
  constructor: (filepath = process.cwd()) ->
    filepath = getAuthFilePath(path.normalize(filepath))

    if filepath?
      @file = filepath
      @read()
      fileChange.watch filepath, =>
        try # prevent multiple file access/write when the buffer is empty
          @data = @read()

  host: (string, data = @data) =>
    new Host(@file, data, string)

  find: Authrc::host

  getData: =>
    cloneDeep(@data)

  hosts: =>
    Object.keys(@data)

  exists: =>
    Object.keys(@data).length isnt 0

  hostExists: (string) =>
    @host(string).exists()

  unwatch: ->
    fileChange.unwatch()

getCurrentDirFilePath = (filepath) ->
  path.join(process.cwd(), authRcFile)

getDirFilePath = (filepath) ->
  path.join((if dirExists(filepath) then filepath else path.dirname(filepath)), authRcFile)

getGlobalFilePath = ->
  path.join(getHomePath(), authRcFile)

getAuthFilePath = (filepath) ->
  # resolve explitic file path
  return filepath if filepath? and fileExists(filepath)
  # resolve based on the path directory
  authFile = getDirFilePath(filepath)
  return authFile if fileExists(authFile)
  # resolve based on the current working directory
  authFile = getCurrentDirFilePath(filepath)
  return authFile if fileExists(authFile)
  # finally fallback to user home directory pach
  authFile = getGlobalFilePath()
  return authFile if fileExists(authFile)
