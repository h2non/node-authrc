fs = require 'fs'
path = require 'path'
{ parse, format } = require 'url'

module.exports = 

  getHomePath: ->
    path.normalize process.env[(if (process.platform is 'win32') then 'USERPROFILE' else 'HOME')]

  isUri: (string) ->
    { protocol, hostname } = parse(string)
    protocol? and hostname?

  parseUri: (string) ->
    host = parse(string)
    # add support for aditional protocols
    if not host.protocol or string.indexOf('://') is -1
      host = arguments.callee('http://' + string)
    host

  formatUri: (object) ->
    format(object)

  readJSON: (filepath) ->
    JSON.parse(fs.readFileSync(filepath))

  lowerCase: (string) ->
    string = string.toLowerCase() if typeof string is 'string'
    string
