s_buf = require"strbuffer"
package.path = '?.lua'
moonhtml = require 'html'

render = (fn, ...) ->
	buf = s_buf'\n'
	moonhtml.build(fn)(buf\append, ...)
	return tostring(buf)

test "additional arguments should get passed", ->
	assert.equal '<html>\nstring\n</html>', render ((t)->html(type t)), 'test'

describe "moonhtml", ->
	it "should work", ->
		assert.is_string render -> html!

	describe "void tags", ->
		it "should not have closing tags when empty", ->
			assert.equal '<br>', render -> br!
		it "should have closing tags when not empty", ->
			assert.equal '<br>\ntest\n</br>', render -> br 'test'

	describe "non-void tags", ->
		it "should always have closing tags", ->
			assert.equal '<html>\n</html>', render -> html!
			assert.equal '<html>\ntest\n</html>', render -> html 'test'
