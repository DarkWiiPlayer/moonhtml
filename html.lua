local void
do
  local _tbl_0 = { }
  local _list_0 = {
    "area",
    "base",
    "br",
    "col",
    "command",
    "embed",
    "hr",
    "img",
    "input",
    "keygen",
    "link",
    "meta",
    "param",
    "source",
    "track",
    "wbr"
  }
  for _index_0 = 1, #_list_0 do
    local key = _list_0[_index_0]
    _tbl_0[key] = true
  end
  void = _tbl_0
end
local escapes = {
  ['&'] = '&amp;',
  ['<'] = '&lt;',
  ['>'] = '&gt;',
  ['"'] = '&quot;',
  ["'"] = '&#039;'
}
local pair
pair = function(buffer)
  if buffer == nil then
    buffer = { }
  end
  if type(buffer) ~= 'table' then
    error(2, "Argument must be a table or nil")
  end
  local environment = { }
  local escape
  escape = function(value)
    return tostring(value):gsub([[[<>&]'"]], escapes)
  end
  local attrib
  attrib = function(args)
    local res = setmetatable({ }, {
      __tostring = function(self)
        local tab
        do
          local _accum_0 = { }
          local _len_0 = 1
          for key, value in pairs(self) do
            if type(value) == 'string' then
              _accum_0[_len_0] = tostring(key) .. "=\"" .. tostring(value) .. "\""
              _len_0 = _len_0 + 1
            end
          end
          tab = _accum_0
        end
        return #tab > 0 and ' ' .. table.concat(tab, ' ') or ''
      end
    })
    for _index_0 = 1, #args do
      local arg = args[_index_0]
      if type(arg) == 'table' then
        for key, value in pairs(arg) do
          if type(key) == 'string' then
            res[key] = value
            local r = true
          end
        end
      end
    end
    return res
  end
  local handle
  handle = function(args)
    for _index_0 = 1, #args do
      local arg = args[_index_0]
      local _exp_0 = type(arg)
      if 'table' == _exp_0 then
        handle(arg)
      elseif 'function' == _exp_0 then
        arg()
      else
        table.insert(buffer, tostring(arg))
      end
    end
  end
  environment.raw = function(text)
    return table.insert(buffer, text)
  end
  environment.text = function(text)
    return table.insert(buffer, escape(text))
  end
  setmetatable(environment, {
    __index = function(self, key)
      return _ENV[key] or function(...)
        table.insert(buffer, "<" .. tostring(key) .. tostring(attrib({
          ...
        })) .. ">")
        handle({
          ...
        })
        if not (void[key]) then
          return table.insert(buffer, "</" .. tostring(key) .. ">")
        end
      end
    end
  })
  return environment, buffer
end
local build
build = function(fnc)
  local env, buf = pair()
  local hlp
  do
    local _ENV = env
    hlp = function()
      return aaaaa
    end
  end
  assert(type(fnc) == 'function', 'wrong argument to render, expecting function')
  debug.upvaluejoin(fnc, 1, hlp, 1)
  fnc()
  return buf
end
local render
render = function(fnc)
  return table.concat(build(fnc), '\n')
end
return {
  render = render,
  build = build,
  pair = pair
}
