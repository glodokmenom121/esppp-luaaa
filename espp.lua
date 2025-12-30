-- Simple ESP Menu (Box + Line + Name + Distance)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ====== STATE ======
local ESP_ENABLED = false
local BOX_ENABLED = true
local LINE_ENABLED = true
local TEXT_ENABLED = true

local ESPObjects = {}

-- ====== GUI ======
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ESPMenu"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 230, 0, 215)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,35)
title.Text = "Simple ESP Menu"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

-- ====== BUTTON MAKER ======
local function createButton(text, posY)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0.9,0,0,30)
	btn.Position = UDim2.new(0.05,0,0,posY)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	btn.TextColor3 = Color3.new(1,1,1)
	return btn
end

local espBtn  = createButton("ESP : OFF", 45)
local boxBtn  = createButton("BOX : ON", 85)
local lineBtn = createButton("LINE : ON", 125)
local textBtn = createButton("TEXT : ON", 165)

-- ====== CREATE ESP ======
local function createESP(player)
	if player == LocalPlayer then return end

	local box = Drawing.new("Square")
	box.Thickness = 2
	box.Color = Color3.fromRGB(0,255,0)
	box.Filled = false
	box.Visible = false

	local line = Drawing.new("Line")
	line.Thickness = 2
	line.Color = Color3.fromRGB(255,255,255)
	line.Visible = false

	local text = Drawing.new("Text")
	text.Size = 14
	text.Center = true
	text.Outline = true
	text.Color = Color3.fromRGB(255,255,255)
	text.Visible = false

	ESPObjects[player] = {
		Box = box,
		Line = line,
		Text = text
	}
end

local function removeESP(player)
	if ESPObjects[player] then
		for _,obj in pairs(ESPObjects[player]) do
			obj:Remove()
		end
		ESPObjects[player] = nil
	end
end

-- ====== PLAYER HANDLER ======
for _,p in pairs(Players:GetPlayers()) do
	createESP(p)
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

-- ====== BUTTON EVENTS ======
espBtn.MouseButton1Click:Connect(function()
	ESP_ENABLED = not ESP_ENABLED
	espBtn.Text = ESP_ENABLED and "ESP : ON" or "ESP : OFF"
end)

boxBtn.MouseButton1Click:Connect(function()
	BOX_ENABLED = not BOX_ENABLED
	boxBtn.Text = BOX_ENABLED and "BOX : ON" or "BOX : OFF"
end)

lineBtn.MouseButton1Click:Connect(function()
	LINE_ENABLED = not LINE_ENABLED
	lineBtn.Text = LINE_ENABLED and "LINE : ON" or "LINE : OFF"
end)

textBtn.MouseButton1Click:Connect(function()
	TEXT_ENABLED = not TEXT_ENABLED
	textBtn.Text = TEXT_ENABLED and "TEXT : ON" or "TEXT : OFF"
end)

-- ====== ESP UPDATE ======
RunService.RenderStepped:Connect(function()
	for player,esp in pairs(ESPObjects) do
		local char = player.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChild("Humanoid")

		if ESP_ENABLED and hrp and hum and hum.Health > 0 then
			local pos, onscreen = Camera:WorldToViewportPoint(hrp.Position)

			if onscreen then
				local distance = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)

				-- BOX
				if BOX_ENABLED then
					local size = Vector2.new(2000 / pos.Z, 3000 / pos.Z)
					esp.Box.Size = size
					esp.Box.Position = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
					esp.Box.Visible = true
				else
					esp.Box.Visible = false
				end

				-- LINE
				if LINE_ENABLED then
					esp.Line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
					esp.Line.To = Vector2.new(pos.X, pos.Y)
					esp.Line.Visible = true
				else
					esp.Line.Visible = false
				end

				-- TEXT (NAME + DISTANCE)
				if TEXT_ENABLED then
					esp.Text.Text = player.Name .. " [" .. distance .. "m]"
					esp.Text.Position = Vector2.new(pos.X, pos.Y - 35)
					esp.Text.Visible = true
				else
					esp.Text.Visible = false
				end
			else
				esp.Box.Visible = false
				esp.Line.Visible = false
				esp.Text.Visible = false
			end
		else
			esp.Box.Visible = false
			esp.Line.Visible = false
			esp.Text.Visible = false
		end
	end
end)

print("ESP + Name + Distance Loaded")
