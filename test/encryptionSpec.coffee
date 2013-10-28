{ expect } = require '../node_modules/chai/chai'
Authrc = require '../lib/authrc'

describe 'Password encryption', ->
  authrcPath = 'test/fixtures/encryption/.authrc'
  key = '@_$vp€R~k3y'
  auth = null
  host = null

  describe 'existant host with plain password', ->

    beforeEach -> 
      auth = new Authrc(authrcPath)

    beforeEach -> 
      host = auth.host('http://git.server.org')

    it 'should not do an automatic password decryption', ->
      expect(host.canDecrypt()).to.be.false

    it 'should not be an encrypted password', ->
      expect(host.isEncrypted()).to.be.false

    it 'should encrypt the password with default cipher', ->
      expect(host.encrypt(key).password())
        .to.be.equal('ea08d490b880b4bfdb1b95f0e5c908424432ba57413d23b19db2d77a763d3178')

    describe 'with supported ciphers', ->

      it 'should encrypt the password with AES256', ->
        expect(host.encrypt(key, 'aes256').password())
          .to.be.equal('6400ff3f33bec8481dc7ead8bb5294fe0ea4b690a9b6fecd1d029ec54b062ccf')

      it 'should encrypt the password with Blowfish', ->
        expect(host.encrypt(key, 'blowfish').password())
          .to.be.equal('41b717a64c6b5753ed5928fd8a53149a7632e4ed1d207c91')

      it 'should encrypt the password with Camellia', ->
        expect(host.encrypt(key, 'camellia128').password())
          .to.be.equal('857c5903cabc19444e7d4393a512b94b89daf9bec48c062d614dc576e6bc8ef6')

      it 'should encrypt the password with CAST', ->
        expect(host.encrypt(key, 'cast').password())
          .to.be.equal('04ad8d25c0f92070d34c1763be723d380a99f7e20666d7d0')

      it 'should encrypt the password with IDEA', ->
        expect(host.encrypt(key, 'idea').password())
          .to.be.equal('f3d3d049ec7f9a0e8de66891fbc63881b765ea965c5fc37c')

      it 'should encrypt the password with SEED', ->
        expect(host.encrypt(key, 'SEED').password())
          .to.be.equal('cfef06c5a7640beca47f36893c2b7667b43c370ba4f7e0cfd971b42b166cd8b4')   

    describe 'faile suite with non-supported ciphers', ->

      it 'should try to encrypt the password with RC4', ->
        expect(-> host.encrypt(key, 'rc4')).to.throw(TypeError)

      it 'should try to encrypt the password with 3DES', ->
        expect(-> host.encrypt(key, '3des')).to.throw(TypeError)

      it 'should try to encrypt the password with AES192', ->
        expect(-> host.encrypt(key, 'AES512')).to.throw(TypeError)
