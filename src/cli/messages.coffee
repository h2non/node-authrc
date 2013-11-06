{ echo } = require './common'

module.exports = class
  
  @helpCommands: ->
    echo ''
    echo 'Type --help to see the full options available'

  @fileNotFound: (filepath) =>
    echo ".authrc file not found".red
    echo "Be sure the file exists in: #{filepath}"
    echo ''
    echo 'You can pass file path using the --path argument'
    echo 'Or use the global file using the --global argument'
    echo 'Aditionally you can use the "create" command to create a new file'
    @helpCommands()

  @fileAlreadyExists: (filepath) =>
    echo ".authrc file already exists in: #{filepath}".red
    echo 'Use the "add" command to add new hosts in the existent file'
    echo 'Or use the --force flag to override it'
    @helpCommands()
    