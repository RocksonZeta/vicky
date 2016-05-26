package = "vicky"
version = "dev-2"
source = {
	url = "git@github.com:RocksonZeta/vicky.git"
}
description = {
    summary = "A restful framework for openresty.",
    detailed = "Expressive HTTP middleware for openresty to make web applications and APIs more enjoyable to write.",
    homepage = "https://github.com/RocksonZeta/vicky",
    maintainer = "Rockson Zeta <uzoice@hotmail.com>",
    license = "MIT"
}
dependencies = {
    "lua >= 5.1"
}
build = {
    type = "builtin",
    modules = {
        ["resty.vicky"] = "lib/resty/vicky.lua"
    }
}