path = require 'path'
program = require 'commander'
Authrc = require '../../authrc'
{ authRcFile } = require '../../constants'
{ echo, exit, fileExists, dirExists } = require '../../common'
processes = require '../processes'

program
  .command('update <host>')
  .description('\n  Update a host from .authrc'.cyan)
  .usage('<host>'.cyan)
  .option('-p, --path <path>', 'Path to the .authrc file'.cyan)
  .option('-u, --username <username>', 'New username value'.cyan)
  .on('--help', ->
    echo '''
          Usage examples:

            $ authrc update my.host.org 
            $ authrc update my.host.org:8080 --path /home/user/
        
    '''
  )
  .action (hostname, options) ->
    filepath = options.path or process.cwd()

    if dirExists(filepath)
      filepath = path.normalize(path.join(filepath, authRcFile))

    unless fileExists(filepath)
      echo ".authrc file not found".red
      echo 'Be sure the path is correct. You can use the command "create" instead'
      echo "Type --help to see other available commands"
      exit 0

    auth = new Authrc(filepath)
    auth.file = filepath

    host = auth.host(hostname)
    
    exit 0, "Hostname not found in #{filepath}" unless host.exists()

    if options.username?
      host.username(options.username)
      host.save ->
        exit 0, "Username valued updated successfully for #{host.host}"
    else
      processes.createHost ->
        host.save ->
          exit 0, "Data updated successfuly for #{host.host}"
