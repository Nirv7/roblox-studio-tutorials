local dropper = script.Parent
local spawnPart = dropper:WaitForChild("SpawnPart")

while task.wait(2) do

	local part = Instance.new("Part")
	part.Size = Vector3.new(1,1,1)
	part.Position = spawnPart.Position
	part.Anchored = false
	part.Parent = workspace 

	-- Value
	local value = Instance.new("IntValue")
	value.Name = "CashValue"
	value.Value = 2
	value.Parent = part

end
