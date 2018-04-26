package = "moonhtml"
version = "dev-1"
source = {
   url = "git://github.com/DarkWiiPlayer/moonhtml.git"
}
description = {
   homepage = "https://github.com/DarkWiiPlayer/moonhtml";
   license = "Unlicense";
}
dependencies = {
  "lua >= 5.3";
}
build = {
   type = "builtin",
   modules = {
     moonhtml = 'html.lua'
   }
}
