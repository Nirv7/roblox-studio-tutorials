local collector = script.Parent
local TycoonModel = script:FindFirstAncestor("TycoonModel")
local storedCash = TycoonModel:WaitForChild("StoredCash")

local debounce = {}

collector.Touched:Connect(function(hit)
	-- prevent multiple triggers on same part
	if debounce[hit] then return end

	local value = hit:FindFirstChild("CashValue")

	if value then
		debounce[hit] = true

		storedCash.Value += value.Value
		hit:Destroy()
	end
end)
