fs = require 'fs'
suppose = require 'suppose'
{ expect } = require 'chai'
Authrc = require '../lib/authrc'

cwd = process.cwd()
authrcPath = 'test/fixtures/tmp/'

fileExists = ->
  fs.existsSync('.authrc')

removeFile = ->
  fs.unlink '.authrc' if fileExists()

describe 'CLI', ->
  auth = null

  before ->
    process.chdir authrcPath
    removeFile()

  after ->
    removeFile()
    process.chdir cwd

  describe 'create command', ->  

    it 'should create a new .authrc file', (done) ->

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

  describe 'add command', ->  

    it 'should add a new host in an existent .authrc file', (done) ->

      suppose("#{cwd}/bin/authrc", ['add'])
        .on(/host name/).respond('my.site.org\n')
        .on(/user name/).respond('michael\n')
        .on(/Enter the password:/).respond('p@ssw0rd\n')
        .on(/Confirm the password/).respond('p@ssw0rd\n')
        .on(/encrypt your password/).respond('n\n')
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

      it 'should exists data', ->
        expect(auth.exists()).to.be.true

      it 'should exists the created host', ->
        expect(auth.find('my.site.org').exists()).to.be.true

      it 'should be a valid host', ->
        expect(auth.find('my.site.org').valid()).to.be.true
      
      it 'should not have an encrypted password', ->
        expect(auth.find('my.site.org').encrypted()).to.be.false

  describe 'update command', ->  

    it 'should add a update a host in an existent .authrc file', (done) ->

      suppose("#{cwd}/bin/authrc", ['update', 'my.site.org'])
        .on(/user name/).respond('john\n')
        .on(/Enter the password:/).respond('n€w_p@ssw0rd\n')
        .on(/Confirm the password/).respond('n€w_p@ssw0rd\n')
        .on(/encrypt your password/).respond('n\n')
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

      it 'should exists data', ->
        expect(auth.exists()).to.be.true

      it 'should exists the created host', ->
        expect(auth.find('my.site.org').exists()).to.be.true

      it 'should be a valid host', ->
        expect(auth.find('my.site.org').valid()).to.be.true
      
      it 'should have the new username', ->
        expect(auth.find('my.site.org').user()).to.be.equal('john')

      it 'should have the new password', ->
        expect(auth.find('my.site.org').password()).to.be.equal('n€w_p@ssw0rd')

  describe 'list command', ->  

    it 'should list the existent hosts', (done) ->

      suppose("#{cwd}/bin/authrc", ['list'])
        .error (err) ->
          throw new Error err
        .end (code) ->
          expect(code).to.be.equal(0)
          expect(fileExists()).to.be.true
          done()

  describe 'copy command', ->  

    it 'should copy a host in an existent .authrc file', (done) ->

      suppose("#{cwd}/bin/authrc", ['copy', 'my.site.org', 'new.site.org'])
        .error (err) ->
          throw new Error err
        .end (code) ->
          expect(code).to.be.equal(0)
          expect(fileExists()).to.be.true
          done()

  describe 'remove command', ->  

    it 'should remove a host in an existent .authrc file', (done) ->

      suppose("#{cwd}/bin/authrc", ['remove', 'my.site.org'])
        .error (err) ->
          throw new Error err
        .end (code) ->
          expect(code).to.be.equal(0)
          expect(fileExists()).to.be.true
          done()

    describe 'file contents are the expected', ->

      before ->
        auth = new Authrc

      it 'should exists data', ->
        expect(auth.exists()).to.be.true

      it 'should be removed the host', ->
        expect(auth.find('my.site.org').exists()).to.be.false

  describe 'encrypt command', ->  

    it 'should encrypt a password property', (done) ->

      suppose("#{cwd}/bin/authrc", ['encrypt', 'p@s$w0rd'])
        .on(/Enter the password key/).respond('my-d€crypt_k3y\n')
        .error (err) ->
          throw new Error err
        .end (code) ->
          expect(code).to.be.equal(0)
          done()

  describe 'encrypt command', ->  

    it 'should encrypt a password property', (done) ->

      suppose("#{cwd}/bin/authrc", ['decrypt', '8a87a8de71a9fab17af597dcd691d13d'])
        .on(/Enter the password key/).respond('my-d€crypt_k3y\n')
        .error (err) ->
          throw new Error err
        .end (code) ->
          expect(code).to.be.equal(0)
          done()
