{ isString } = require '../common'

module.exports = class

  @notEmpty: (value) ->
    throw new Error 'Value cannot be empty'.red unless value.length
    value

  @notEqual: (value, compare) ->
    value isnt compare

  @password: (value) =>
    @notEmpty(value)
    if value.length < 6
      throw new Error 'Password must have at least 6 characters'.red
    if /^\w+$/.test(value)
      throw new Error 'Password must contain at least one symbol character'.red
    value
