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

## API:
**app=vicky:new()**  
create new application instance

#### filter usage
**app[@method path]=fn(next,params)**  
add request filter,path can be "",for all path
method can be empty str and then it will filter all methods.eg `app['@^/test']=fn`
path can be named path(eg./user/:id) or regular expression(using ngx.re)
params contains path args
`next` is a function , invoking next() to pass the request.
`params` is path params.

#### handler usage
**app[method path]=fn(params)**  
add request hanndler for specified method and path
method: can be one of [get post put delete patch options head trace all],default method is `get` if method is empty string
*path: path has 3 pattern*  
1. exact path. eg /user  
2. named param path. eg /user/:id ,id will be in params of fn  
3. regexp path.eg ^/test/(\w+)$, params will have the group params    
*match order:*  
1. if exact path matched,it will be execute first  
2. match named path and regexp path by adding order

**app.error_handle=fn(e)**  
`fn` will be invoked if error occured in handler

### Typical openresty project layout
```
|
|-conf
    |-nginx.conf
    |-fastcgi_params
|-logs
    |-error.log
    |-access.log
|-lua
    |-resty
        |-vicky.lua
        |-cookie.lua
        |-template.lua
        |-session.lua
        |-session
    |-route
        |-index.lua
    |-service
    |-util
    |-view
    |-conf.lua
    |-err.lua
    |-init.lua
|-public
    |-css
    |-js
    |-img
|-private
|-README.md

~ nginx -p `pwd`
```
## License
MIT
