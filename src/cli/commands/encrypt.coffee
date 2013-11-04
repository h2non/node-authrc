crypto = require '../../crypto'
processes = require '../processes'
{ program, echo, exit } = require '../common'

program
  .command('encrypt <password>')
  .description('\n  Utility for easy password encryption'.cyan)
  .usage('<password>'.cyan)
  .option('-k, --key <key>', 'Set the password encryption key'.cyan)
  .option('-c, --cipher <cipher>', 'Specify the decryption cipher algorithm to use'.cyan)
  .on('--help', ->
    echo '''
          Usage examples:

            $ authrc encrypt p@sw0rd
            $ authrc encrypt p@sw0rd -c idea -k '@_$vp€R~k3y'
        
    '''
  )
  .action (password, options) ->

    options.cipher ?= 'aes128'

    encrypt = ->
      unless crypto.cipherExists(options.cipher)
        exit 1, "Cipher algorithm '#{options.cipher}' not supported"
      try
        echo crypto.encrypt password, options.key, options.cipher
      catch err
        exit 1, "Error while encrypting the password: #{err}"

    unless options.key
      processes.passwordAsk (key) ->
        options.key = key
        encrypt()
    else
      encrypt()

    exit 0
