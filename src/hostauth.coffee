
crypto = require './crypto'
{ parseUri, formatUri } = require './common'
matchHost = require './matchhost'

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

