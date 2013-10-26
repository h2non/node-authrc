crypto = require 'crypto'
ciphers = require './ciphers'
{ algorithm, inputEnc, outputEnc } = require './constants'
{ lowerCase } = require './common'

module.exports = 

  default: algorithm

  ciphers: Object.keys(ciphers)

  cipherExists: (algorithm) ->
    ciphers.hasOwnProperty(lowerCase(algorithm))

  getAlgorithm: (algorithm) ->
    ciphers[lowerCase(algorithm)] if @cipherExists(algorithm)

  encrypt: (data, key, algorithm = @default) ->
    cipher = crypto.createCipher(@getAlgorithm(algorithm), key);
    cipher.update(data, inputEnc, outputEnc) + cipher.final(outputEnc)

  decrypt: (data, key, algorithm = @default) ->
    decipher = crypto.createDecipher(@getAlgorithm(algorithm), key)
    decipher.update(data, outputEnc, inputEnc) + decipher.final(inputEnc)