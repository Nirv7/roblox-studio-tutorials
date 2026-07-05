local button = script.Parent
local TycoonModel = script:FindFirstAncestor("TycoonModel")
local SaveManager = require(game.ServerScriptService:WaitForChild("SaveManager"))
local Owner = TycoonModel:WaitForChild("Owner")
local storedCash = TycoonModel:WaitForChild("StoredCash")
local display = TycoonModel.Assets.Items.CashButton.DisplayPart.SurfaceGui.TextLabel

storedCash:GetPropertyChangedSignal("Value"):Connect(function()
	display.Text = "$" .. storedCash.Value
end)

local debounce = false

button.Touched:Connect(function(hit)

	if debounce then return end

	local player = game.Players:GetPlayerFromCharacter(hit.Parent)

	if player and player == Owner.Value then

		debounce = true

		local cash = player:WaitForChild("leaderstats"):WaitForChild("Cash")
		cash.Value += storedCash.Value
		storedCash.Value = 0
		SaveManager.SavePlayer(player)

		task.wait(1)
		debounce = false
	end

end)
