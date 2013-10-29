path = require 'path'
program = require 'commander'
Authrc = require '../../authrc'
{ authRcFile } = require '../../constants'
{ echo, exit, fileExists, dirExists } = require '../../common'
{ fileNotFound } = require '../messages'
processes = require '../processes'

program
  .command('add')
  .description('\n  Add new host to an existant .authrc file'.cyan)
  .option('-f, --path <path>', 'Path to the .authrc file'.cyan)
  .on('--help', ->
    echo '''
          Usage examples:

            $ authrc add 
            $ authrc add --path /home/user/
        
    '''
  )
  .action (options) ->
    filepath = options.path or process.cwd()

    if dirExists filepath
      filepath = path.normalize path.join(filepath, authRcFile)

    unless fileExists filepath
      fileNotFound filepath
      exit 1

    try
      auth = new Authrc filepath
      auth.file = filepath
    catch err
      exit 1, "Error reading .authrc file: #{err}".red

    echo """
    Changes will be applied to: #{filepath}

    """

    processes.createHost (data) ->
      auth.add data
      auth.save ->
        exit 0, 'host added successfully!'.green
