{ expect, should } = require '../node_modules/chai/chai'
Authrc = require '../lib/authrc'

describe 'Authrc: ', ->

  describe 'authrc file path', ->
    auth = null

    beforeEach -> 
      auth = new Authrc('test/fixtures/.authrc')

    it 'should return the auth credentials for the hostname', ->
      expect(auth.getAuth('http://git.server.org')).to.deep.equal({ 
        username: 'john'
        password: 'unbreakablepassword'
      });

    it 'should return the auth credentials for the hostname and port', ->
      expect(auth.getAuth('https://git.server.org:8443')).to.deep.equal({ 
        username: 'philip'
        password: 'unbreakablepassword'
      });

    it 'should return the auth credentials for the given IP', ->
      expect(auth.getAuth('https://10.0.0.2:8443')).to.deep.equal({ 
        username: 'philip'
        password: 'unbreakablepassword'
      });