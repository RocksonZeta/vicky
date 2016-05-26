# vicky
A restful framework for openresty.

Expressive HTTP middleware for openresty to make web applications and APIs more enjoyable to write. Vicky's middleware stack flows in a stack-like manner, allowing you to perform actions downstream then filter and manipulate the response upstream.

Vicky is not bundled with any middleware.

## Installation
```
#it will be in luarocks
```
We can put `vicky.lua` in your resty lib directory.

## Example

`lua/init.lua`
```lua
local vicky = require('resty.vicky')
-- as a global variable "app"
app = vicky:new()
-- using filters
app['@'] = function(next)
    ngx.say("filter all requests")
    next();
end

app['@^/user'] = function(next)
	ngx.say("filter for /user/*")
	next();
end

-- handles. default method is get
app['/test'] = function()
	ngx.say("test");
end

app['post /hello'] = function()
	ngx.exec('/private/hello.html')
end

-- named path handle
app['/user/:name'] = function(params)
	ngx.say("name:"..params.name);
end

-- ExpReg path handle should start with "^"
app['^/reg/(.*)$'] = function(params)
	ngx.say(params[0]);
end

```

`nginx.conf` demo
```
http {
    index index.html;
    lua_package_path 'lua/?.lua;/blah/?.lua;;';
    lua_code_cache off;
    # init app
    init_by_lua_file lua/init.lua;
    server {
        listen       2000;
        server_name  localhost;
        default_type text/html;
        root public;
        location / {
            try_files $uri $uri.html @lua;
        }
        #for index page
        location = / {
            try_files /index.html @lua;
        }
        location @lua {
            content_by_lua 'app:handle()';
        }
        location /private {
            internal;
            alias private;
        }
    }
}
```
## Supports
**Nginx API for Lua:** [lua-nginx-module](https://github.com/openresty/lua-nginx-module#nginx-api-for-lua)  
**Awesome resty:** [awesome resty](https://github.com/bungle/awesome-resty)  
**Cookie:** [lua-resty-cookie](https://github.com/cloudflare/lua-resty-cookie)  
**Session:** [lua-resty-session](https://github.com/bungle/lua-resty-session)  
**Template:** [lua-resty-template](https://github.com/bungle/lua-resty-template)
## License
MIT