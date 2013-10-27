prompt = require 'promptly'
{ ciphers, encrypt } = require '../crypto'
{ echo, exit } = require '../common'

module.exports = 

  createHost: (auth) ->
    hostTmpl = {}

    writeFile = ->
      prompt.confirm 'Do you want to save data? [Y/n]', (err, ok) ->
        exit 0, 'Canceled' if not ok
        auth.create hostTmpl, ->
          echo ''
          echo 'authrc created succesfully!'.green
          exit 0

    # temporal
    prompt.prompt 'Enter the host name: ', (err, value) ->
      exit 1, "Error:".red + "#{err}" if err

      host = hostTmpl[value] = {}

      prompt.prompt 'Enter the user name: ', (err, value) ->
        exit 1, "Error:".red + "#{err}" if err
        host.username = value

        prompt.password 'Enter the password: ', (err, value) ->
          exit 1, "Error:".red + "#{err}" if err
          password = value

          prompt.password 'Re-enter the password: ', (err, value) ->
            exit 1, "Error:".red + "#{err}" if err

            if password isnt value
              echo 'Error:'.red, 'The passwords did not match. Try again'
              exit 1
            host.password = value

            prompt.confirm 'Do you want to encrypt your password [Y/n]: ', (err, ok) ->
              return writeFile() if not ok

              echo '\nAvailable ciphers:'
              echo '-'.cyan, ciphers.join('\n- ').cyan

              prompt.choose 'Choose the cipher algorithm: ', ciphers, (err, value) ->

                plainPassword = host.password
                host.password = { cipher: value }

                prompt.password 'Enter the password key: ', (err, value) ->
                  exit 1, "Error:".red + "#{err}" if err

                  host.password.value = encrypt(plainPassword, value, host.password.cipher)
                  writeFile()