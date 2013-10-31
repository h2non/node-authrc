processes = require '../processes'
{ createAuth, getFilePath, fileExists } = require '../commandHelper'
{ program, echo, exit  } = require '../common'

program
  .command('list')
  .description('\n  List the current existent hosts in .authrc'.cyan)
  .option('-f, --path <path>', 'Path to the .authrc file'.cyan)
  .on('--help', ->
    echo '''
          Usage examples:

            $ authrc list 
            $ authrc list --path /home/user/
        
    '''
  )
  .action (options) ->

    auth = createAuth fileExists getFilePath options.path
    
    exit 0, echo auth.hosts().join('\n')