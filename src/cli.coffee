program = require 'commander'
pkg = require '../package.json'
{ echo } = require './common'

[ 'create', 'add', 'remove', 'update', 'auth', 'decrypt', 'encrypt' ].map( (file) -> "./cli/commands/#{file}" ).forEach require

program
  .version(pkg.version)
  .option('-I, --implementation', '''
    Current authrc implementation language
                          Useful for multiple installed implementations
    ''')

program.on 'implementation', ->
  echo 'node'

program.on '--help', ->
  echo """
      Usage examples:
    
        $ authrc create --path /home/user/
        $ authrc add 
        $ authrc remove my.host.org
        $ authrc update my.host.org
        $ authrc decrypt e9b90003128c4215ba005a08615fa64f
        $ authrc encrypt p@sw0rd

  """

exports.parse = (args) -> program.parse args