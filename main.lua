-- Simple Hub (Belajar)
-- Fly + WalkSpeed

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SimpleHub"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.Text = "My First Hub"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(40,40,40)

-- Button maker
local function makeButton(text, y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0,240,0,40)
    b.Position = UDim2.new(0.5,-120,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(255,140,0)
    b.TextColor3 = Color3.new(0,0,0)
    return b
end

local speedBtn = makeButton("WalkSpeed : OFF", 60)
local flyBtn = makeButton("Fly : OFF", 120)

-- WalkSpeed
local speedOn = false
speedBtn.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    humanoid.WalkSpeed = speedOn and 50 or 16
    speedBtn.Text = speedOn and "WalkSpeed : ON" or "WalkSpeed : OFF"
end)

-- Fly
local flying = false
local bv, bg

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying

    if flying then
        flyBtn.Text = "Fly : ON"
        bg = Instance.new("BodyGyro", hrp)
        bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
        bg.P = 9e4

        bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(9e9,9e9,9e9)

        RunService.RenderStepped:Connect(function()
            if flying then
                bg.CFrame = workspace.CurrentCamera.CFrame
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 50
            end
        end)
    else
        flyBtn.Text = "Fly : OFF"
        if bg then bg:Destroy() end
        if bv then bv:Destroy() end
    end
end)

print("Hub Loaded")
