{ diffChars } = require './lib/diff'
{ isUri, isString, formatUri, parseUri, isObject, trim, validRegex, isRegex } = require './common'

module.exports = (obj, string) ->
  return string unless isString or isObject obj

  matches = null
  matchDiffs = diffAlgorithm string
  hostParsed = parseUri string

  getMatchedHost = ->
    matches?[0]?.value or null

  matchByPortAndProtocol = (host) ->
    match = false
    host = parseUri(host.value)

    # todo: match based on priority
    ['protocol', 'port']
      .forEach (filter) ->
        match = hostParsed[filter] is host[filter]
    match

  filterHosts = (host) ->
    if isRegex host
      if validRegex host
        testRegex host, string
    else
      parseUri(host).hostname is hostParsed.hostname

  comparePathStrings = (matches) ->
    differences = null
    matchDiffs = diffAlgorithm hostParsed.pathname

    matches.forEach (host) ->
      { pathname } = parseUri host.value
      if pathname isnt '/'
        matchDiffs pathname, host.value

    # todo: improve!
    matches = matchDiffs().map (value) ->
     { value: value.index }

    matches

  # get the hosts
  Object.keys(obj)
    .map(trim)
    # filter by hostname or match by regex
    .filter(filterHosts)
    # Match string by letter according to the spec algorithm:
    # An O(ND) Difference Algorithm by Eugene W. Myers
    .forEach(matchDiffs)

  # get filtered matched values
  matches = matchDiffs()
  
  # performs deep host matching
  if matches.length > 1
    # filter by protocol and port number
    matches = matches.filter matchByPortAndProtocol
    if matches.length > 1 and hostParsed.pathname and hostParsed.pathname isnt '/'
      # match string differences using the pathname
      matches = comparePathStrings submatches

  getMatchedHost()


testRegex = (pattern, string) ->
  new RegExp(pattern.replace(/^\/|\/$/g, ''), 'i').test string

diffAlgorithm = (match) ->
  differences = null
  matches = []

  (value, index) ->
    return matches unless value

    diffLength = diffChars(match, value).length
    differences = diffLength unless differences

    if diffLength < differences
      matches = []
      matches.push { value: value, index: index }
    else if diffLength is differences
      matches.push { value: value, index: index }
      differences = diffLength

    matches
