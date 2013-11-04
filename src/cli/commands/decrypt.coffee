crypto = require '../../crypto'
processes = require '../processes'
{ program, echo, exit } = require '../common'

program
  .command('decrypt <password>')
  .description('\n  Utility for easy password decryption'.cyan)
  .usage('<password>'.cyan)
  .option('-k, --key <key>', 'Set the password decryption key'.cyan)
  .option('-c, --cipher <cipher>', 'Specify the decryption cipher algorithm to use'.cyan)
  .on('--help', ->
    echo '''
          Usage examples:

            $ authrc decrypt e9b90003128c4215ba005a08615fa64f
            $ authrc decrypt e9b90003128c4215ba005a08615fa64f -c aes128 -k '@_$vp€R~k3y'
        
    '''
  )
  .action (password, options) ->

    options.cipher ?= 'aes128'

    decrypt = ->
      unless crypto.cipherExists(options.cipher)
        exit 1, "Cipher algorithm '#{options.cipher}' not supported"
      try
        echo crypto.decrypt password, options.key, options.cipher
      catch err
        exit 1, "Error while decrypting the password: #{err}"

    unless options.key
      processes.passwordAsk (key) ->
        options.key = key
        decrypt()
    else
      decrypt()

    exit 0
