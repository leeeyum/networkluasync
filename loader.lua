adr = "10.0.0.206"
forceDebugOff = false

loadstring(request({
    Url = "http://" .. adr .. "/hook.lua",
    Method = "GET"
}).Body)()