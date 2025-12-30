--=====================================
-- AUTO HIT (REAL HITBOX METHOD)
--=====================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()

--=====================================
-- SETTINGS
--=====================================
local ENABLE = false
local HITBOX_SIZE = Vector3.new(10,10,10) -- OP SIZE
local hitbox

--=====================================
-- CREATE HITBOX
--=====================================
local function createHitbox()
    if hitbox then hitbox:Destroy() end

    hitbox = Instance.new("Part")
    hitbox.Size = HITBOX_SIZE
    hitbox.Transparency = 0.7
    hitbox.Color = Color3.fromRGB(0,255,0)
    hitbox.Material = Enum.Material.ForceField
    hitbox.CanCollide = false
    hitbox.Anchored = false
    hitbox.Name = "AutoHitbox"
    hitbox.Parent = Char

    local weld = Instance.new("WeldConstraint", hitbox)
    weld.Part0 = hitbox
    weld.Part1 = Char:WaitForChild("HumanoidRootPart")
end

--=====================================
-- BALL TOUCH = AUTO HIT
--=====================================
local function isBall(part)
    return part:IsA("BasePart") and part.Name:lower():find("ball")
end

local debounce = false
local function connectHit()
    hitbox.Touched:Connect(function(part)
        if debounce then return end
        if isBall(part) then
            debounce = true

            -- fake swing by changing humanoid state
            local hum = Char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end

            task.delay(0.15, function()
                debounce = false
            end)
        end
    end)
end

--=====================================
-- GUI
--=====================================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,110)
frame.Position = UDim2.new(0,30,0.45,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "AUTO HIT (REAL)"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(15,15,15)
title.Font = Enum.Font.GothamBold
title.TextSize = 13

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1,-20,0,40)
toggle.Position = UDim2.new(0,10,0,40)
toggle.Text = "AUTO HIT : OFF"
toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.Gotham
toggle.TextSize = 13

toggle.MouseButton1Click:Connect(function()
    ENABLE = not ENABLE
    toggle.Text = "AUTO HIT : "..(ENABLE and "ON" or "OFF")

    if ENABLE then
        createHitbox()
        connectHit()
    else
        if hitbox then hitbox:Destroy() hitbox = nil end
    end
end)

--=====================================
-- HIDE GUI (=)
--=====================================
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Equals then
        frame.Visible = not frame.Visible
    end
end)
