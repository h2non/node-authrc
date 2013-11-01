program = require 'commander'
{ fileExists, dirExists, isArray, isObject, isString, validRegex, isRegex, getHomePath } = require '../common'

module.exports = class

  @program: program

  @isString: isString

  @isArray: isArray

  @isObject: isObject

  @validRegex: validRegex

  @isRegex: isRegex

  @fileExists: fileExists

  @dirExists: dirExists

  @getHomePath: getHomePath

  @echo: ->
    console.log.apply null, Array::slice.call arguments

  @exit: (code, msg) =>
    @echo msg if msg
    process.exit(code or 0)
