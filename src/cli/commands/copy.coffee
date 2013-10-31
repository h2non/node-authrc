processes = require '../processes'
{ createAuth, getFilePath, fileExists } = require '../commandHelper'
{ program, echo, exit } = require '../common'

program
  .command('copy <host> <newhost>')
  .description('\n  Copy existent host credentials to another host'.cyan)
  .option('-f, --path <path>', 'Path to the .authrc file'.cyan)
  .option('-g, --global', 'Use the .authrc file located in the user $HOME directory'.cyan)
  .on('--help', ->
    echo '''
          Usage examples:

            $ authrc copy server.org server.net
            $ authrc copy server.org server.net --path /home/user/

    '''
  )
  .action (search, newhost, options) ->

    filepath = fileExists getFilePath options.path
    auth = createAuth filepath
    host = auth.find search

    exit 0, "Host '#{search}' not found in #{filepath}" unless host.exists()

    auth.add newhost, host.get()
    auth.save ->
      exit 0, "host credentials copied successfully in #{filepath}".green
