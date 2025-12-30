--// Volleyball Legends Assist Script
--// GUI + Ball Hitbox + Enemy Look Direction

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- SETTINGS
local HitboxEnabled = false
local HitboxSize = 8
local DirectionEnabled = false

-- BALL FINDER
local function getBall()
    for _,v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("ball") then
            return v
        end
    end
end

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "VolleyLegendGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.18,0.25)
frame.Position = UDim2.fromScale(0.05,0.3)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextButton", frame)
title.Size = UDim2.fromScale(1,0.18)
title.Text = "+"
title.TextSize = 24
title.BackgroundColor3 = Color3.fromRGB(40,40,40)
title.TextColor3 = Color3.new(1,1,1)

local content = Instance.new("Frame", frame)
content.Position = UDim2.fromScale(0,0.18)
content.Size = UDim2.fromScale(1,0.82)
content.BackgroundTransparency = 1

title.MouseButton1Click:Connect(function()
    content.Visible = not content.Visible
end)

-- BUTTON CREATOR
local function createButton(text, y, callback)
    local b = Instance.new("TextButton", content)
    b.Size = UDim2.fromScale(0.9,0.18)
    b.Position = UDim2.fromScale(0.05,y)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.TextScaled = true
    b.MouseButton1Click:Connect(callback)
end

-- BUTTONS
createButton("Ball Hitbox : OFF", 0.05, function(btn)
    HitboxEnabled = not HitboxEnabled
    btn.Text = "Ball Hitbox : "..(HitboxEnabled and "ON" or "OFF")
end)

createButton("Enemy Direction : OFF", 0.3, function(btn)
    DirectionEnabled = not DirectionEnabled
    btn.Text = "Enemy Direction : "..(DirectionEnabled and "ON" or "OFF")
end)

createButton("Hitbox +", 0.55, function()
    HitboxSize += 2
end)

createButton("Hitbox -", 0.75, function()
    HitboxSize = math.max(4, HitboxSize - 2)
end)

-- HITBOX LOOP
RunService.RenderStepped:Connect(function()
    if HitboxEnabled then
        local ball = getBall()
        if ball then
            ball.Size = Vector3.new(HitboxSize,HitboxSize,HitboxSize)
            ball.Transparency = 0.4
            ball.Material = Enum.Material.ForceField
        end
    end
end)

-- DIRECTION ESP
local lines = {}

RunService.RenderStepped:Connect(function()
    for _,l in pairs(lines) do
        l:Remove()
    end
    table.clear(lines)

    if not DirectionEnabled then return end

    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local startPos, vis1 = Camera:WorldToViewportPoint(hrp.Position)
            local endPos, vis2 = Camera:WorldToViewportPoint(hrp.Position + hrp.CFrame.LookVector * 8)

            if vis1 and vis2 then
                local line = Drawing.new("Line")
                line.From = Vector2.new(startPos.X,startPos.Y)
                line.To = Vector2.new(endPos.X,endPos.Y)
                line.Color = Color3.fromRGB(255,80,80)
                line.Thickness = 2
                line.Visible = true
                table.insert(lines,line)
            end
        end
    end
end)
