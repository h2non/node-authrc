{ readJSON, writeJSON, extend, cloneDeep, isObject, isString } = require './common'

module.exports = class Actions

  add: (host, authObj) =>
    @data ?= {}

    if isObject(host)
      hostObj = host
    else if isString(host) and isObject(authObj)
      hostObj = {}
      hostObj[host] = extend({ username: null, password: null }, authObj)

    extend(@data, hostObj)
    @

  create: (data, callback) =>
    @data = data
    @add(data)
    @save(callback)
    @

  remove: (host) =>
    host ?= @host
    host = host.host if isObject(host) and (/function Host\(/).test(host.constructor.toString())
    @data[host] = null if @data.hasOwnProperty(host)
    @

  save: (callback, data = @data) =>
    writeJSON(@file, data, callback)
    @

  read: =>
    @data = readJSON(@file)
    @

  update: Actions::read