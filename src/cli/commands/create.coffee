path = require 'path'
program = require 'commander'
Authrc = require '../../authrc'
{ authRcFile } = require '../../constants'
{ echo, exit, fileExists, dirExists } = require '../../common'
processes = require '../processes'

program
  .command('create')
  .description('\n  Create new .authrc file'.cyan)
  .option('-p, --path <path>', 'Path to place the .authrc created file'.cyan)
  .on('--help', ->
    echo '''
          Usage examples:

            $ authrc create 
            $ authrc create --path /home/user/
        
    '''
  )
  .action (options) ->
    filepath = options.path or process.cwd()

    if dirExists(filepath)
      filepath = path.normalize(path.join(filepath, authRcFile))

    if fileExists(filepath)
      echo ".authrc file already exists in: #{filepath}".red
      echo 'Use command "add" instead of "create"'
      echo "Type --help to see other available commands"
      exit 0

    try
      auth = new Authrc(filepath)
      auth.file = filepath
    catch err
      exit 1, "Error reading .authrc file: #{err}".red

    echo """
    The file will be created in #{filepath}

    """

    processes.createHost (data) ->
      auth.create data, ->
        exit 0, ".authrc file created successfully in #{path.dirname(filepath)}".green
