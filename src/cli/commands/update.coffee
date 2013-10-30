program = require 'commander'
processes = require '../processes'
{ createAuth, getFilePath, fileExists, echo, exit  } = require '../common'

program
  .command('update <host>')
  .description('\n  Update a host from .authrc'.cyan)
  .usage('<host>'.cyan)
  .option('-f, --path <path>', 'Path to the .authrc file'.cyan)
  .option('-u, --username <username>', 'New username value'.cyan)
  .on('--help', ->
    echo '''
          Usage examples:

            $ authrc update my.host.org 
            $ authrc update my.host.org --path /home/user/
            $ authrc update my.host.org --username john --path /home/user/

    '''
  )
  .action (hostname, options) ->
    
    filepath = fileExists getFilePath options.path
    auth = createAuth filepath
    host = auth.host hostname
    
    exit 0, "Host not found in #{filepath}" unless host.exists()

    if options.username?
      host.username options.username
      host.save ->
        exit 0, "Username value updated successfully for #{host.host}".green
    else
      processes.createCredentials (data) ->
        host.set data
        host.save ->
          exit 0, "Data updated successfuly for #{host.host}".green
