{ expect } = require '../node_modules/chai/chai'
Authrc = require '../lib/authrc'

describe 'Destructive testing', ->

  describe 'bad formed .authrc file', ->
    it 'should throw a sintax Error exception', ->
      expect(-> new Authrc('test/fixtures/bad_formed/.authrc')).to.be.throw(Error)