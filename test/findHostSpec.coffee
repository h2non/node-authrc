{ expect } = require '../node_modules/chai/chai'
Authrc = require '../lib/authrc'

describe 'Find host and test auth basic credentials', ->

  describe 'authrc with file path', ->
    auth = null

    beforeEach -> 
      auth = new Authrc('test/fixtures/basic/.authrc')

    it 'should return the auth for the given hostname', ->
      host = auth.host('http://git.server.org')

      expect(host.exists()).to.be.true
      expect(host.auth()).to.deep.equal({ 
        username: 'john'
        password: 'unbreakablepassword'
      })

    it 'should return the same auth for the given hostname with https protocol', ->
      host = auth.host('https://git.server.org')

      expect(host.exists()).to.be.true
      expect(host.auth()).to.deep.equal({ 
        username: 'john'
        password: 'unbreakablepassword'
      })

    it 'should return the auth for the given hostname wit four level domain', ->
      host = auth.host('https://my.git.server.org')

      expect(host.exists()).to.be.true
      expect(host.auth()).to.deep.equal({ 
        username: 'george'
        password: 'unbreakablepassword'
      })

    it 'should return the auth for the given hostname and port', ->
      host = auth.host('git.server.org:8443')

      expect(host.exists()).to.be.true
      expect(host.auth()).to.deep.equal({ 
        username: 'philip'
        password: 'unbreakablepassword'
      })

    it 'should return the auth for the given hostname, port and path', ->
      host = auth.host('https://git.server.org:8443/resource')

      expect(host.exists()).to.be.true
      expect(host.auth()).to.deep.equal({ 
        username: 'philip'
        password: 'unbreakablepassword'
      })

    it 'should return the auth for the given hostname and path', ->
      host = auth.host('https://git.server.org/resource')

      expect(host.exists()).to.be.true
      expect(host.auth()).to.deep.equal({ 
        username: 'tim'
        password: 'unbreakablepassword'
      })

    it 'should return the auth for the given hostname', ->
      host = auth.host('notld/resource')
      
      expect(host.exists()).to.be.true
      expect(host.auth()).to.deep.equal({ 
        username: 'dennis'
        password: '$up€r_$3crEt_%?'
      })

    it 'should return the auth for the given IP, protocol and port', ->
      host = auth.host('https://10.0.0.2:8443')

      expect(host.exists()).to.be.true
      expect(host.auth()).to.deep.equal({ 
        username: 'michael'
        password: null
      })

    it 'should return the auth for the given IP and protocol', ->
      host = auth.host('http://10.0.0.2')

      expect(host.exists()).to.be.true
      expect(host.auth()).to.deep.equal({ 
        username: 'michael'
        password: null
      })

    it 'should return the auth for the given IP', ->
      host = auth.host('10.0.0.2')

      expect(host.exists()).to.be.true
      expect(host.auth()).to.deep.equal({ 
        username: 'michael'
        password: null
      })

    it 'should return the auth for the given IP and non-HTTP protocol', ->
      host = auth.host('ftp://10.0.0.2')

      expect(host.exists()).to.be.true
      expect(host.auth()).to.deep.equal({ 
        username: 'douglas'
        password: null
      })

    describe 'get the URL with fill authenticacion values', ->

      it 'should return the auth URL for the given hostnames', ->
        expect(auth.host('https://git.server.org').authUrl())
          .to.be.equal('https://john:unbreakablepassword@git.server.org/')

        expect(auth.host('https://my.git.server.org').authUrl())
          .to.be.equal('https://george:unbreakablepassword@my.git.server.org/')

      it 'shoudl return the auth URL with the password properly encoded', ->
        expect(auth.host('notld/resource').authUrl())
          .to.be.equal('http://dennis:%24up%E2%82%ACr_%243crEt_%25%3F@notld/resource')

