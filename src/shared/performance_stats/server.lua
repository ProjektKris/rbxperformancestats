-- serverside only
local run_service = game:GetService("RunService")
local std = require(script.Parent.std)

local module = {}
function module.init()
    local server_hb, server_step = 0, 0
    local remote_function = std.create("RemoteFunction", {
        Parent = script.Parent.Parent,
        Name = "remote_function"
    })
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
        end
    end
end
return module
