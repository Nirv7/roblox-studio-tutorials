local prompt = script.Parent:WaitForChild("ProximityPrompt")
local doorModel = script.Parent.Parent
local lasers = doorModel:WaitForChild("Lasers")

local TycoonModel = script:FindFirstAncestor("TycoonModel")
local Owner = TycoonModel:WaitForChild("Owner")

local enabled = true

prompt.Triggered:Connect(function(player)

	-- check owner
	if player ~= Owner.Value then return end

	if enabled then
		lasers.Transparency = 0.6
		lasers.CanCollide = false
		enabled = false
	else
		lasers.Transparency = 0
		lasers.CanCollide = true
		enabled = true
	end

end)
