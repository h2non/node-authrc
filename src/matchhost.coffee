{ diffChars } = require './diff'
{ isUri, formatUri, parseUri } = require './common'

module.exports = (obj, string) ->
  return string if not isUri(string) or typeof obj isnt 'object'

  hostParsed = parseUri(string)
  differences = null
  match = null

  # Match string by letter according to the spec algorithm:
  # An O(ND) Difference Algorithm by Eugene W. Myers
  Object.keys(obj)
    .filter (host) ->
      parseUri(host).hostname is hostParsed.hostname
    .forEach (host) ->
      diffLength = diffChars(host, string).length
      differences = diffLength unless differences
      if diffLength <= differences
        match = host
        differences = diffLength

  return match