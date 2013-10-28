prompt = require './prompt'
async = require 'async'
{ ciphers, encrypt, defaultCipher } = require '../crypto'
{ echo, exit } = require '../common'

module.exports = 

  createCredentials: (successFn) ->
    authObj = {}

    promptUsername = (done) ->
      prompt.username (input) ->
        authObj.username = input
        done()

    promptPassword = (done) ->
      prompt.password true, (input) ->
        authObj.password = input
        done()

    promptEncrypt = (done) ->
      prompt.confirm 'Do you want to encrypt your password', (ok) ->
        return promptSaveFile() unless ok
        done()

    promptChooseCipher = (done) ->
      echo ''
      echo 'Supported ciphers:'
      ciphers.forEach (cipher) ->
        echo "- #{cipher}".cyan + if cipher is defaultCipher then ' (recommended)'.cyan else ''
      echo ''

      prompt.choose 'Choose the cipher algorithm', ciphers, (input) ->
        authObj.password = { cipher: input, value: authObj.password }
        done()

    promptPasswordKey = (done) ->
      prompt.password 'the password key', (input) ->
        authObj.password.value = encrypt(authObj.password.value, input, authObj.password.cipher)
        done()

    promptDecryptKey = (done) ->
      prompt.confirm 'Do you want to define a decrypt key', (ok) ->
        return promptSaveFile() unless ok
        done()

    promptDecryptKeyValue = (done) ->
      prompt.enter 'Enter the descrypt key environment variable (case sensitive)', (input) ->
        authObj.password.envKey = input
        done()

    promptSaveFile = ->
      prompt.confirm 'Do you want to save?', (ok) ->
        exit 0, 'Canceled' unless ok
        successFn(authObj)

    async.series [
      promptUsername
      promptPassword
      promptEncrypt
      promptChooseCipher
      promptPasswordKey
      promptDecryptKey
      promptDecryptKeyValue
      promptSaveFile
    ]

  createHost: (successFn) ->
    hostObj = {}
    host = null

    promptHostname = (done) ->
      prompt.hostname (input) ->
        host = input
        done()

    createCredentials = (done) =>
      @createCredentials (authObj) ->
        hostObj[host] = authObj
        successFn(hostObj)
        done()

    async.series [
      promptHostname
      createCredentials
    ]
