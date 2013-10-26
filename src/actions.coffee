{ readJSON, writeJSON, extend, cloneDeep, isObject, isString } = require './common'

module.exports = class Actions

  add: (host, authObj) =>
    if isObject(host)
      hostObj = host
    else if isString(host) and isObject(authObj)
      hostObj = {}
      hostObj[host] = extend({ username: null, password: null }, authObj)

    extend(@data, hostObj)
    @

  create: Actions::add

  remove: (host) =>
    host ?= @host
    @data[host] = null if @data.hasOwnProperty(host)
    @

  save: (callback, data = @data) =>
    writeJSON(@file, data, callback)
    @

  read: =>
    @data = readJSON(@file)
    @

  update: Actions::read