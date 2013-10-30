path = require 'path'
program = require 'commander'
Authrc = require '../../authrc'
processes = require '../processes'
{ authRcFile } = require '../../constants'
{ echo, exit, fileExists, dirExists } = require '../../common'
{ fileAlreadyExists } = require '../messages'

program
  .command('create')
  .description('\n  Create new .authrc file'.cyan)
  .option('-f, --path <path>', 'Path to place the .authrc created file'.cyan)
  .option('-y, --force', 'Force the new file creation'.cyan)
  .on('--help', ->
    echo '''
          Usage examples:

            $ authrc create 
            $ authrc create --path /home/user/
        
    '''
  )
  .action (options) ->
    filepath = options.path or process.cwd()
    options.force ?= false

    if dirExists filepath
      filepath = path.normalize path.join(filepath, authRcFile)
    
    unless options.force
      if fileExists filepath
        fileAlreadyExists filepath
        exit 0

    try
      auth = new Authrc filepath
      auth.file = filepath
    catch err
      exit 1, "Error reading .authrc file: #{err}".red

    echo """
    The file will be created in #{filepath}

    """

    processes.createHost (data) ->
      try 
        auth.create data, ->
          exit 0, ".authrc file created successfully in #{path.dirname(filepath)}".green
      catch err
        exit 1, "Error while creating the file: #{err}".red
