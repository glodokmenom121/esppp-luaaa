--=====================================
-- AUTO SWING WHEN BALL NEAR (RACKET STYLE)
--=====================================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

--=====================================
-- SETTINGS
--=====================================
local AUTO_SWING = false
local HIT_RADIUS = 18 -- jarak hit (semakin besar = semakin OP)
local SWING_COOLDOWN = 0.12
local lastSwing = 0

--=====================================
-- GET BALL (AUTO FIND)
--=====================================
local function getBall()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (
            v.Name:lower():find("ball") or
            v.Name:lower():find("shuttle")
        ) then
            return v
        end
    end
end

--=====================================
-- AUTO SWING LOGIC
--=====================================
RunService.Heartbeat:Connect(function()
    if not AUTO_SWING then return end
    local char = LP.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local ball = getBall()
    if not ball then return end

    local dist = (ball.Position - hrp.Position).Magnitude
    if dist <= HIT_RADIUS and tick() - lastSwing >= SWING_COOLDOWN then
        lastSwing = tick()

        -- swing (mouse click)
        VIM:SendMouseButtonEvent(0,0,0,true,game,0)
        task.wait()
        VIM:SendMouseButtonEvent(0,0,0,false,game,0)
    end
end)

--=====================================
-- GUI
--=====================================
local gui = Instance.new("ScreenGui", PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,130)
frame.Position = UDim2.new(0,30,0.45,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,32)
title.Text = "AUTO SWING (BALL NEAR)"
title.BackgroundColor3 = Color3.fromRGB(15,15,15)
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 13

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1,-20,0,40)
toggle.Position = UDim2.new(0,10,0,45)
toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.Gotham
toggle.TextSize = 13
toggle.Text = "AUTO SWING : OFF"

toggle.MouseButton1Click:Connect(function()
    AUTO_SWING = not AUTO_SWING
    toggle.Text = "AUTO SWING : "..(AUTO_SWING and "ON" or "OFF")
end)

local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1,-20,0,30)
info.Position = UDim2.new(0,10,1,-35)
info.BackgroundTransparency = 1
info.Text = "Radius: "..HIT_RADIUS.." | Hide: ="
info.TextColor3 = Color3.fromRGB(170,170,170)
info.Font = Enum.Font.Gotham
info.TextSize = 11

--=====================================
-- HIDE GUI (=)
--=====================================
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Equals then
        frame.Visible = not frame.Visible
    end
end)
