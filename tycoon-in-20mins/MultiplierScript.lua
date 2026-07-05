local upgrader = script.Parent
local TycoonModel = script:FindFirstAncestor("TycoonModel")
local storedCash = TycoonModel:WaitForChild("StoredCash")

local debounce = {}

upgrader.Touched:Connect(function(hit)

	-- check if it's a dropper part
	if not hit:FindFirstChild("CashValue") then return end

	if debounce[hit] then return end
	debounce[hit] = true

	local value = hit.CashValue.Value

	-- 🔥 upgrade multiplier
	local upgraded = math.floor(value * 3)

	storedCash.Value += upgraded
end)
