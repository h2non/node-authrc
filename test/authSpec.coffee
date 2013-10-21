{ expect, should } = require '../node_modules/chai/chai'
Authrc = require '../lib/authrc'

describe 'Authrc', ->

  describe 'authrc file path', ->
    auth = null

    beforeEach -> 
      auth = new Authrc('test/fixtures/.authrc')

    it 'should return the auth for the given hostname', ->
      expect(auth.host('http://git.server.org').getAuth()).to.deep.equal({ 
        username: 'john'
        password: 'unbreakablepassword'
      })

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

  # more test in progress...
