-- clientside only
local run_service = game:GetService("RunService")
local std = require(script.Parent.std)

local module = {}
module.__index = module

function module.init()
    local newClass = {render_step_connection = nil, step = 0}
    newClass.render_step_connection = run_service.RenderStepped:Connect(
                                          function(step)
            newClass.step = step
        end)

    setmetatable(newClass, module)
    return newClass
end
function module:get_fps() -- a method of newClass
    return math.ceil(1 / self.step)
end
function module:get_phys_fps() return workspace:GetRealPhysicsFPS() end
function module:get_ping()
    local remote_function = script.Parent.Parent:FindFirstChild(
                                "remote_function")
    local t0, t1 = 0, 0
    if remote_function then
        t0 = time()
        remote_function:InvokeServer()
        t1 = time()
    end
    return math.ceil((t1 - t0)*1000)
end
function module:get_server_performance()
    local server_hb, server_step
    local remote_function = script.Parent.Parent:FindFirstChild(
                                "remote_function")
    if remote_function then
        server_hb, server_step = remote_function:InvokeServer("stats")
    end
    return math.ceil(1 / server_hb), math.ceil(1 / server_step)
end
function module:render(parent, update_frequency, format, stylesheet)
    local screen_gui = std.create("ScreenGui", {
        Name = "performance_stats",
        ResetOnSpawn = false,
        Parent = parent -- game.Players.LocalPlayer.PlayerGui
    })
    local text_properties = {
        Size = UDim2.new(1,0,0,12),
        Position = UDim2.new(0,0,0,0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.new(1,1,1),
        TextStrokeTransparency = 0,
        Parent = screen_gui
    }
    for attribute_name, value in pairs(stylesheet) do
        text_properties[attribute_name] = value
    end
    local text_label = std.create("TextLabel", text_properties)

    -- process
    local subs = string.split(format or
                                  "FPS: _fps_ | PhysFPS: _physfps_ | Ping: _ping_ | ServerHB: _serverhb_ | ServerStep: _serverstep_",
                              "_")
    local thread = coroutine.wrap(function()
        while wait(update_frequency or 1) do
            local text = ""
            local server_hb, server_step = self:get_server_performance()
            for i = 1, #subs do
                local sub = subs[i]
                if sub == "fps" then
                    text = text .. tostring(self:get_fps())
                elseif sub == "physfps" then
                    text = text .. tostring(self:get_phys_fps())
                elseif sub == "ping" then
                    text = text .. tostring(self:get_ping()) .. "ms"
                elseif sub == "serverhb" then
                    text = text .. tostring(server_hb) .. "ms"
                elseif sub == "serverstep" then
                    text = text .. tostring(server_step) .. "ms"
                else
                    text = text .. sub
                end
            end
            text_label.Text = text
        end
    end)
    thread()
    return screen_gui
end
--[[
    FPS
    PhysicsFPS
    Server Heartbeat, Stepped FPS
    Ping

    FPS: 69 | PhysFPS: 69 | Ping: 100ms | ServerHB: 69 | ServerStep: 69
    FPS: _-fps_ | PhysFPS: _physfps_ | Ping: _ping_ | ServerHB: _serverhb_ | ServerStep: _serverstep_
]]
return module
