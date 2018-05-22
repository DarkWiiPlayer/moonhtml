void = {key,true for key in *{
  "area", "base", "br", "col"
  "command", "embed", "hr", "img"
  "input", "keygen", "link", "meta"
  "param", "source", "track", "wbr"
}}

escapes = {
  ['&']: '&amp;'
  ['<']: '&lt;'
  ['>']: '&gt;'
  ['"']: '&quot;'
  ["'"]: '&#039;'
}

pair= (buffer = {}) ->
  if type(buffer) != 'table'
    error 2, "Argument must be a table or nil"

  environment = {}
  escape = (value) ->
    tostring(value)\gsub [[[<>&]'"]], escapes

  attrib = (args) ->
    res = setmetatable {}, __tostring: =>
      tab = ["#{key}=\"#{value}\"" for key, value in pairs(@) when type(value)=='string']
      #tab > 0 and ' '..table.concat(tab,' ') or ''
    for arg in *args
      if type(arg) == 'table'
        for key, value in pairs(arg)
          if type(key)=='string'
            res[key] = value
            r = true
    return res

  handle = (args) ->
    for arg in *args
      switch type(arg)
        when 'table'
          handle arg
        when 'function'
          arg!
        else
          table.insert buffer, tostring arg

  environment.raw = (text) ->
    table.insert buffer, text

  environment.text = (text) ->
    table.insert buffer, escape text

  setmetatable environment, {
    __index: (key) =>
      _ENV[key] or (...) ->
        table.insert buffer, "<#{key}#{attrib{...}}>"
        handle{...}
        table.insert buffer, "</#{key}>" unless void[key]
  }
  return environment, buffer

build = (fnc) ->
  env, buf = pair!
  hlp = do -- gotta love this syntax ♥
    _ENV = env
    -> aaaaa -- needs to access a global to get the environment upvalue
  assert(type(fnc)=='function', 'wrong argument to render, expecting function')
  debug.upvaluejoin(fnc, 1, hlp, 1) -- Set environment
  fnc!
  buf

render = (fnc) ->
  return table.concat build(fnc), '\n'

{:render, :build, :pair}
