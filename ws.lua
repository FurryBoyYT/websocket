local Services 						= setmetatable({}, { __index = function(Self, Key) return game.GetService(game, Key) end })
local Client 						= Services.Players.LocalPlayer
local SMethod 						= (WebSocket and WebSocket.connect)

if not SMethod then return Client:Kick("\85\110\115\117\112\112\111\114\116\101\100\32\101\120\101\99\117\116\111\114") end

local Main 							= function()
	local Success, WebSocket 		= pcall(SMethod, "\119\115\58\47\47\49\57\50\46\49\54\56\46\48\46\49\52\52\58\57\48\48\48\47")
    local Closed                    = false

	if not Success then return end

	WebSocket:Send(Services.HttpService:JSONEncode({
		Method						= "\65\117\116\104\111\114\105\122\97\116\105\111\110",
		Name						= Client.Name
	}))

	WebSocket.OnMessage:Connect(function(Unparsed)
		local Parsed 				= Services.HttpService:JSONDecode(Unparsed)
		
		if (Parsed.Method == "\69\120\101\99\117\116\101") then
			local Function, Error 	= loadstring(Parsed.Data)

			if Error then return WebSocket:Send(Services.HttpService:JSONEncode({
				Method				= "\69\114\114\111\114",
				Message				= Error
			}))	end
			
			Function()
		end
	end)

        -- electorn
	-- WebSocket.OnClose:Wait()

	WebSocket.OnClose:Connect(function()
        Closed                       = true
    end)

    repeat task.wait() until Closed
end

while task.wait("\49") do
	local Success, Error 			= pcall(Main)
	if not Success then print(Error) end
end
