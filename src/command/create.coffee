path = require 'path'
program = require 'commander'
prompt = require 'promptly'
Authrc = require '../authrc'
{ authRcFile } = require '../constants'
{ echo, exit, fileExists, dirExists } = require '../common'
{ createHost } = require './actions'

program
  .command('create')
  .description('\n  Create new .authrc file'.cyan)
  #.usage('<upload|publish|maven> <organization> <repository> <pkgname>')
  .option('-p, --path <path>', 'Path place the .authrc created file'.cyan)
  .on('--help', ->
    echo """
        Usage examples:

        $ authrc create --path /home/user/
        
    """
  )
  .action (options) ->
    filepath = options.path or process.cwd()

    if dirExists(filepath)
      filepath = path.normalize(path.join(filepath, authRcFile))

    if fileExists(filepath)
      echo 'Error:'.red, ".authrc file already exists in: #{filepath}"
      echo "Type --help to see other available commands"
      exit(0)

    auth = new Authrc(filepath)
    auth.file = filepath

    echo """
    The file will be created in #{filepath}

    """

    createHost(auth)
