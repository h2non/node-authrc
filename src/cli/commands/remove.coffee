program = require 'commander'
processes = require '../processes'
{ createAuth, getFilePath, fileExists, echo, exit  } = require '../common'

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
    
    filepath = fileExists getFilePath options.path
    auth = createAuth filepath

    host = auth.host hostname
    
    exit 0, "Host not found in #{filepath}" unless host.exists()

    host.remove()
    auth.save ->
      exit 0, "Host '#{hostname}' removed successfully in #{filepath}".green
      
