fs = require 'fs'
{ expect } = require '../node_modules/chai/chai'
Authrc = require '../lib/authrc'

describe 'save/update data in file', ->
  auth = null
  authrcPath = "#{__dirname}/fixtures/tmp/.authrc"

  writeJSON = (data) ->
    fs.writeFileSync authrcPath, JSON.stringify(data, null, 4)

  before ->
    writeJSON
      'my.host.org': 
        username: 'richard'
        password: 'p@s$w0rd'
      'my.second.host.org':
        username: 'george'
        password: 'p@s$w0rd'

  before ->
    auth = new Authrc(authrcPath)

  after ->
    auth.unwatch()

  it 'should find the file and has data', ->
    expect(auth.exists()).to.be.true

  describe 'update and save data', ->
    host = null

    before ->
      host = auth.host('http://my.host.org')

    it 'should get the username', ->
      expect(host.username()).to.be.equal('richard')

    it 'should update the username', ->
      expect(host.username('michael')).to.be.equal('michael')

    it 'should get the password', ->
      expect(host.password()).to.be.equal('p@s$w0rd')

    it 'should update the password', ->
      expect(host.password('my-n€w-pas$d0rd')).to.be.equal('my-n€w-pas$d0rd')

    describe 'save changes in disk', ->
      
      it 'should write the file with new data', (done) ->
        auth.save (err) ->
          expect(err).to.be.null
          auth.read() # force read data from file
          done()

      it 'should have the new username and password values', ->
        expect(host.exists()).to.be.true
        expect(host.password()).to.be.equal('my-n€w-pas$d0rd')

