local DataModule = {}

--// Default Player Data
DataModule.DefaultData = {
	Cash = 0,
	Items = {}
}

--// Add Item To Player
function DataModule:AddItem(player, itemName)
	local data = player:FindFirstChild("Data")
	if not data then return end

	local items = data:FindFirstChild("Items")
	if not items then return end

	if not items:FindFirstChild(itemName) then
		local tag = Instance.new("BoolValue")
		tag.Name = itemName
		tag.Parent = items
	end
end

--// Check If Player Owns Item
function DataModule:HasItem(player, itemName)
	local data = player:FindFirstChild("Data")
	if not data then return false end

	local items = data:FindFirstChild("Items")
	if not items then return false end

	return items:FindFirstChild(itemName) ~= nil
end

return DataModule
