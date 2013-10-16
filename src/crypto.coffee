crypto = require 'crypto'
ciphers = require './ciphers'
{ lowerCase } = require './common'

module.exports = 

  default: 'aes256'

  ciphers: ciphers

  algorithmExists: (algorithm) ->
    @ciphers.indexOf(lowerCase(algorithm)) isnt -1

  encrypt: (data, key, algorithm = @default) ->
    cipher = crypto.createCipher(lowerCase(algorithm), key);
    cipher.update(data, 'utf8', 'hex') + cipher.final('hex')

  decrypt: (data, key, algorithm = @default) ->
    decipher = crypto.createDecipher(lowerCase(algorithm), key)
    decipher.update(data, 'hex', 'utf8') + decipher.final('utf8')