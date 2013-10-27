path = require 'path'
program = require 'commander'
Authrc = require '../../authrc'
{ authRcFile } = require '../../constants'
{ echo, exit, fileExists, dirExists } = require '../../common'
processes = require '../processes'

program
  .command('add')
  .description('\n  Add new host to an existant .authrc file'.cyan)
  .option('-p, --path <path>', 'Path to the .authrc file'.cyan)
  .on('--help', ->
    echo '''
          Usage examples:

            $ authrc add 
            $ authrc add --path /home/user/
        
    '''
  )
  .action (options) ->
    filepath = options.path or process.cwd()

    if dirExists(filepath)
      filepath = path.normalize(path.join(filepath, authRcFile))

    unless fileExists(filepath)
      echo ".authrc file not found".red
      echo 'Be sure the path is correct. You can use the command "create" instead'
      echo "Type --help to see other available commands"
      exit 0

    auth = new Authrc(filepath)
    auth.file = filepath

    echo """
    Changes will be applied to: #{filepath}

    """

    processes.createHost (data) ->
      auth.add data
      auth.save ->
        exit 0, 'host added successfully!'.green
