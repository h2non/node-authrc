processes = require '../processes'
{ createAuth, getFilePath, fileExists } = require '../commandHelper'
{ program, echo, exit } = require '../common'

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
  .action (search, options) ->
    
    filepath = fileExists getFilePath options.path
    auth = createAuth filepath
    host = auth.find search
    
    exit 2, "Host '#{search}' not found in #{filepath}" unless host.exists()
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
    