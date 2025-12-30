--// Volleyball Legends - Ball Hitbox ONLY
--// NO AUTO SWING | NO AUTO CLICK

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local HitboxOn = false
local HitboxSize = Vector3.new(8,8,8)

-- FIND BALL
local function getBall()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("ball") then
            return v
        end
    end
end

-- HITBOX PART
local hitbox = Instance.new("Part")
hitbox.Name = "BallHitbox"
hitbox.Anchored = true
hitbox.CanCollide = false
hitbox.Material = Enum.Material.ForceField
hitbox.Color = Color3.fromRGB(0,170,255)
hitbox.Transparency = 1
hitbox.Parent = workspace

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BallHitboxGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.22,0.26)
frame.Position = UDim2.fromScale(0.05,0.35)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true

local toggleMenu = Instance.new("TextButton", frame)
toggleMenu.Size = UDim2.fromScale(1,0.2)
toggleMenu.Text = "+  HITBOX MENU"
toggleMenu.TextScaled = true
toggleMenu.BackgroundColor3 = Color3.fromRGB(35,35,35)
toggleMenu.TextColor3 = Color3.new(1,1,1)

local content = Instance.new("Frame", frame)
content.Position = UDim2.fromScale(0,0.2)
content.Size = UDim2.fromScale(1,0.8)
content.BackgroundTransparency = 1
content.Visible = false

toggleMenu.MouseButton1Click:Connect(function()
    content.Visible = not content.Visible
end)

local function button(text,y,callback)
    local b = Instance.new("TextButton", content)
    b.Size = UDim2.fromScale(0.9,0.18)
    b.Position = UDim2.fromScale(0.05,y)
    b.Text = text
    b.TextScaled = true
    b.BackgroundColor3 = Color3.fromRGB(55,55,55)
    b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(function()
        callback(b)
    end)
end

button("Hitbox : OFF",0.05,function(b)
    HitboxOn = not HitboxOn
    b.Text = "Hitbox : "..(HitboxOn and "ON" or "OFF")
end)

button("Size +",0.3,function()
    HitboxSize += Vector3.new(2,2,2)
end)

button("Size -",0.55,function()
    HitboxSize = Vector3.new(
        math.max(4,HitboxSize.X-2),
        math.max(4,HitboxSize.Y-2),
        math.max(4,HitboxSize.Z-2)
    )
end)

-- MAIN LOOP
RunService.RenderStepped:Connect(function()
    local ball = getBall()
    if not ball then
        hitbox.Transparency = 1
        return
    end

    hitbox.Size = HitboxSize
    hitbox.CFrame = ball.CFrame
    hitbox.Transparency = HitboxOn and 0.6 or 1
end)
