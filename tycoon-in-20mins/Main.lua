--// Variables
local TycoonModel = script:FindFirstAncestor("TycoonModel")

local Assets = TycoonModel:WaitForChild("Assets")
local PlacedItems = TycoonModel:WaitForChild("PlacedItems")
local Owner = TycoonModel:WaitForChild("Owner")

--// Asset Folders
local Buttons = Assets:WaitForChild("Buttons")

--// Unlock Button Function
local function UnlockButton(buttonName)
	local button = Buttons:FindFirstChild(buttonName .. "Button")
	if button then
		local part = button:FindFirstChild("ButtonPart")
		if part then
			part.Transparency = 0
			part.CanCollide = true
			
			local gui = part:FindFirstChild("BillboardGui")
			if gui then
				gui.Enabled = true
			end
		end
	end
end

--// Owner Claim System
local Door = TycoonModel.Assets.Items.OwnerDoor.MainDoor
local TextLabel = Door.SurfaceGui.TextLabel

--// Check If Player Already Owns A Tycoon
local function PlayerOwnsTycoon(player)
	for _, tycoon in pairs(workspace.TycoonsFolder:GetChildren()) do
		if tycoon:FindFirstChild("Owner") and tycoon.Owner.Value == player then
			return true
		end
	end
	return false
end

--// Claim Tycoon
Door.Touched:Connect(function(hit)
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if not player then return end

	-- Already owns another tycoon
	if PlayerOwnsTycoon(player) then return end

	-- Already claimed
	if Owner.Value ~= nil then return end

	Owner.Value = player
	print(player.Name .. " claimed:", TycoonModel.Name)

	local data = player:WaitForChild("Data")
	local itemsFolder = data:WaitForChild("Items")
	local cash = data:WaitForChild("Cash")

	-- Apply cash
	player.leaderstats.Cash.Value = cash.Value

	-- Load items
	for _, item in pairs(itemsFolder:GetChildren()) do
		local itemName = item.Name

		if not PlacedItems:FindFirstChild(itemName) then
			local template = game.ServerStorage.TycoonAssets:FindFirstChild(itemName)
			if template then
				template:Clone().Parent = PlacedItems
			end
		end

		local button = Buttons:FindFirstChild(itemName .. "Button")
		if button then
			button:Destroy()
		end
	end

	TextLabel.Text = player.Name .. "'s Tycoon"
end)

--// Buying System
local DataModule = require(game.ServerScriptService:WaitForChild("DataModule"))
local SaveManager = require(game.ServerScriptService:WaitForChild("SaveManager"))
local ServerStorage = game:GetService("ServerStorage")

for _, button in pairs(Buttons:GetChildren()) do

	local part = button:WaitForChild("ButtonPart")
	local price = button:WaitForChild("Price")
	local itemName = button:WaitForChild("Item")

	local debounce = false

	part.Touched:Connect(function(hit)
		if debounce then return end

		local player = game.Players:GetPlayerFromCharacter(hit.Parent)
		if not player then return end

		if player ~= Owner.Value then return end

		local cash = player:WaitForChild("leaderstats"):WaitForChild("Cash")

		-- Already owned
		if DataModule:HasItem(player, itemName.Value) then
			print("Already owned:", itemName.Value)
			return
		end

		if cash.Value >= price.Value then
			debounce = true

			cash.Value -= price.Value

			local item = ServerStorage:WaitForChild("TycoonAssets"):FindFirstChild(itemName.Value)
			if not item then
				warn("Item not found:", itemName.Value)
				debounce = false
				return
			end

			item:Clone().Parent = PlacedItems

			DataModule:AddItem(player, itemName.Value)
			SaveManager.SavePlayer(player)

			button:Destroy()
			
			--// Unlock Next Buttons
			for _, nextButton in pairs(Buttons:GetChildren()) do
				local dependency = nextButton:FindFirstChild("Dependency")

				for _, nextButton in pairs(Buttons:GetChildren()) do
					local dependency = nextButton:FindFirstChild("Dependency")

					if dependency and dependency.Value == itemName.Value then
						local part = nextButton:FindFirstChild("ButtonPart")
						if part then
							part.Transparency = 0
							part.CanCollide = true

							local gui = part:FindFirstChild("BillboardGui")
							if gui then
								gui.Enabled = true
							end
						end
					end
				end
			end 
		end 
	end)
end
