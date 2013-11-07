crypto = require 'crypto'
ciphers = require './ciphers'
{ ALGORITHM, INPUT_ENC, OUTPUT_ENC } = require './constants'
{ lowerCase } = require './common'

module.exports = class

  @defaultCipher: ALGORITHM

  @ciphers: Object.keys ciphers

  @cipherExists: (cipher) ->
    ciphers.hasOwnProperty lowerCase(cipher)

  @getCipher: (cipher) =>
    ciphers[lowerCase(cipher)] if @cipherExists cipher

  @encrypt: (data, key, cipher = ALGORITHM) =>
    cipher = crypto.createCipher @getCipher(cipher), key
    cipher.update(data, INPUT_ENC, OUTPUT_ENC) + cipher.final OUTPUT_ENC

  @decrypt: (data, key, cipher = ALGORITHM) =>
    decipher = crypto.createDecipher @getCipher(cipher), key
    decipher.update(data, OUTPUT_ENC, INPUT_ENC) + decipher.final INPUT_ENC