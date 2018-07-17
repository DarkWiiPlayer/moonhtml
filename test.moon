buf = require"strbuffer"("\n")

package.path = '?.lua'
import render from require 'html'

buf\append "Test results:"

render buf\append, ->
	html5!
	html ->
		h1 {class: 'test'}, "Hello World"
		p ->
			text "Hello World"
			br!
			img {src: 'the interwebs'}, 'some text'

print(buf)
