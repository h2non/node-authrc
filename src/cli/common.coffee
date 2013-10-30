path = require 'path'
Authrc = require '../authrc'
{ authRcFile } = require '../constants'
{ fileNotFound } = require './messages'
{ fileExists, dirExists, isArray, isObject, isString, validRegex, isRegex } = require '../common'

module.exports = class

  @isString: isString

  @isArray: isArray

  @isObject: isObject

  @validRegex: validRegex

  @isRegex: isRegex

  @echo: ->
    console.log.apply null, Array::slice.call arguments

  @exit: (code, msg) =>
    @echo msg if msg
    process.exit(code or 0)

  @getFilePath: (filepath) =>
    filepath ?= process.cwd()

    if dirExists filepath
      filepath = path.normalize path.join(filepath, authRcFile)

    filepath

  @fileExists: (filepath) =>
    unless fileExists filepath
      @exit 1, fileNotFound filepath

    filepath
  
  @createAuth: (filepath) =>
    try
      auth = new Authrc filepath
      auth.file = filepath
    catch err
      @exit 1, "Error reading .authrc file: #{err}".red

    auth