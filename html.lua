local pair
pair = function()
  local void
  do
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
  end
  local environment, buffer = { }, {
    insert = table.insert,
    concat = table.concat,
    escape = function(self, value)
      local escaped = tostring(value):gsub("[<>&]", {
        ['&'] = '&amp;',
        ['<'] = '&lt;',
        ['>'] = '&gt;',
        ['"'] = '&quot;',
        ["'"] = '&#039;'
      })
      return self:insert(escaped)
    end
  }
  local attrib
  attrib = function(args)
    local res = setmetatable({ }, {
      __tostring = function(self)
        return table.concat((function()
          local _accum_0 = { }
          local _len_0 = 1
          for key, value in pairs(self) do
            _accum_0[_len_0] = tostring(key) .. "=\"" .. tostring(value) .. "\""
            _len_0 = _len_0 + 1
          end
          return _accum_0
        end)(), ' ')
      end
    })
    for _index_0 = 1, #args do
      local arg = args[_index_0]
      if type(arg) == 'table' then
        for key, value in pairs(arg) do
          if type(key) == 'string' then
            res[key] = value
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
        buffer:insert(tostring(arg))
      end
    end
  end
  environment.raw = function(text)
    return buffer:insert(text)
  end
  environment.text = function(text)
    return buffer:escape(text)
  end
  setmetatable(environment, {
    __index = function(self, key)
      return _ENV[key] or function(...)
        buffer:insert("<" .. tostring(key) .. " " .. tostring(attrib({
          ...
        })) .. ">")
        handle({
          ...
        })
        if not (void[key]) then
          return buffer:insert("</" .. tostring(key) .. ">")
        end
      end
    end
  })
  return environment, buffer
end
local render
render = function(fnc)
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
  return buf:concat('\n')
end
return {
  render = render,
  pair = pair
}
