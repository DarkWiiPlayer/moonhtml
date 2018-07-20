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

env = ->
	environment = setmetatable {}, {
		__index: (key) =>
			(_ENV or _G)[key] or (...) ->
				@.tag(key, ...)
	}
	_G   = environment -- Lua 5.1
	_ENV = environment -- Lua 5.2 +
	escape = (value) ->
		(=>@) tostring(value)\gsub [[[<>&]'"]], escapes

	split = (tab) ->
		ary = {}
		for k,v in ipairs(tab) do
			ary[k]=v
			tab[k]=nil
		return ary, tab

	flatten = (tab, flat={}) ->
		for key, value in pairs tab
			if type(key)=="number"
				if type(value)=="table"
					flatten(value, flat)
				else
					flat[#flat+1]=value
			else
				if type(value)=="table"
					flat[key] = table.concat value ' '
				else
					flat[key] = value
		flat
	
	export html5 = ->
		print '<!doctype html>'

	attrib = (args) ->
		res = setmetatable {}, __tostring: =>
			tab = ["#{key}=\"#{value}\"" for key, value in pairs(@) when type(value)=='string' or type(value)=='number']
			#tab > 0 and ' '..table.concat(tab,' ') or ''
		for key, value in pairs(args)
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
					print tostring arg

	environment.raw = (text) ->
		print text

	environment.text = (text) ->
		environment.raw escape text

	environment.tag = (tagname, ...) ->
		inner, args = split flatten {...}
		unless void[tagname] and #inner==0
			print "<#{tagname}#{attrib args}>"
			handle inner unless #inner==0
			print "</#{tagname}>" unless (#inner==0)
		else
			print "<#{tagname}#{attrib args}>"

	return environment

build = if _VERSION == 'Lua 5.1' then
	(fnc) ->
		assert(type(fnc)=='function', 'wrong argument to render, expecting function')
		environment = env!
		setfenv(fnc, environment)
		return (out=print, ...) ->
			environment.print = out
			return fnc(...)
else
	(fnc) ->
		assert(type(fnc)=='function', 'wrong argument to render, expecting function')
		environment = env!
		do
			upvaluejoin = debug.upvaluejoin
			_ENV = environment
			upvaluejoin(fnc, 1, (-> aaaa!), 1) -- Set environment
		return (out=print, ...) ->
			environment.print = out
			return fnc(...)

render = (out, fnc) ->
	build(fnc)(out)

{:render, :build, :env}
