# rbxperformancestats

Author: @ProjektKris

This roblox package enables you to show performance stats in a more customizable and less invasive way.

## Example
```lua
-- clientside
local module = require()

local performance_stats = module.init()
performance_stats:render(
    game.Players.LocalPlayer.PlayerGui,
    1,
    "FPS: _fps_ | PhysFPS: _physfps_ | Ping: _ping_ | ServerHB: _serverhb_ | ServerStep: _serverstep_",
    {}
)
```

```lua
-- serverside
local module = require()

local performance_stats = module.init()
```

## Docs

### Dir
```
src {
    client // client handler module
    server // server handler module
    std // standard library
}
```

### client.lua

`class` .init()

> creates a new clienthandler class

`number` :get_fps()

> returns the current clientside fps

`number` :get_phys_fps()

> returns the current physics fps

`number` :get_ping()

> returns the client-server-client ping

`number`, `number` :get_server_performance()

> returns the server heartbeat step and server stepped step

`ScreenGui` :render(`Instance` parent, `number` update_frequency, `string` format, `Object<any>` stylesheet)

> renders the performance stats ui

### server.lua

`void` .init()

> initializes the serverside module, this module handles the remotes

### std.lua

`Instance` .create(`string` instance_type, `Object<any>` attributes)

> creates a new instance with the said properties/attributes