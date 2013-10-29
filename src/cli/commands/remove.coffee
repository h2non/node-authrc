path = require 'path'
program = require 'commander'
Authrc = require '../../authrc'
{ authRcFile } = require '../../constants'
{ echo, exit, fileExists, dirExists } = require '../../common'
{ fileNotFound } = require '../messages'
processes = require '../processes'

program
  .command('remove <host>')
  .description('\n  Remove a host from .authrc'.cyan)
  .usage('<host>'.cyan)
  .option('-f, --path <path>', 'Path to the .authrc file'.cyan)
  .on('--help', ->
    echo '''
          Usage examples:

            $ authrc remove my.host.org 
            $ authrc remove my.host.org --path /home/user/
        
    '''
  )
  .action (hostname, options) ->
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

    host = auth.host hostname
    
    exit 0, "Host not found in #{filepath}" unless host.exists()

    host.remove()
    auth.save ->
      exit 0, "Host '#{hostname}' removed successfully in #{filepath}".green
      
