fs = require 'fs'
path = require 'path'
{ expect } = require '../node_modules/chai/chai'
{ authRcFile } = require '../lib/constants'
Authrc = require '../lib/authrc'

describe 'authrc file discovery', ->
  auth = null

  getHomeVar = ->
    if process.platform is 'win32' then 'USERPROFILE' else 'HOME'

  setHomePath = (path) ->
    process.env[getHomeVar()] = path

  before ->
    cwdFile = path.join(process.cwd(), authRcFile)
    fs.unlinkSync(cwdFile) if fs.existsSync(cwdFile)

  describe 'using explicit file path with relative path', ->

    beforeEach -> 
      auth = new Authrc('test/fixtures/basic/.authrc')

    it 'should find the file and content exists', ->
      expect(auth.exists()).to.be.true
      expect(auth.host('http://git.server.org').exists()).to.be.true

  describe 'using explicit file directory with relative path', ->

    beforeEach -> 
      auth = new Authrc('test/fixtures/basic')

    it 'should find the file and the content exists', ->
      expect(auth.exists()).to.be.true
      expect(auth.host('http://git.server.org').exists()).to.be.true

  describe 'using explicit invalid file path', ->
    homePath = process.env[getHomeVar()]

    before ->
      setHomePath '/dev/null'
 
    after ->
      setHomePath(homePath)

    describe 'setting relative path', ->

      beforeEach -> 
        auth = new Authrc('test/fixtures/nonexistent')

      it 'should not find the file and the content not exists', ->
        expect(auth.exists()).to.be.false

    describe 'setting absolute path', ->

      beforeEach -> 
        auth = new Authrc(__dirname)

      it 'should not find the file and the content not exists', ->
        expect(auth.exists()).to.be.false


  describe 'without defining a explicit path', ->

    describe 'without existant $HOME file', ->
      homePath = process.env[getHomeVar()]

      before ->
        setHomePath '/dev/null'
   
      after ->
        setHomePath(homePath)

      beforeEach -> 
        auth = new Authrc

      it 'should not find the file and the content not exists', ->
          expect(auth.exists()).to.be.false

    describe 'with existent $HOME file', ->
      homePath = process.env[getHomeVar()]

      before ->
        setHomePath "#{__dirname}/fixtures/basic/"
   
      after ->
        setHomePath(homePath)

      beforeEach -> 
        auth = new Authrc

      it 'should find the file and the content exists', ->
        expect(auth.exists()).to.be.true

