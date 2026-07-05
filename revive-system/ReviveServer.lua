local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remote = ReplicatedStorage:WaitForChild("Handler")

local function ragdollCharacter(character)
	for _, joint in ipairs(character:GetDescendants()) do
		if joint:IsA("Motor6D") then
			local a0 = Instance.new("Attachment")
			local a1 = Instance.new("Attachment")

			a0.CFrame = joint.C0
			a1.CFrame = joint.C1

			a0.Parent = joint.Part0
			a1.Parent = joint.Part1

			local socket = Instance.new("BallSocketConstraint")
			socket.Attachment0 = a0
			socket.Attachment1 = a1
			socket.Parent = joint.Parent

			joint:Destroy()
		end
	end
end

local function setupCharacter(player, character)
	local humanoid = character:WaitForChild("Humanoid")
	local root = character:WaitForChild("HumanoidRootPart")

	humanoid.BreakJointsOnDeath = false

	local saved = player:FindFirstChild("DeathPosition")

	if saved and saved.Value ~= CFrame.new() then
		root.CFrame = saved.Value
		saved.Value = CFrame.new()
	end

	humanoid.Died:Connect(function()

		saved.Value = root.CFrame

		ragdollCharacter(character)

		local prompt = Instance.new("ProximityPrompt")
		prompt.Name = "RevivePrompt"
		prompt.Parent = root
		prompt.ObjectText = player.Name
		prompt.ActionText = "Revive"
		prompt.HoldDuration = 5
		prompt.RequiresLineOfSight = false
		prompt.Enabled = true

		Remote:FireClient(player, "HidePrompt", prompt)

		prompt.Triggered:Once(function(reviver)

			if not reviver.Character then
				return
			end

			local reviverHumanoid = reviver.Character:FindFirstChild("Humanoid")

			if not reviverHumanoid or reviverHumanoid.Health <= 0 then
				return
			end

			prompt.Enabled = false

			player:LoadCharacter()

			prompt:Destroy()
		end)
	end)
end

Players.PlayerAdded:Connect(function(player)

	local deathPosition = Instance.new("CFrameValue")
	deathPosition.Name = "DeathPosition"
	deathPosition.Value = CFrame.new()
	deathPosition.Parent = player

	player.CharacterAdded:Connect(function(character)
		setupCharacter(player, character)
	end)

	player:LoadCharacter()
end)
