crypto = require 'crypto'
fs = require 'fs'

hashSums = {}
fileWatchers = {}

getSha1 = (string) ->
  crypto.createHash('sha1').update(string).digest('hex')

getSha1FromFile = (path) ->
  if fs.existsSync(path)
    getSha1(fs.readFileSync(path))
  else
    # if file is moved/deleted then do nothing
    hashSums[path]

module.exports = 

  unwatch: ->
    for watcher of fileWatchers when fileWatchers.hasOwnProperty(watcher) and fileWatchers[watcher].close
      fileWatchers[watcher].close()
    fileWatchers = {}

  watch: (path, callback) ->
    hasDifferentHash = ->
      h = getSha1FromFile(path)
      if h isnt hashSums[path]
        hashSums[path] = h
        true
      else
        false

    init = ->
      unless fs.existsSync(path)
        false # file not found
      else
        hashSums[path] or (hashSums[path] = getSha1FromFile(path))
        
        # Try to prevent many events to fire at the same time.
        # When someone is making many almost simultaneous file saves
        # then SHA1 is sometimes not calculated properly. It happens
        # probably because halfly saved file is being read. In that
        # case the only thing we could try to do is to create file lock
        # in NodeJS that is included by Operating System while saving file.
        # Later I will try to experiment with fs-ext flock
        # (https://github.com/baudehlo/node-fs-ext).
        execute = true
        fileWatchers[path] = fs.watch path, (event) ->
          if execute is true and event is 'change' and hasDifferentHash()
            execute = false
            #fileWatchers[path].close() # disabled due to uv__io_poll (v/src/unix/kqueue.c) error
            callback path
            init()

    if typeof callback is 'function'
      throw new Error('Cannot initialize, file not found') if not init()
      close: fileWatchers[path].close