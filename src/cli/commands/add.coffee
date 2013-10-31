processes = require '../processes'
{ createAuth, getFilePath, fileExists } = require '../commandHelper'
{ program, echo, exit  } = require '../common'

program
  .command('add')
  .description('\n  Add new host to an existant .authrc file'.cyan)
  .option('-f, --path <path>', 'Path to the .authrc file'.cyan)
  .on('--help', ->
    echo '''
          Usage examples:

            $ authrc add 
            $ authrc add --path /home/user/

    '''
  )
  .action (options) ->

    filepath = fileExists getFilePath options.path
    auth = createAuth filepath

    echo """
    Changes will be applied to: #{filepath}

    """.green

    processes.createHost (data) ->
      auth.add data
      auth.save ->
        exit 0, 'host added successfully!'.green
