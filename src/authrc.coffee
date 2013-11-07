path = require 'path'
fileChange = require './lib/filechange'
Actions = require './actions'
Host = require './host'
{ VERSION, FILENAME } = require './constants'
{ getHomePath, cloneDeep, fileExists, dirExists } = require './common'

module.exports = class Authrc extends Actions

  @version: VERSION
  
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
    @hosts().length isnt 0

  hostExists: (string) =>
    @host(string).exists()

  unwatch: ->
    fileChange.unwatch()

  isGlobalFile: ->
    @file is getGlobalFilePath()

  @discover: -> 
    getAuthFilePath() or null

  @find: (string, filepath) ->
    auth = new Authrc(filepath)
    auth.find(string)

  @get: Authrc.find


getCurrentDirFilePath = (filepath) ->
  path.join(process.cwd(), FILENAME)

getDirFilePath = (filepath) ->
  path.join((if dirExists(filepath) then filepath else path.dirname(filepath)), FILENAME)

getGlobalFilePath = ->
  path.join(getHomePath(), FILENAME)

getAuthFilePath = (filepath) ->
  # resolve explicit file path
  return filepath if filepath? and fileExists(filepath)
  # resolve based on the explicit directory path
  authFile = getDirFilePath(filepath)
  return authFile if fileExists(authFile)
  # resolve based on the current working directory
  authFile = getCurrentDirFilePath(filepath)
  return authFile if fileExists(authFile)
  # finally fallback to user home directory pach
  authFile = getGlobalFilePath()
  return authFile if fileExists(authFile)
