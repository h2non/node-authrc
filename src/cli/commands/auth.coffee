path = require 'path'
program = require 'commander'
Authrc = require '../../authrc'
processes = require '../processes'
{ authRcFile } = require '../../constants'
{ echo, exit, fileExists, dirExists } = require '../../common'
{ fileNotFound } = require '../messages'

program
  .command('auth <host>')
  .description('\n  Get the authencation credentials from the given host'.cyan)
  .usage('<host>'.cyan)
  .option('-f, --path <path>', 'Path to the .authrc file directory'.cyan)
  .option('-u, --user', 'Get the host username value'.cyan)
  .option('-p, --password', 'Get the host password value'.cyan)
  .option('-c, --cipher', 'Get the password cipher (if it is encrypted)'.cyan)
  .on('--help', ->
    echo '''
          Usage examples:

            $ authrc auth my.host.org 
            $ authrc auth my.host.org --path /home/user/
            $ authrc auth my.host.org -cup --path /home/user/
        
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

    host = auth.find hostname
    
    exit 2, "Host '#{hostname}' not found in #{filepath}" unless host.exists()
    exit 1, "Host invalid '#{host.host}'. Check the file: #{filepath}" unless host.valid()

    { user, password } = options
    if user or password 
      echo host.username() if user
      echo host.password() if password
    else
      { username, password } = host.auth()
      echo username
      echo password

    echo host.cipher() if options.cipher and host.encrypted()
    