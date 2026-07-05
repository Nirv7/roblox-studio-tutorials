local lasers = script.Parent

local TycoonModel = script:FindFirstAncestor("TycoonModel")
local Owner = TycoonModel:WaitForChild("Owner")

lasers.Touched:Connect(function(hit)

	local character = hit.Parent
	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then return end

	local player = game.Players:GetPlayerFromCharacter(character)
	if not player then return end

	-- if NOT owner, damage them
	if player ~= Owner.Value then
		humanoid:TakeDamage(100)
	end

end)
