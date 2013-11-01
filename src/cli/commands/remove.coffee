processes = require '../processes'
{ createAuth, getFilePath, fileExists } = require '../commandHelper'
{ program, echo, exit } = require '../common'

program
  .command('remove <host>')
  .description('\n  Remove a host from .authrc'.cyan)
  .usage('<host>'.cyan)
  .option('-f, --path <path>', 'Path to the .authrc file'.cyan)
  .option('-g, --global', 'Use the .authrc file located in the user $HOME directory'.cyan)
  .on('--help', ->
    echo '''
          Usage examples:

            $ authrc remove my.host.org 
            $ authrc remove my.host.org --path /home/user/
            $ authrc remove my.host.org --global
        
    '''
  )
  .action (hostname, options) ->
    
    filepath = fileExists getFilePath options.path, options.global
    auth = createAuth filepath

    host = auth.host hostname
    
    exit 0, "Host '#{search}' not found in #{filepath}" unless host.exists()

    host.remove()
    auth.save ->
      exit 0, "Host '#{hostname}' removed successfully in #{filepath}".green
      
