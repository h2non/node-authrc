fs = require 'fs'
path = require 'path'
{ expect } = require '../node_modules/chai/chai'
{ FILENAME } = require '../lib/constants'
Authrc = require '../lib/authrc'

describe 'authrc file discovery', ->
  auth = null

  getHomeVar = ->
    if process.platform is 'win32' then 'USERPROFILE' else 'HOME'

  setHomePath = (path) ->
    process.env[getHomeVar()] = path

  before ->
    cwdFile = path.join(process.cwd(), FILENAME)
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

      it 'should not be a global file path', ->
        expect(auth.isGlobalFile()).to.be.false

  describe 'auto discovery without defining a explicit path', ->

    describe 'wit existant file in the current working directory', ->
      cwd = process.cwd()

      before ->
        process.chdir 'test/fixtures/basic/'
   
      after ->
        process.chdir cwd

      beforeEach -> 
        auth = new Authrc

      it 'should not find the file and content exists', ->
        expect(auth.exists()).to.be.true

      it 'should not be a global file path', ->
        expect(auth.isGlobalFile()).to.be.false

    describe 'wit non-existant $HOME file', ->
      homePath = process.env[getHomeVar()]

      before ->
        setHomePath '/dev/null'
   
      after ->
        setHomePath(homePath)

      beforeEach -> 
        auth = new Authrc

      it 'should not find the file and the content not exists', ->
        expect(auth.exists()).to.be.false

      it 'should not be a global file path', ->
        expect(auth.isGlobalFile()).to.be.false

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
      
      it 'should be a global file path', ->
        expect(auth.isGlobalFile()).to.be.true


    describe 'using discover() method, with existent $HOME file', ->
      homePath = process.env[getHomeVar()]

      before ->
        setHomePath "#{__dirname}/fixtures/basic/"
   
      after ->
        setHomePath(homePath)

      it 'should find the file and the content exists', ->
        expect(Authrc.discover()).to.be.equal "#{__dirname}/fixtures/basic/.authrc"
      

