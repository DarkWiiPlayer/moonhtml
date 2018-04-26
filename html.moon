pair = ->
  environment, buffer = {}, {
    insert: table.insert
    concat: table.concat
    escape: (value) =>
      escaped = tostring(value)\gsub "[<>&]", {
        ['&']: '&amp;'
        ['<']: '&lt;'
        ['>']: '&gt;'
        ['"']: '&quot;'
        ["'"]: '&#039;'
      }
      @insert escaped
  }
  attrib = (args) ->
    res = setmetatable {}, __tostring: =>
      table.concat ["#{key}=\"#{value}\"" for key, value in pairs(@)], ' '
    for arg in *args
      if type(arg) == 'table'
        for key, value in pairs(arg)
          if type(key)=='string'
            res[key] = value
    return res

  handle = (args) ->
    for arg in *args
      switch type(arg)
        when 'table'
          handle arg
        when 'function'
          arg!
        else
          buffer\insert tostring arg
  environment.raw = (text) ->
    buffer\insert text
  environment.text = (text) ->
    buffer\escape text

  setmetatable environment, {
    __index: (key) =>
      _ENV[key] or (...) ->
        buffer\insert "<#{key} #{attrib{...}}>"
        handle{...}
        buffer\insert "</#{key}>"
  }
  environment, buffer

render = (fnc) ->
  local hlp -- Helper function
  env, buf = pair!
  do
    _ENV = env
    hlp = -> aaaaa -- needs to access a global to get the environment upvalue
  assert(type(fnc)=='function', 'wrong argument to render, expecting function')
  debug.upvaluejoin(fnc, 1, hlp, 1) -- Set environment
  fnc!
  buf\concat '\n'

{:render, :pair}
