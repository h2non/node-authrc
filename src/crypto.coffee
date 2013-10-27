crypto = require 'crypto'
ciphers = require './ciphers'
{ algorithm, inputEnc, outputEnc } = require './constants'
{ lowerCase } = require './common'

module.exports = class

  @default: algorithm

  @ciphers: Object.keys(ciphers)

  @cipherExists: (cipher) ->
    ciphers.hasOwnProperty(lowerCase(cipher))

  @getCipher: (cipher) =>
    ciphers[lowerCase(cipher)] if @cipherExists(cipher)

  @encrypt: (data, key, cipher = @default) =>
    cipher = crypto.createCipher(@getCipher(cipher), key);
    cipher.update(data, inputEnc, outputEnc) + cipher.final(outputEnc)

  @decrypt: (data, key, cipher = @default) =>
    decipher = crypto.createDecipher(@getCipher(cipher), key)
    decipher.update(data, outputEnc, inputEnc) + decipher.final(inputEnc)