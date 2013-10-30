path = require 'path'
program = require 'commander'
Authrc = require '../../authrc'
processes = require '../processes'
{ authRcFile } = require '../../constants'
{ echo, exit, fileExists, dirExists } = require '../../common'
{ fileNotFound } = require '../messages'

program
  .command('add')
  .description('\n  Copy and existent host credentials to another host'.cyan)
  .option('-f, --path <path>', 'Path to the .authrc file'.cyan)
  .on('--help', ->
    echo '''
          Usage examples:

            $ authrc copy 
            $ authrc copy --path /home/user/
        
    '''
  )
  .action (options) ->
    filepath = do -> 
      options.path or process.cwd()

      if dirExists filepath
        filepath = path.normalize path.join(filepath, authRcFile)

      unless fileExists filepath
        exit 1, fileNotFound filepath

    try
      auth = new Authrc filepath
      auth.file = filepath
    catch err
      exit 1, "Error reading .authrc file: #{err}".red

    echo """
    Changes will be applied to: #{filepath}

    """

    processes.copyHost (data) ->
      auth.add data
      auth.save ->
        exit 0, 'host added successfully!'.green
