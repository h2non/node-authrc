{ echo } = require './common'

module.exports = class
  
  @helpCommands: ->
    echo 'Type --help to see the options available'

  @fileNotFound: (filepath) =>
    echo ".authrc file not found".red
    echo "Be sure the file exists in: #{filepath}"
    echo ''
    echo 'You can pass file path using the --path argument'
    echo 'Or use the global file using the --global argument'
    echo 'Aditionally you can use the "create" command to create a new file'
    echo ''
    @helpCommands()

  @fileAlreadyExists: (filepath) =>
    echo ".authrc file already exists in: #{filepath}".red
    echo 'Use the "add" command to add new hosts in the existent file'
    @helpCommands()
    