-- clientside
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local module = require(ReplicatedStorage.Common.performance_stats.client)

local performance_stats = module.init()
performance_stats:render(
	game.Players.LocalPlayer.PlayerGui,
	1,
	"FPS: _fps_ | PhysFPS: _physfps_ | Ping: _ping_ | ServerHB: _serverhb_ | ServerStep: _serverstep_",
	{}
)