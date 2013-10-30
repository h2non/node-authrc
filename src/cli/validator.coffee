{ isString, isRegex, validRegex } = require './common'

module.exports = class

  @regex = (value) ->
    return value unless isRegex value
    throw new Error 'Value is not a valid regular expression'.red unless validRegex value
    value

  @notEmpty: (value) ->
    throw new Error 'Value cannot be empty'.red unless value.length
    value

  @notEqual: (value, compare) ->
    value isnt compare

  @password: (value) =>
    @notEmpty(value)
    if value.length < 6
      throw new Error 'Password must have at least 6 characters'.red
    if /^\w+$/.test value
      throw new Error 'Password must contain at least one symbol character'.red
    value
