-- serverside only
local run_service = game:GetService("RunService")
local std = require(script.Parent.std)
local getServerRegion = require(script.Parent.getServerRegion)

local module = {}
function module.init()
    local server_hb, server_step = 0, 0
    local remote_function = std.create("RemoteFunction", {
        Parent = script.Parent.Parent,
        Name = "remote_function"
    })
    local serverRegion = getServerRegion()
    run_service.Heartbeat:Connect(function(step)
        server_hb = step
    end)
    run_service.Stepped:Connect(function(time, step)
        server_step = step
    end)
    remote_function.OnServerInvoke = function(client, item, ...)
        if item == "ping" then
            return true
        elseif item == "stats" then
            return server_hb, server_step
        elseif item == "serverRegion" then
            print(string.format("Player %s requested for serverRegion", client.Name))
            return serverRegion
        end
    end
end
return module
