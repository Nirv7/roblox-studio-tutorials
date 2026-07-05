--// Services
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

--// Modules
local DataModule = require(script.Parent:WaitForChild("DataModule"))
local SaveManager = require(script.Parent:WaitForChild("SaveManager"))

--// DataStore
local dataStore = DataStoreService:GetDataStore("TYCOON_DATA_V2")

--// Internal Save Function
local function SavePlayer(player)
	local dataFolder = player:FindFirstChild("Data")
	if not dataFolder then return end

	local itemsFolder = dataFolder:FindFirstChild("Items")
	local items = {}

	if itemsFolder then
		for _, item in ipairs(itemsFolder:GetChildren()) do
			table.insert(items, item.Name)
		end
	end

	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then return end

	local cash = leaderstats:FindFirstChild("Cash")
	if not cash then return end

	local dataToSave = {
		Cash = cash.Value,
		Items = items
	}

	print("Saving:", dataToSave)

	pcall(function()
		dataStore:SetAsync(player.UserId, dataToSave)
	end)
end

--// Server Shutdown Save
game:BindToClose(function()
	print("Server closing...")

	for _, player in ipairs(Players:GetPlayers()) do
		SavePlayer(player)
	end

	task.wait(2)
end)

--// Player Join
Players.PlayerAdded:Connect(function(player)
	print("Loading:", player.Name)

	--// Create Data Folder
	local dataFolder = Instance.new("Folder")
	dataFolder.Name = "Data"
	dataFolder.Parent = player

	local itemsFolder = Instance.new("Folder")
	itemsFolder.Name = "Items"
	itemsFolder.Parent = dataFolder

	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Parent = dataFolder

	--// Load Data
	local success, data = pcall(function()
		return dataStore:GetAsync(player.UserId)
	end)

	if success and data then
		print("Loaded data:", data)

		cash.Value = data.Cash or 0

		for _, itemName in ipairs(data.Items or {}) do
			DataModule:AddItem(player, itemName)
		end
	else
		print("No data, using default")
		cash.Value = 0
	end
end)

--// Player Leaving
Players.PlayerRemoving:Connect(function(player)
	print("Saving:", player.Name)
	SaveManager.SavePlayer(player)
end)
