package = "moonhtml"
version = "dev-2"
source = {
	 url = "git://github.com/DarkWiiPlayer/moonhtml.git";
}
description = {
	 homepage = "https://github.com/DarkWiiPlayer/moonhtml";
	 license = "Unlicense";
}
dependencies = {
	"lua >= 5.1";
}
build = {
	 type = "builtin",
	 modules = {
		 moonhtml = 'html.lua'
	 }
}
