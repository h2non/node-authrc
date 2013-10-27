{ expect } = require '../node_modules/chai/chai'
fs = require 'fs'
Authrc = require '../lib/authrc'

describe 'create/read/update/remove config', ->
  authRcPath = "#{__dirname}/fixtures/tmp/.authrc"
  auth = null

  writeJSON = (data) ->
    fs.writeFileSync authRcPath, JSON.stringify(data, null, 4)

  describe 'playing with hosts data', ->

    before ->
      writeJSON
        'my.host.org': 
          username: 'richard'
          password: 'p@s$w0rd'
        'my.second.host.org':
          username: 'george'
          password: 'p@s$w0rd'

    describe 'read', ->
      host = null

      before ->
        auth = new Authrc(authRcPath)

      it 'should find the file and has some data', ->
        expect(auth.exists()).to.be.true

      describe 'existant host', ->

        beforeEach ->
          host = auth.host('https://my.second.host.org')

        it 'should find the host from Authrc class', ->
          expect(auth.hostExists('https://my.second.host.org')).to.be.true

        it 'should find the host from Host class', ->
          expect(host.exists()).to.be.true

      describe 'existant host', ->

        beforeEach ->
          host = auth.host('https://nonexistant.org')

        it 'should not find the host from Authrc class', ->
          expect(auth.hostExists('https://nonexistant.org')).to.be.false

        it 'should not find the host from Host class', ->
          expect(host.exists()).to.be.false

    describe 'create', ->
      host = null

      before ->
        auth = new Authrc(authRcPath)

      beforeEach ->
        host = auth.host('https://nonexistant.org')

      it 'should find the file and has some data', ->
        expect(auth.exists()).to.be.true

      it 'should not find the host', ->
        expect(auth.hostExists('https://nonexistant.org')).to.be.false
        expect(host.exists()).to.be.false

      describe 'create new host', -> 

        it 'should create a new host with empty auth credentials', ->
          auth.add('https://nonexistant.org')
          expect(host.auth()).to.be.equal(null)

        describe 'with auth object', ->
          
          before ->
            auth.add('https://nonexistant.org', { username: 'superman', password: '$super-pa$sw0rd'})

          it 'should create a new host with credentials object', ->
            expect(host.auth()).to.not.be.equal(null)
            expect(host.auth()).to.deep.equal({ username: 'superman', password: '$super-pa$sw0rd'})

        describe 'with full object parameter', ->

          before ->
            auth.add({ 'https://nonexistant.org': { username: 'superman', password: '$super-pa$sw0rd'} })

          it 'should create a new host with credentials object', ->
            expect(host.auth()).to.not.be.equal(null)
            expect(host.auth()).to.deep.equal({ username: 'superman', password: '$super-pa$sw0rd'})

     describe 'remove', ->
      host = null

      beforeEach ->
        auth = new Authrc(authRcPath)

      beforeEach ->
        host = auth.host('https://my.host.org')

      it 'should find the host', ->
        expect(auth.hostExists('https://my.host.org')).to.be.true
        expect(host.exists()).to.be.true

      describe 'existant host', -> 

        it 'should remove properly from Authrc class', ->
          expect(auth.remove('my.host.org').hostExists('https://my.host.org')).to.be.false

        it 'should remove properly from Host class', ->
          expect(host.remove().exists()).to.be.false

    describe 'update', ->
      host = null

      beforeEach ->
        auth = new Authrc(authRcPath)

      beforeEach ->
        host = auth.host('https://my.host.org')

      it 'should find the file and has some data', ->
        expect(auth.exists()).to.be.true

      it 'should find the host', ->
        expect(host.exists()).to.be.true

      describe 'update username and password separetly', -> 

        it 'should update the username for the given host', ->
          expect(host.username('superman')).to.be.equal('superman')
          expect(host.auth()).to.deep.equal({
            username: 'superman'
            password: 'p@s$w0rd'
          })

        it 'should update the password for the given host', ->
          expect(host.password('my_n€w_svp3r_p@s$w0rd')).to.be.equal('my_n€w_svp3r_p@s$w0rd')
          expect(host.auth()).to.deep.equal({
            username: 'richard'
            password: 'my_n€w_svp3r_p@s$w0rd'
          })

      describe 'update both username and password', -> 

        it 'should update the auth for the given host using strings', ->
          expect(host.auth('superman', 'my_n€w_svp3r_p@s$w0rd')).to.deep.equal({
            username: 'superman'
            password: 'my_n€w_svp3r_p@s$w0rd'
          })

        it 'should update the auth for the given host using password object', ->
          expect(host.auth('superman', { value: 'my_n€w_svp3r_p@s$w0rd', cipher: 'plain' } )).to.deep.equal({
            username: 'superman'
            password: 'my_n€w_svp3r_p@s$w0rd'
          })

      describe 'update both username and password', ->

        it 'should update the auth for the given host using strings', ->
          expect(host.auth('superman', 'my_n€w_svp3r_p@s$w0rd')).to.deep.equal({
            username: 'superman'
            password: 'my_n€w_svp3r_p@s$w0rd'
          })

        it 'should update the auth for the given host using password object', ->
          expect(host.auth('superman', { value: 'my_n€w_svp3r_p@s$w0rd', cipher: 'plain' } )).to.deep.equal({
            username: 'superman'
            password: 'my_n€w_svp3r_p@s$w0rd'
          })
