fs = require 'fs'
suppose = require 'suppose'
{ expect } = require '../node_modules/chai/chai'
Authrc = require '../lib/authrc'

cwd = process.cwd()
authrcPath = 'test/fixtures/tmp/'

fileExists = ->
  fs.existsSync('.authrc')

removeFile = ->
  fs.unlink '.authrc' if fileExists()

describe 'Command-line testing', ->
  auth = null

  before ->
    process.chdir authrcPath
    removeFile()

  after ->
    removeFile()
    process.chdir cwd

  describe 'create command', ->  

    it 'should create a new .authrc file via prompt', (done) ->

      suppose("#{cwd}/bin/authrc", ['create'])
        #.debug(fs.createWriteStream('../../cli.log'))
        .on(/host name/).respond('my.server.org\n')
        .on(/user name/).respond('john\n')
        .on(/Enter the password:/).respond('p@ssw0rd\n')
        .on(/Confirm the password/).respond('p@ssw0rd\n')
        .on(/encrypt your password/).respond('y\n')
        .on(/Choose the cipher/).respond('blowfish\n')
        .on(/Enter the password key/).respond('d€cypt\n')
        .on(/Confirm the password key/).respond('d€cypt\n')
        .on(/Do you want to define a decrypt key/).respond('y\n')
        .on(/Enter the decrypt key environment variable/).respond('MY_SECRET_DECRYPT_KEY\n')
        .on(/Do you want to save/).respond('y\n')
      .error (err) ->
        throw new Error err
      .end (code) ->
        expect(code).to.be.equal(0)
        expect(fileExists()).to.be.true
        done()

    describe 'file contents are the expected', ->

      before ->
        auth = new Authrc

      before ->
        process.env['MY_SECRET_DECRYPT_KEY'] = 'd€cypt'

      after ->
        process.env['MY_SECRET_DECRYPT_KEY'] = ''

      it 'should exists data', ->
        expect(auth.exists()).to.be.true

      it 'should exists the created host', ->
        expect(auth.find('my.server.org').exists()).to.be.true

      it 'should be a valid host', ->
        expect(auth.find('my.server.org').valid()).to.be.true
      
      it 'should have an encrypted password', ->
        expect(auth.find('my.server.org').encrypted()).to.be.true

      it 'should have the expected cipher', ->
        expect(auth.find('my.server.org').cipher()).to.be.equal('blowfish')

      it 'should can be transparently decrypted', ->
        expect(auth.find('my.server.org').canDecrypt()).to.be.true

