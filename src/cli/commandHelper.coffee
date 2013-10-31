path = require 'path'
Authrc = require '../authrc'
{ authRcFile } = require '../constants'
{ fileNotFound } = require './messages'
{ fileExists, dirExists, exit } = require './common'

module.exports = class 

  @getFilePath: (filepath) =>
    filepath ?= process.cwd()

    if dirExists filepath
      filepath = path.normalize path.join(filepath, authRcFile)

    filepath

  @fileExists: (filepath) =>
    unless fileExists filepath
      exit 1, fileNotFound filepath

    filepath
  
  @createAuth: (filepath) =>
    try
      auth = new Authrc filepath
      auth.file = filepath
    catch err
      exit 1, "Error reading .authrc file: #{err}".red

    auth