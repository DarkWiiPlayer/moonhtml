MoonHTML
=========

I like how HTML is generated in [lapis](http://leafo.net/lapis/) so I decided to write my own version of that, for one because I want to use it outside lapis but also just because it seemed like a fun thing to do.

The code should pretty much explain itself, but here's how it works:

	print require'moonhtml'.render ->
		h1 'HELLO WORLD ♥'
		p 'How are you today?'

should generate the following code

	<h1 >
	HELLO WORLD ♥
	</h1>
	<p >
	How are you today?
	</p>

Note that I intend to use this mainly inside [Vim](https://vim.sourceforge.io/), whre I have a macro set up to feed the visual selection through the moonscript interpreter and replace it with its output.
I literally just copied the above code example, selected it, pressed Ctrl+Enter and it turned into the HTML code you see.

License: [The Unlicense](license.md)
