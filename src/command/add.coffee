program = require 'commander'
Authrc = require '../authrc'
{ echo, exit, fileExists } = require '../common'

program
  .command('add')
  .description('\n  Create new .authrc file'.cyan)
  .option('-p, --path <path>', 'Specify the .authrc file path'.cyan)
  .option('-y, --yes', 'Avoid prompt questions/confirmation'.cyan)
  .on('--help', ->
    echo """
        Usage examples:

        $ authrc add --path /home/user/
        
    """
  )
  .action (options) ->
    filepath = options.path or process.cwd()

    if dirExists(filepath)
      filepath = path.normalize(path.join(filepath, authRcFile))

    if not fileExists(filepath)
      filepath = path.normalize(path.join(getHomePath(), authRcFile))
      if not fileExists(filepath)
        echo 'Error:'.red, 'no authrc file found'
        echo 'Use '

    auth = new Authrc(filepath)
    auth.file = filepath

    echo """
    The file will be created in #{filepath}

    """

    createHost()