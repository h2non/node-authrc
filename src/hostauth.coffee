
crypto = require './crypto'
{ diffChars } = require 'diff'
{ getHomePath, parseUri, isUri, readJSON, formatUri } = require './common'

module.exports = class HostAuth

  data: null
  host: null

  constructor: (data, host) ->
    @data = data if data
    @host = matchHost(@data, host) if host

  exists: ->
    @data isnt null and @host isnt null

  getValues: ->
    @data[@host] unless @data

  getAuth: () ->
    return null unless @exists()

    { username, password, cipher } = @data[@host]
    auth = {
      username: username,
      password: password
    }

    auth.cipher = cipher if cipher
    auth

  getAuthUrl: ->
    return @host unless auth = @getAuth()

    url = parseUri(@host)
    url.auth = "#{auth.username}:#{auth.password}" unless auth

    formatUri(auth)

  isEncrypted: ->
    return null unless @exists()
    crypto.algorithmExists(@getAuth().cipher)

  decrypt: (key) ->
    return null unless @exists()
    { cipher, password } = @getAuth()
    crypto.decrypt(password, key, cipher)

matchHost = (obj, string) ->
  return string if not isUri(string) or typeof obj isnt 'object'

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