{ expect } = require '../node_modules/chai/chai'
Authrc = require '../lib/authrc'

describe 'Password decryption', ->
  authrcPath = 'test/fixtures/encryption/.authrc'
  key = '@_$vp€R~k3y'
  auth = null
  host = null

  beforeEach -> 
    auth = new Authrc(authrcPath)

  describe 'password value and aes256 cipher', ->

    beforeEach -> 
      host = auth.host('https://git.server.org:8443')

    it 'should be an encrypted password', ->
      expect(host.isEncrypted()).to.be.true

    it 'should not can decrypt', ->
      expect(host.canDecrypt()).to.be.false

    it 'should decrypt with the defined cipher', ->
      expect(host.decrypt(key))
        .to.be.equal('unbreakablepassword')

  describe 'transparent decryption with environment variable key', ->

    before ->
      process.env['MY_PASS_DECRYPTION_KEY'] = key

    beforeEach -> 
      host = auth.host('https://secure.server.net')

    after ->
      process.env['MY_PASS_DECRYPTION_KEY'] = ''

    it 'should be an encrypted password', ->
      expect(host.isEncrypted()).to.be.true

    it 'should can decrypt', ->
      expect(host.canDecrypt()).to.be.true

    it 'should decrypt with with transparent key', ->
      expect(host.decrypt())
        .to.be.equal('unbreakablepassword')

  describe 'transparent decryption with both environment variable value and key', ->

    before ->
      process.env['MY_SERVER_USER_PASSWORD'] = '41b717a64c6b5753ed5928fd8a53149a7632e4ed1d207c91'
      process.env['MY_PASS_DECRYPTION_KEY'] = key

    beforeEach -> 
      host = auth.host('http://my.server.org')

    after ->
      process.env['MY_SERVER_USER_PASSWORD'] = ''
      process.env['MY_PASS_DECRYPTION_KEY'] = ''

    it 'should be an encrypted password', ->
      expect(host.isEncrypted()).to.be.true

    it 'should can decrypt', ->
      expect(host.canDecrypt()).to.be.true

    it 'should decrypt the defined cipher', ->
      expect(host.decrypt(key))
        .to.be.equal('unbreakablepassword')

  describe 'password with environment variable value', ->

    before ->
      process.env['MY_SERVER_USER_PASSWORD'] = 'f3d3d049ec7f9a0e8de66891fbc63881b765ea965c5fc37c'

    beforeEach -> 
      host = auth.host('https://10.0.0.2')

    after ->
      process.env['MY_SERVER_USER_PASSWORD'] = ''

    it 'should be an encrypted password', ->
      expect(host.isEncrypted()).to.be.true

    it 'should can decrypt', ->
      expect(host.canDecrypt()).to.be.false

    it 'should decrypt the defined cipher', ->
      expect(host.decrypt(key))
        .to.be.equal('unbreakablepassword')

  describe 'unsupported cipher', ->

    before ->
      process.env['MY_DECRYPT_PASSWORD_KEY'] = key

    beforeEach -> 
      host = auth.host('https://172.16.5.1')

    after ->
      process.env['MY_DECRYPT_PASSWORD_KEY'] = ''

    it 'should be an encrypted password', ->
      expect(host.isEncrypted()).to.be.false

    it 'should can decrypt', ->
      expect(host.canDecrypt()).to.be.false

    it 'should throw an TypeError exception', ->
      expect(-> host.decrypt(key)).to.be.throw(TypeError)
