prompt = require './prompt'
async = require 'async'
validator = require './validator'
{ ciphers, encrypt, defaultCipher } = require '../crypto'
{ echo, exit, isArray, isString, isObject } = require '../common'

module.exports = 

  createCredentials: (successFn) ->
    authObj = null

    promptUsername = (done) ->
      prompt.username (input) ->
        host.username = input
        done()

    promptPassword = (done) ->
      prompt.password (input) ->
        host.password = input
        done()

    promptEncrypt = (done) ->
      prompt.confirm 'Do you want to encrypt your password', (ok) ->
        return promptSaveFile() unless ok
        done()

    promptChooseCipher = (done) ->
      echo ''
      echo 'Supported ciphers:'
      ciphers.forEach (cipher) ->
        echo "- #{cipher}".cyan + if cipher is defaultCipher then ' (recommended)'.cyan  else ''
      echo ''

      prompt.choose 'Choose the cipher algorithm: ', ciphers, (input) ->
        plainPassword = host.password
        host.password = { cipher: input }
        done()

    promptPasswordKey = (done) ->
      prompt.password 'the password key', { validator: validator.password }, (input) ->
        host.password.value = encrypt(plainPassword, value, host.password.cipher)
        done()

    promptSaveFile = (done) ->
      prompt.confirm 'Do you want to save? [Y/n]', (ok) ->
        exit 0, 'Canceled' unless ok
        successFn(authObj)
        done()

    async.series [
      promptUsername
      promptPassword
      promptEncrypt
      promptChooseCipher
      promptPasswordKey
      promptSaveFile
    ]

  createHost: (successFn) ->
    host = null
    hostObj = {}

    promptHostname = (done) ->
      prompt.hostname (input) ->
        host = hostObj[input] = {}
        done()

    createCredentials = (done) =>
      @createCredentials ->
        successFn()
        done()

    ###
    promptUsername = (done) ->
      prompt.username (input) ->
        host.username = input
        done()

    promptPassword = (done) ->
      prompt.password (input) ->
        host.password = input
        done()

    promptEncrypt = (done) ->
      prompt.confirm 'Do you want to encrypt your password', (ok) ->
        return promptSaveFile() unless ok
        done()

    promptChooseCipher = (done) ->
      echo ''
      echo 'Supported ciphers:'
      ciphers.forEach (cipher) ->
        echo "- #{cipher}".cyan + if cipher is defaultCipher then ' (recommended)'.cyan  else ''
      echo ''

      prompt.choose 'Choose the cipher algorithm: ', ciphers, (input) ->
        host.password = { cipher: input, value: host.password }
        done()

    promptPasswordKey = (done) ->
      prompt.password 'the password key', { validator: validator.password }, (input) ->
        host.password.value = encrypt(host.password.value, value, host.password.cipher)
        done()

    promptSaveFile = ->
      prompt.confirm 'Do you want to save? [Y/n]', (ok) ->
        exit 0, 'Canceled' unless ok
        successFn(hostObj)

    ###

    async.series [
      promptHostname
      createCredentials
    ]
