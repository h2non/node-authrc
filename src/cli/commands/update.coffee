processes = require '../processes'
{ createAuth, getFilePath, fileExists } = require '../commandHelper'
{ program, echo, exit } = require '../common'

program
  .command('update <host>')
  .description('\n  Update a host from .authrc'.cyan)
  .usage('<host>'.cyan)
  .option('-f, --path <path>', 'Path to the .authrc file'.cyan)
  .option('-g, --global', 'Use the .authrc file located in the user $HOME directory'.cyan)
  .option('-u, --username <username>', 'New username value'.cyan)
  .on('--help', ->
    echo '''
          Usage examples:

            $ authrc update my.host.org 
            $ authrc update my.host.org --path /home/user/
            $ authrc update my.host.org --global
            $ authrc update my.host.org --username john --path /home/user/

    '''
  )
  .action (search, options) ->
    
    filepath = fileExists getFilePath options.path, options.global
    auth = createAuth filepath
    host = auth.find search
    
    exit 0, "Host '#{search}' not found in #{filepath}" unless host.exists()

    if options.username?
      host.username options.username
      host.save ->
        exit 0, "Username value updated successfully for #{host.host}".green
    else
      processes.createCredentials (data) ->
        host.set data
        host.save ->
          exit 0, "Data updated successfuly for #{host.host}".green
