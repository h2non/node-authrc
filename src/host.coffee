crypto = require './crypto'
matchHost = require './matchhost'
{ algorithm } = require './constants'
{ parseUri, formatUri, isObject, cloneDeep, trim, lowerCase } = require './common'

module.exports = class Host

  data: null
  host: null

  constructor: (data, host) ->
    @data = data if data
    @host = matchHost(@data, host) if host

  get: =>
    cloneDeep(@data[@host]) if @data

  set: (hostObj) =>
    return false if not isObject(hostObj)
    return false unless hostObj.username or hostObj.password

    @data[@host] = cloneDeep(hostObj)

  exists: =>
    @data isnt null and @host isnt null and @get()?.password?
  
  getUser: =>
    return null unless @exists()
    @get().username or null

  getPasswordObj: =>
    return null unless @exists()

    passwordObj = @get().password
    passwordObj = { value: password } if typeof password is 'string'

    passwordObj or null

  getPassword: =>
    return null unless @exists()
    
    { password } = @get()
    if isObject(password)
      if password.envValue
        password = process.env[password.envValue]
      else
        password = password.value
  
    password or null

  setPassword: (obj) =>
    return false unless @exists()
    return false if not isObject(obj) or typeof obj isnt 'string'

    @data[@host].password = cloneDeep(obj)

  getCipher: =>
    return null unless @exists()

    password = @getPasswordObj() 
    return null if not isObject(password)

    if password.cipher
      cipher = trim(lowerCase(password.cipher))
    else if password.encrypted is true
      cipher = algorithm

    cipher or null

  getAuth: =>
    return null unless @exists()

    { username, password } = @get()
    password = @getPassword(password)

    auth = {
      username: username,
      password: password
    }

    auth

  getAuthUrl: =>
    return @host unless auth = @getAuth()

    url = parseUri(@host)
    url.auth = "#{auth.username}:#{auth.password}" unless auth

    formatUri(auth)

  isEncrypted: =>
    values = @get()
    return false unless @exists()
    return false if not isObject(values.password)
    return false if not values.password.cipher and values.password.encrypted isnt true
    crypto.algorithmExists(@getCipher())

  decrypt: (key, cipher = @getCipher()) =>
    return null unless @exists()
    return @getPassword() if not @isEncrypted()

    crypto.decrypt(@getPassword(), key, cipher)

  encrypt: (key, cipher = algorithm) =>
    return null unless @exists()
    return @getPassword() if not @isEncrypted

    password = crypto.encrypt(@getPassword(), key, cipher)
    @setPassword({ 
      algorithm: cipher
      value: password
    })

    password



