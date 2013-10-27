program = require 'commander'
pkg = require '../package.json'
{ echo } = require './common'

[ 'create', 'add', 'remove', 'update' ].map( (file) -> "./cli/commands/#{file}" ).forEach require

program
  .version(pkg.version)

program.on '--help', ->
  echo """
      Usage examples:
    
        $ authrc create --path /home/user/
        $ authrc add set -u username --path ./.authrc
        $ authrc remove <hostname> 
        $ authrc update <hostname>

  """

exports.parse = (args) -> program.parse args