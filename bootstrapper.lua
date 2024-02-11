adr = "10.0.0.206"
forceDebugOff = false
local git = "leeeyum/networkluasync"

loadstring(request({
    Url = "https://raw.githubusercontent.com/" .. git .. "/main/hook.lua",
    Method = "GET"
}).Body)()