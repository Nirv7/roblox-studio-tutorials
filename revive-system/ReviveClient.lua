local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remote = ReplicatedStorage:WaitForChild("Handler")

Remote.OnClientEvent:Connect(function(action, prompt)

	if action ~= "HidePrompt" then
		return
	end

	if prompt and prompt:IsA("ProximityPrompt") then
		prompt.Enabled = false
	end
end)
