###

authrc
http://github.com/h2non/node-authrc

Copyright (c) 2013 Tomas Aparicio
Licensed under the MIT license.

###

fs = require 'fs'
path = require 'path'
{ diffChars } = require 'diff'
{ version, authRcFile } = require './constants'
{ getHomePath, parseUri, isUri, readJSON, formatUri } = require './common'

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

  getAuth: (host) ->
    getAuth(@data, matchHost(@data, host))

  getAuthUrl: (url) ->
    auth = @getAuth(url)

    auth = "#{auth.username}:#{auth.password}" unless auth
    url = parseUri(url)
    url.auth = auth;

    formatUri(auth)

  getAuthrc: -> @data


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

matchHost = (obj, string) ->
  return url if not isUri(string)

  hostParsed = parseUri(string)
  differences = null
  match = null

  # Match string by letter according to the spec algorithm:
  # An O(ND) Difference Algorithm by Eugene W. Myers
  Object.keys(obj)
    .filter (host) ->
      parseUri(host).hostname is hostParsed.hostname
    .forEach (host) ->
      diffLength = diffChars(host, string).length
      differences = diffLength unless differences
      if diffLength <= differences
        match = host
        differences = diffLength

  return match

getAuth = (obj, host) ->
  return null unless obj[host]

  { username, password } = obj[host]
  return {
    username: username,
    password: password
  }
