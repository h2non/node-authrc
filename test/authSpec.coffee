{ expect, should } = require '../node_modules/chai/chai'
Authrc = require '../lib/authrc'

describe 'Authrc', ->

  describe 'authrc file path', ->
    auth = null

    beforeEach -> 
      auth = new Authrc('test/fixtures/.authrc')

    it 'should return the auth for the given hostname', ->
      expect(auth.get('http://git.server.org').getAuth()).to.deep.equal({ 
        username: 'john'
        password: 'unbreakablepassword'
      })

    it 'should return the auth for the given hostname and port', ->
      expect(auth.get('https://git.server.org:8443').getAuth()).to.deep.equal({ 
        username: 'philip'
        password: 'unbreakablepassword'
      })

    it 'should return the auth for the given IP', ->
      expect(auth.get('https://10.0.0.2:8443').getAuth()).to.deep.equal({ 
        username: 'michael'
        password: 'unbreakablepassword'
      })

    it 'should return the auth for the given hostname, port and path', ->
      host = auth.get('https://git.server.org:8443/resource')

      expect(host.exists()).to.be.true
      expect(host.getAuth()).to.deep.equal({ 
        username: 'tim'
        password: '1325248b0bc6a0bfc33ac99d468223f543a7b00fb386f617b0fb7183b0d70f4c',
        cipher: 'aes256'
      })

  describe 'authrc file autodiscover based on the current directory', ->
    auth = null
    cwd = process.cwd()

    beforeEach -> 
      process.chdir(__dirname + '/fixtures/')
      auth = new Authrc()

    afterEach ->
      process.chdir(cwd)

    it 'should return the auth for the given hostname', ->
      expect(auth.get('http://git.server.org').getAuth()).to.deep.equal({ 
        username: 'john'
        password: 'unbreakablepassword'
      })

  describe 'host with encryped password support', ->
    auth = null

    beforeEach -> 
      auth = new Authrc('test/fixtures/.authrc')

    it 'should return decrypt the password properly', ->
      host = auth.get('https://git.server.org:8443/resource')

      expect(host.exists()).to.be.true
      expect(host.isEncrypted()).to.be.true
      expect(host.decrypt('p@ssw0rd')).to.be.equal('unbreakablepassword')

  # more test in progress...
