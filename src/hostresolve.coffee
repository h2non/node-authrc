{ diffChars } = require './lib/diff'
{ isUri, formatUri, parseUri, isObject, trim } = require './common'

module.exports = (obj, string) ->
  return string if not isUri(string) or not isObject(obj)

  matches = null
  matchDiffs = diffAlgorithm(string)
  hostParsed = parseUri(string)

  getMatchedHost = ->
    matches?[0]?.value or null

  # Match string by letter according to the spec algorithm:
  # An O(ND) Difference Algorithm by Eugene W. Myers
  Object.keys(obj)
    .map (host) ->
      trim(host)
    .filter (host) ->
      parseUri(host).hostname is hostParsed.hostname
    .forEach matchDiffs

  # get matched values
  matches = matchDiffs() 
  
  # deep host matching for commons matchs
  if matches.length > 1
    submatches = matches
      .filter (host) ->
        match = false
        host = parseUri(host.value)

        # todo value match based on priority
        ['protocol', 'port']
          .forEach (filter) ->
            match = hostParsed[filter] is host[filter]
        match

    if submatches.length is 1
      # return the first element
      matches = submatches
    else if submatches.length > 1
      # match string differences by pathname
      if not hostParsed.pathname or hostParsed.pathname is '/'
        matches = submatches
      else
        do ->
          differences = null
          matchDiffs = diffAlgorithm(hostParsed.pathname)
          submatches.forEach (host) ->
            { pathname } = parseUri(host.value)
            if pathname isnt '/'
              matchDiffs(pathname, host.value)

          # todo: improve!
          pathmatches = matchDiffs()
          if pathmatches.length
            matches = pathmatches.map (value) ->
             { value: value.index } 
  
  getMatchedHost()


diffAlgorithm = (match) ->
  differences = null
  matches = []

  (value, index) ->
    return matches unless value

    diffLength = diffChars(match, value).length
    differences = diffLength unless differences

    if diffLength < differences
      matches = []
      matches.push({ value: value, index: index })
    else if diffLength is differences
      matches.push({ value: value, index: index })
      differences = diffLength

    matches
