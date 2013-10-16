{ expect, should } = require '../node_modules/chai/chai'
Authrc = require '../lib/authrc'

describe 'Authrc', ->

  describe 'authrc file path', ->
    auth = null

    beforeEach -> 
      auth = new Authrc('test/fixtures/.authrc')

    it 'should return the auth for the given hostname', ->
      expect(auth.getAuth('http://git.server.org')).to.deep.equal({ 
        username: 'john'
        password: 'unbreakablepassword'
      })

    it 'should return the auth for the given hostname and port', ->
      expect(auth.getAuth('https://git.server.org:8443')).to.deep.equal({ 
        username: 'philip'
        password: 'unbreakablepassword'
      })

    it 'should return the auth for the given hostname, port and path', ->
      expect(auth.getAuth('https://git.server.org:8443/resource')).to.deep.equal({ 
        username: 'tim'
        password: 'unbreakablepassword'
      })

    it 'should return the auth for the given IP', ->
      expect(auth.getAuth('https://10.0.0.2:8443')).to.deep.equal({ 
        username: 'michael'
        password: 'unbreakablepassword'
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
      expect(auth.getAuth('http://git.server.org')).to.deep.equal({ 
        username: 'john'
        password: 'unbreakablepassword'
      })

  # more test in progress...
