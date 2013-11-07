path = require 'path'
Authrc = require '../authrc'
{ FILENAME } = require '../constants'
{ fileNotFound, fileAlreadyExists } = require './messages'
{ fileExists, dirExists, exit, getHomePath } = require './common'

module.exports = class 

  @getFilePath: (filepath, global) =>
    if global
      filepath = getHomePath()
    else
      filepath ?= process.cwd()

    if dirExists filepath
      filepath = path.normalize path.join(filepath, FILENAME)

    filepath

  @fileExists: (filepath) =>
    unless fileExists(filepath)
      exit 1, fileNotFound filepath
    unless path.basename(filepath) is FILENAME
      exit 1, fileNotFound filepath

    filepath

  @fileNotExists: (filepath) =>
    if fileExists(filepath)
      exit 1, fileAlreadyExists filepath

    filepath
  
  @createAuth: (filepath) =>
    try
      auth = new Authrc filepath
      auth.file = filepath
    catch err
      exit 1, "Error reading .authrc file: #{err}".red

    auth