path = require 'path'
program = require 'commander'
Authrc = require '../../authrc'
{ authRcFile } = require '../../constants'
{ echo, exit, fileExists, dirExists } = require '../../common'
processes = require '../processes'

program
  .command('remove <host>')
  .description('\n  Remove a host from .authrc'.cyan)
  .usage('<host>'.cyan)
  .option('-p, --path <path>', 'Path to the .authrc file'.cyan)
  .on('--help', ->
    echo '''
          Usage examples:

            $ authrc remove my.host.org 
            $ authrc remove my.host.org:8080 --path /home/user/
        
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

    try
      auth = new Authrc(filepath)
      auth.file = filepath
    catch err
      exit 1, "Error reading .authrc file: #{err}".red

    host = auth.host(hostname)
    
    exit 0, "Hostname not found in #{filepath}" unless host.exists()

    host.remove()
    auth.save ->
      exit 0, "Host '#{hostname}' removed successfully in #{filepath}".green
      
