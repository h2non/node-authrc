program = require 'commander'
pkg = require '../package.json'
{ log } = require './common'

[ 'auth', 'package' ]
  .map (file) -> './command/' + file
  .forEach require

program
  .version(pkg.version)

program.on '--help', ->
  log """
      Usage examples:
    
      $ authrc auth set -u username -f ../.authrc
      $ authrc encrypt package node.js -o myOrganization

  """

exports.parse = (args) -> program.parse args