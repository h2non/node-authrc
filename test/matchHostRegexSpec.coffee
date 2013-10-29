{ expect } = require '../node_modules/chai/chai'
Authrc = require '../lib/authrc'

describe 'Match/find hosts', ->

  describe 'based on regular expressions', ->
    auth = null

    beforeEach -> 
      auth = new Authrc('test/fixtures/regex/')
 
    it 'should find the host matching with monica user', ->
      host = auth.host('service.site.org/downloads')

      expect(host.exists()).to.be.true
      expect(host.username()).to.be.equal('monica')

    it 'should find the host with chris user', ->
      host = auth.host('https://site.net/downloads')

      expect(host.exists()).to.be.true
      expect(host.username()).to.be.equal('chris')

    it 'should find the host with charles user', ->
      host = auth.host('http://10.68.1.9:8088')
      
      expect(host.exists()).to.be.true
      expect(host.username()).to.be.equal('charles')


