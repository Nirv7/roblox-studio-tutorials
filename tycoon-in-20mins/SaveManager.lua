--// Services
local DataStoreService = game:GetService("DataStoreService")

--// DataStore
local datastore = DataStoreService:GetDataStore("TYCOON_DATA_V2")

--// Module
local SaveManager = {}

--// Save Player Data
function SaveManager.SavePlayer(player)
	local dataFolder = player:FindFirstChild("Data")
	if not dataFolder then return end

	local itemsFolder = dataFolder:FindFirstChild("Items")
	local items = {}

	--// Collect Items
	if itemsFolder then
		for _, item in ipairs(itemsFolder:GetChildren()) do
			table.insert(items, item.Name)
		end
	end

	--// Leaderstats
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then return end

	local cash = leaderstats:FindFirstChild("Cash")
	if not cash then return end

	--// Add Stored Cash From Tycoon
	for _, tycoon in pairs(workspace.TycoonsFolder:GetChildren()) do
		if tycoon:FindFirstChild("Owner") and tycoon.Owner.Value == player then
			local storedCash = tycoon:FindFirstChild("StoredCash")
			if storedCash then
				cash.Value += storedCash.Value
				storedCash.Value = 0
			end
		end
	end

	--// Data Table
	local dataToSave = {
		Cash = cash.Value,
		Items = items
	}

	print("Saving:", dataToSave)

	--// Save
	pcall(function()
		datastore:SetAsync(player.UserId, dataToSave)
	end)
end

return SaveManager
