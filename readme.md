MoonHTML
=========

I like how HTML is generated in [lapis](http://leafo.net/lapis/) so I decided to write my own version of that, for one because I want to use it outside lapis but also just because it seemed like a fun thing to do.

The code should pretty much explain itself, but here's how it works:

	require'moonhtml'.render print, ->
		h1 'HELLO WORLD ♥'
		p {class: 'my_class'}, ->
			text 'How are you today?'
			br!
			raw 'you can still write <b>unescaped</b> HTML'

should generate the following code

	<h1>
	HELLO WORLD ♥
	</h1>
	<p class="my_class">
	How are you today?
	<br>
	you can still write <b>unescaped</b> HTML
	</p>

Warning
-----

Because of how lua works, once a function is passed into `render` or `build`, its upvalues are permanently changed. This means functions may become otherwise unusable, and shouldn't be used for more than one template at the same time. Seriously, things might explode and kittens may die.

Sort-Of Reference
-----

There isn't much to say; `moonhtml.build(fn)` takes a single function as its argument and sets its environment to a special table where all *unknown* values are turned into functions that generate HTML tags. It returns a function that can be called with another function as its single argument which handles output `moonhtml.build(fn)(out)`. For example, you could write `moonhtml.build(->h1 'hello world')(print)` to print `<h1>hello world</h1>`. A shorthand for this is `moonhtml.render(out, fn)`, as seen in the example above.

Compatibility with Lapis
-----

Not really an issue. This is *not* a 1:1 clone of the lapis generator syntax, but an attempt at recreating it in my own way. Many things may work the same way and simpler code snippets may work in either of the two, but more complex constructs may require some adaptation. The fact that MoonHTML flattens its arguments also means that you can do a lot more "weird stuff" with it that just wouldn't work in lapis, so be aware of that.

Changelog
-----

### 1.1.0

- MoonHTML doesn't have any concept of buffers anymore, instead you pass it a function that handles your output (see examples)
- The pair method is gone, and instead there is emv, which only returns an environment
- build now returns a function, which in turn accepts as its first argument a function that handles output. All aditional arguments are passed to the function provided by the user

Note that I intend to use this mainly inside [Vim](https://vim.sourceforge.io/), whre I have a macro set up to feed the visual selection through the moonscript interpreter and replace it with its output.
I literally just copied the above code example, selected it, pressed Ctrl+Enter and it turned into the HTML code you see.

License: [The Unlicense](license.md)
