{ expect } = require '../node_modules/chai/chai'
Authrc = require '../lib/authrc'

describe 'Destructive malefic testing', ->
  key = '@_$vp€R~k3y'
  auth = null

  describe 'bad formed .authrc file', ->

    describe 'bad formed host regular expression', ->

      it 'should not throw an exception while read the file', ->
        expect(-> auth = new Authrc('test/fixtures/bad_formed/.authrc') ).to.not.throw

      describe 'host matching', ->

        before ->
          auth = new Authrc('test/fixtures/bad_formed/.authrc')

        it 'should be an valid file with contents', ->
          expect(auth.exists()).to.be.true

        it 'should host to be invalid regex', ->
          expect(auth.host('my.server.org').valid()).to.be.false

        it 'should return an empty username', ->
          expect(auth.host('my.server.org').user()).to.be.null

        it 'should return an empty password', ->
          expect(auth.host('my.server.org').password()).to.be.null

        it 'should return an empty auth object', ->
          expect(auth.host('my.server.org').auth()).to.be.null

    describe 'bad formed JSON', ->

      it 'should throw a sintax Error exception', ->
        expect(-> new Authrc('test/fixtures/bad_formed/json/.authrc')).to.be.throw(Error)

  describe 'empty .authrc file', ->

    it 'should not throw an exception', ->
      expect(-> new Authrc('test/fixtures/empty/.authrc') ).to.not.throw

    it 'should not exists', ->
      expect(new Authrc('test/fixtures/empty/.authrc').exists()).to.be.false

  describe 'error on password decryption', ->
    
    beforeEach ->
      auth = new Authrc('test/fixtures/bad_encrypted/.authrc')

    describe 'bad cipher for the encrypted password', ->

      it 'should be an encrypted password', ->
        expect(auth.host('bad.cipher.org').encrypted()).to.be.true

      it 'should throw a sintax Error exception', ->
        expect(-> auth.host('bad.cipher.org').descrypt(key) ).to.be.throw(Error)

    describe 'bad encrypted password value', ->

      it 'should throw a sintax Error exception', ->
        expect(-> auth.host('bad.encryption.org').descrypt(key) ).to.be.throw(Error)

      it 'should throw a sintax Error exception', ->
        expect(-> auth.host('bad.encryption.org/idea').descrypt(key) ).to.be.throw(Error)

    describe 'non supported cipher', ->

      it 'should throw a sintax Error exception', ->
        expect(-> auth.host('non.existant.org').descrypt(key) ).to.be.throw(Error)

      it 'should throw a sintax Error exception', ->
        expect(-> auth.host('non.existant.org/bad-encrypted').descrypt(key) ).to.be.throw(Error)

  describe 'bad authtentication types values', ->
    
    beforeEach ->
      auth = new Authrc('test/fixtures/bad_auth/')

    describe 'invalid username', ->

      it 'should not be a valid auth config', ->
        expect(auth.host('bad.username.org').exists()).to.be.true
        expect(auth.host('bad.username.org').valid()).to.be.false

    describe 'invalid both username and password values', ->

      it 'should not be a valid auth config', ->
        expect(auth.host('bad.auth.org').exists()).to.be.true
        expect(auth.host('bad.auth.org').valid()).to.be.false

  # more malefic test cases in process...
