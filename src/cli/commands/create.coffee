path = require 'path'
processes = require '../processes'
{ createAuth, getFilePath, fileExists } = require '../commandHelper'
{ program, echo, exit } = require '../common'

program
  .command('create')
  .description('\n  Create new .authrc file'.cyan)
  .option('-f, --path <path>', 'Path to place the .authrc created file'.cyan)
  .option('-g, --global', 'Use the .authrc file located in the user $HOME directory'.cyan)
  .option('-y, --force', 'Force the new file creation'.cyan)
  .on('--help', ->
    echo '''
          Usage examples:

            $ authrc create 
            $ authrc create --path /home/user/
        
    '''
  )
  .action (options) ->
    options.force ?= false
    filepath = getFilePath options.path, options.global
    
    fileExists filepath if options.force

    auth = createAuth filepath

    echo """
    The file will be created in #{filepath}

    """

    processes.createHost (data) ->
      try 
        auth.create data, ->
          exit 0, ".authrc file created successfully in #{path.dirname(filepath)}".green
      catch err
        exit 1, "Error while creating the file: #{err}".red
