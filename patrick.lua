-- ESP MENU + FLY (INFINITE JUMP HOLD) + TOGGLE +
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PatrickProjectMenu"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(220, 170)
frame.Position = UDim2.fromOffset(20, 20)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

Instance.new("UICorner", frame)

-- ESP BUTTON
local espBtn = Instance.new("TextButton", frame)
espBtn.Size = UDim2.fromOffset(200, 40)
espBtn.Position = UDim2.fromOffset(10, 10)
espBtn.Text = "ESP : OFF"
espBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
espBtn.TextColor3 = Color3.new(1,1,1)

-- FLY BUTTON
local flyBtn = Instance.new("TextButton", frame)
flyBtn.Size = UDim2.fromOffset(200, 40)
flyBtn.Position = UDim2.fromOffset(10, 60)
flyBtn.Text = "FLY : OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
flyBtn.TextColor3 = Color3.new(1,1,1)

-- INFO TEXT
local info = Instance.new("TextLabel", frame)
info.Size = UDim2.fromOffset(200, 30)
info.Position = UDim2.fromOffset(10, 115)
info.Text = "Tahan SPACE untuk terbang"
info.TextColor3 = Color3.new(1,1,1)
info.BackgroundTransparency = 1
info.TextScaled = true

-- STATE
local espOn = false
local flyOn = false
local holdingSpace = false
local espObjects = {}

-- ESP FUNCTION
local function createESP(player)
	if player == LocalPlayer then return end

	local box = Drawing.new("Square")
	box.Thickness = 1
	box.Color = Color3.new(1,0,0)
	box.Filled = false
	box.Visible = false

	local name = Drawing.new("Text")
	name.Color = Color3.new(1,1,1)
	name.Size = 14
	name.Center = true
	name.Outline = true
	name.Visible = false

	espObjects[player] = {box = box, name = name}
end

local function removeESP(player)
	if espObjects[player] then
		for _,v in pairs(espObjects[player]) do
			v:Remove()
		end
		espObjects[player] = nil
	end
end

for _,p in pairs(Players:GetPlayers()) do
	createESP(p)
end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

-- ESP RENDER
RunService.RenderStepped:Connect(function()
	for player,data in pairs(espObjects) do
		local char = player.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")

		if espOn and hrp then
			local pos, onscreen = Camera:WorldToViewportPoint(hrp.Position)
			if onscreen then
				data.box.Visible = true
				data.name.Visible = true
				data.box.Size = Vector2.new(50, 80)
				data.box.Position = Vector2.new(pos.X - 25, pos.Y - 40)
				data.name.Text = player.Name
				data.name.Position = Vector2.new(pos.X, pos.Y - 55)
			else
				data.box.Visible = false
				data.name.Visible = false
			end
		else
			data.box.Visible = false
			data.name.Visible = false
		end
	end
end)

-- ESP TOGGLE
espBtn.MouseButton1Click:Connect(function()
	espOn = not espOn
	espBtn.Text = espOn and "ESP : ON" or "ESP : OFF"
end)

-- FLY TOGGLE
flyBtn.MouseButton1Click:Connect(function()
	flyOn = not flyOn
	flyBtn.Text = flyOn and "FLY : ON" or "FLY : OFF"
end)

-- INPUT (SPACE HOLD)
UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.Space then
		holdingSpace = true
	end
	if input.KeyCode == Enum.KeyCode.Equals then
		gui.Enabled = not gui.Enabled
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Space then
		holdingSpace = false
	end
end)

-- FLY LOOP
RunService.RenderStepped:Connect(function()
	if flyOn and holdingSpace then
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)
		end
	end
end)
