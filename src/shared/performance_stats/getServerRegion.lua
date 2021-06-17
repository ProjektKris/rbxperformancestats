local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local function getRegion()
	local longitude = HttpService:JSONDecode(HttpService:GetAsync("http://ip-api.com/json/")).lon
	local host = "NA" -- north america is default

	if longitude > -180 and longitude <= -105 then
		host = "WUS" -- US-West
	elseif longitude > -105 and longitude <= -90 then
		host = "CUS" -- US-Central
	elseif longitude > -90 and longitude <= 0 then
		host = "EUS" -- US-Eastern
	elseif longitude <= 75 and longitude > 0 then
		host = "EU" -- europe
	elseif longitude <= 180 and longitude > 75 then
		host = "AS" -- asia
	end
	return host
end

return function()
	if not RunService:IsClient() then -- make sure that clientside doesnt 'accidentally' gain access
		local success, result = pcall(getRegion)
		if success then
			return result
		else
			warn(string.format("getServerRegion failed to get server region: %s\nRetrying in 10 seconds", tostring(result)))
			wait(10)
			local s2, r2 = pcall(getRegion)
			if s2 then
				return r2
			else
				warn(string.format("getServerRegion failed to get server region for the second time: %s\nabandoning", tostring(result)))
				return ""
			end
		end
	else
		warn("getServerRegion: client tried to access")
	end
end
