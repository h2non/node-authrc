{ expect } = require 'chai'
Authrc = require '../lib/authrc'

describe 'API interface implementation', ->
  auth = null

  before ->
    auth = new Authrc

  describe 'Authrc Object public API', ->

    describe 'public methods', ->

      it 'should satisfy the host() method', ->
        expect(auth).to.respondTo('host')

      it 'should satisfy the find() method', ->
        expect(auth).to.respondTo('find')

      it 'should satisfy the getData() method', ->
        expect(auth).to.respondTo('getData')

      it 'should satisfy the exists() method', ->
        expect(auth).to.respondTo('exists')

      it 'should satisfy the existsHost() method', ->
        expect(auth).to.respondTo('hostExists')

      it 'should satisfy the hosts() method', ->
        expect(auth).to.respondTo('hosts')

      it 'should satisfy the unwatch() method', ->
        expect(auth).to.respondTo('unwatch')

      it 'should satisfy the isGlobalFile() method', ->
        expect(auth).to.respondTo('isGlobalFile')

      describe 'inherited from Actions Object', ->

        it 'should satisfy the add() method', ->
          expect(auth).to.respondTo('add')

        it 'should satisfy the save() method', ->
          expect(auth).to.respondTo('save')

        it 'should satisfy the remove() method', ->
          expect(auth).to.respondTo('remove')

        it 'should satisfy the create() method', ->
          expect(auth).to.respondTo('create')

        it 'should satisfy the read() method', ->
          expect(auth).to.respondTo('read')

        it 'should satisfy the update() method', ->
          expect(auth).to.respondTo('update')

        it 'should satisfy the discover() static method', ->
          expect(Authrc).to.have.property('discover')

        it 'should satisfy the find() static method', ->
          expect(Authrc).to.have.property('find')

        it 'should satisfy the get() static method', ->
          expect(Authrc).to.have.property('get')

    describe 'public properties', ->

      it 'should satisfy the version static property', ->
        expect(Authrc).to.have.property('version')

      it 'should satisfy the data property', ->
        expect(auth).to.have.property('data')

      it 'should satisfy the file property', ->
        expect(auth).to.have.property('file')


  describe 'Host Object public API', ->
    host = null

    before ->
      host = auth.host()

    describe 'public methods', ->

      it 'should satisfy the get() method', ->
        expect(host).to.respondTo('get')

      it 'should satisfy the set() method', ->
        expect(host).to.respondTo('set')

      it 'should satisfy the isValid() method', ->
        expect(host).to.respondTo('isValid')

      it 'should satisfy the valid() method', ->
        expect(host).to.respondTo('valid')

      it 'should satisfy the username() method', ->
        expect(host).to.respondTo('username')

      it 'should satisfy the user() method', ->
        expect(host).to.respondTo('user')

      it 'should satisfy the password() method', ->
        expect(host).to.respondTo('password')

      it 'should satisfy the cipher() method', ->
        expect(host).to.respondTo('cipher')
      
      it 'should satisfy the auth() method', ->
        expect(host).to.respondTo('auth')

      it 'should satisfy the authUrl() method', ->
        expect(host).to.respondTo('authUrl')

      it 'should satisfy the canDecrypt() method', ->
        expect(host).to.respondTo('canDecrypt')

      it 'should satisfy the decrypt() method', ->
        expect(host).to.respondTo('decrypt')

      it 'should satisfy the encrypt() method', ->
        expect(host).to.respondTo('encrypt')

      it 'should satisfy the copy() method', ->
        expect(host).to.respondTo('copy')  

    describe 'public properties', ->

      it 'should satisfy the host property', ->
        expect(host).to.have.property('host')

      it 'should satisfy the search property', ->
        expect(host).to.have.property('search')
