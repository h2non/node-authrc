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
        .to.be.equal('8cfe62fb21fc8d9e99718154f8c827214ef362f28497146ec1f612d4fdb86c30')

    describe 'encryption with supported ciphers', ->

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
        expect(-> host.encrypt(key, 'rc4')).to.throw(Error)

      it 'should try to encrypt the password with 3DES', ->
        try
          expect(-> host.encrypt(key, '3des')).to.throw(Error)

      it 'should try to encrypt the password with AES512', ->
        try
          expect(-> host.encrypt(key, 'AES512')).to.throw(Error)

  ###
    it 'should return the auth for the given hostname and port', ->
      expect(auth.host('https://git.server.org:8443').getAuth()).to.deep.equal({ 
        username: 'philip'
        password: 'unbreakablepassword'
      })

    it 'should return the auth for the given IP', ->
      expect(auth.host('https://10.0.0.2:8443').getAuth()).to.deep.equal({ 
        username: 'michael'
        password: null
      })

    it 'should return the auth for the given hostname, port and path', ->
      host = auth.host('https://git.server.org:8443/resource')

      expect(host.exists()).to.be.true
      expect(host.getAuth()).to.deep.equal({ 
        username: 'tim'
        password: '1325248b0bc6a0bfc33ac99d468223f543a7b00fb386f617b0fb7183b0d70f4c'
      })

    describe 'Blowfish cipher encryption', ->
      passwordObj = host = null

      before ->
        host = auth.host('https://git.server.org:8443/resource')
        passwordObj = host.getPasswordObj()

      afterEach ->
        host.setPassword(passwordObj)

      it 'should encrypt the password with blowfish', ->
        host = auth.host('https://git.server.org:8443/resource')
        key = 'p@ssw0rd'

        expect(host.encrypt(key, 'blowfish')).to.be.equal(
          'ef552776ba426f57a92b9a10f04f2935fdc76956a52078011971f4f0813fef8bea31262d7d22efe64034615bc9ed14d230f79288080c1baf52c636140ef5030be927a5acbb7aa77a'
        )

    describe 'password value stored in a environment variable', ->
      password = 'unbreakablepassword'

      beforeEach ->
        process.env['MY_SERVER_USER_PASSWORD'] = password

      afterEach ->
        process.env['MY_SERVER_USER_PASSWORD'] = null

      it 'should return the password from env variable for the given host', ->
        expect(auth.host('https://10.0.0.2:8443').getAuth().password)
          .to.be.equal(password)

  describe 'authrc file autodiscover based on the current directory', ->
    auth = null
    cwd = process.cwd()

    beforeEach -> 
      process.chdir(__dirname + '/fixtures/')
      auth = new Authrc()

    afterEach ->
      process.chdir(cwd)

    it 'should return the auth for the given hostname', ->
      expect(auth.host('http://git.server.org').getAuth()).to.deep.equal({ 
        username: 'john'
        password: 'unbreakablepassword'
      })

  describe 'decrypt host password', ->
    auth = null
    host = null

    beforeEach -> 
      auth = new Authrc('test/fixtures/.authrc')

    beforeEach ->
      host = auth.host('https://git.server.org:8443/resource')
      
    it 'the host should eixsts', ->
      expect(host.exists()).to.be.true

    it 'the host password should be encrypcted', ->
      expect(host.isEncrypted()).to.be.true

    it 'should descrypt the password', ->
      key = 'p@ssw0rd'
      expect(host.decrypt(key)).to.be.equal('unbreakablepassword')
  
  ###
  # more test in progress...
