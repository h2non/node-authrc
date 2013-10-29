{ echo } = require '../common'

module.exports = class
  
  @helpCommands: ->
    echo 'Type --help to see other available commands'

  @fileNotFound: (filepath) =>
    echo ".authrc file not found".red
    echo "Be sure the file exists: #{filepath}"
    echo 'You can use the "create" command to create a new one'
    @helpCommands()

  @fileAlreadyExists: (filepath) =>
    echo ".authrc file already exists in: #{filepath}".red
    echo 'Use the "add" command to add new hosts in the existent file'
    @helpCommands()
    