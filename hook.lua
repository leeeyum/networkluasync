if clientLoaded then error("ran once") end
getgenv().clientLoaded = true

-- local adr = adr or "10.0.0.206"
local gudReadfile = readfile or nil
local adr = adr or "127.0.0.1"
local pingDelay = 3
local pingTries = 0

local updateStatusCode = function() end
if not forceDebugOff then
    local status = Instance.new("ScreenGui", game:GetService("CoreGui"))
    status.ResetOnSpawn = false
    status.DisplayOrder = 9e9

    local fr = Instance.new("Frame", status)
    fr.Size = UDim2.new(1, 0, 1, 0)
    fr.BackgroundTransparency = 1

    local txtLbl = Instance.new("TextLabel", fr)
    txtLbl.BackgroundTransparency = 1
    txtLbl.AnchorPoint = Vector2.new(.5, 0)
    txtLbl.Size = UDim2.new(1, 0, .02, 0)
    txtLbl.Position = UDim2.new(.5, 0, .97, 0)

    txtLbl.TextScaled = true
    txtLbl.Text = ""

    updateStatusCode = function(str : string, err : boolean)
        txtLbl.Text = "[" .. str .. "]"
        txtLbl.TextColor3 = (err and Color3.new(1, 0, 0)) or Color3.new(0, 1, 0)
    end
end

updateStatusCode("Connecting to " .. adr)
do
    local try = 0
    while true do
        local req = request({
            Url = "http://" .. adr .. "/hook.lua",
            Method = "GET"
        })
        if req.Success then
            break
        end
        if try > pingTries then
            updateStatusCode("Server Offline, Address: " .. adr)
        end
        try += 1
        task.wait(pingDelay)
    end
end
updateStatusCode("Connected to " .. adr)

local funcs = {
    readfile = function(loc : string)
        local s, r = pcall(function()
            return readfile(loc)
        end)
        if s then
            return r
        else
            local req = request({
                Url = "http://" .. adr .. "/sandbox/" .. loc,
                Method = "GET"
            })
            if req.Success then
                return req.Body
            end
        end
    end
}

getgenv().readfile = funcs.readfile
getgenv().shared = getgenv()