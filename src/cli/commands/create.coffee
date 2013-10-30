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
  .on('--help', ->
    echo '''
          Usage examples:

            $ authrc create 
            $ authrc create --path /home/user/
        
    '''
  )
  .action (options) ->
    filepath = options.path or process.cwd()

    if dirExists filepath
      filepath = path.normalize path.join(filepath, authRcFile)
    
    if fileExists filepath
      fileAlreadyExists()
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
      
