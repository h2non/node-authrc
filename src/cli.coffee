program = require 'commander'
pkg = require '../package.json'
{ log } = require './common'

[ 'create' ].map( (file) -> "./command/#{file}" ).forEach require

program
  .version(pkg.version)

program.on '--help', ->
  log """
      Usage examples:
    
      $ authrc auth set -u username -f ../.authrc
      $ authrc create --path /home/user/

  """

exports.parse = (args) -> program.parse args