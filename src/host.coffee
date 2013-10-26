Actions = require './actions'
crypto = require './crypto'
matchHost = require './matchhost'
{ algorithm } = require './constants'
{ parseUri, formatUri, isObject, cloneDeep, getEnvVar, isString, trim, lowerCase } = require './common'

module.exports = class Host extends Actions

  file: null
  data: null
  host: null
  search: null

  constructor: (file, data, host) ->
    @file = file
    @data = data
    @search = host
    @host = matchHost(@data, host)

  get: =>
    if @data then cloneDeep(@data[@host]) else null

  set: (hostObj) =>
    return yes if not isObject(hostObj)
    return yes unless hostObj.username or hostObj.password

    @data[@host] = cloneDeep(hostObj)
    yes

  exists: =>
    @data? and @host isnt null and @get()?.password?
  
  username: (newValue) =>
    return null if not @exists()

    @data[@host].username = newValue if newValue? and isString(newValue)
    @get().username or null

  getPasswordObj: =>
    return null unless @exists()

    passwordObj = @get().password
    passwordObj = { value: passwordObj } if isString(passwordObj)

    passwordObj or null

  password: (newValue) =>
    return null unless @exists()
    return @setPassword(newValue) if newValue?
    
    { password } = @get()
    if isObject(password)
      if password.envValue
        password = getEnvVar(password.envValue)
      else
        password = password.value
    
    password or null

  setPassword: (obj) =>
    return null unless @exists()
    return null if not isObject(obj) and not isString(obj)

    @data[@host].password = cloneDeep(obj)
    obj

  passwordKey: =>
    return null unless passwordObj = @getPasswordObj()
    key = getEnvVar(passwordObj.envKey) if passwordObj.envKey?
    key or null

  cipher: =>
    return null unless @exists()

    password = @getPasswordObj() 
    return null if not isObject(password)

    if password.cipher
      cipher = trim(lowerCase(password.cipher))
    else if password.encrypted is true
      cipher = algorithm

    cipher or null

  auth: (username, password) =>
    if isObject(username) and username.username? and username.password?
      @username(username.username)
      @password(username.password)
    else if username? and password?
      @username(username)
      @password(password)

    return null unless @exists()

    { username, password } = @get()
    password = @password()

    {
      username: username,
      password: password
    }

  authUrl: =>
    return @search unless auth = @auth()

    url = parseUri(@search)
    url.auth = "#{auth.username}:#{auth.password}"

    formatUri(url)

  isEncrypted: =>
    return no unless @exists()

    { password } = @get()
    return no if not isObject(password)
    return no if (not password.cipher or password.cipher is 'plain') and password.encrypted isnt true
    crypto.cipherExists(@cipher())

  canDecrypt: =>
    @isEncrypted() and @passwordKey()?


  # @throws Error, TypeError
  decrypt: (key = @passwordKey(), cipher = @cipher()) =>
    throw new Error('The password value do not exists') unless @exists()
    throw new TypeError('Unsupported cipher algorithm: ' + cipher) unless crypto.cipherExists(cipher)
    return @password() if not @isEncrypted()
    throw new TypeError('Missing required key argument') if not isString(key)

    crypto.decrypt(@password(), key, cipher)

  # @throws Error, TypeError
  encrypt: (key = @passwordKey(), cipher = algorithm) =>
    throw new Error('The password value do not exists') unless @exists()
    throw new TypeError('Unsupported cipher algorithm: ' + cipher) unless crypto.cipherExists(cipher)
    throw new Error('The password is already encrypted') if @isEncrypted()
    throw new TypeError('Missing required key argument') if not isString(key)

    password = crypto.encrypt(@password(), key, cipher)
    @setPassword({
      algorithm: cipher
      value: password
    })

    @

