--===============================
-- PATRICK AUTO SWING
--===============================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

--===============================
-- STATE
--===============================
local AUTO_SWING = false
local SWING_DELAY = 0.15
local lastSwing = 0

--===============================
-- AUTO SWING LOOP
--===============================
RunService.Heartbeat:Connect(function()
    if not AUTO_SWING then return end
    if tick() - lastSwing < SWING_DELAY then return end

    lastSwing = tick()

    -- left click (swing)
    VIM:SendMouseButtonEvent(0,0,0,true,game,0)
    task.wait()
    VIM:SendMouseButtonEvent(0,0,0,false,game,0)
end)

--===============================
-- GUI
--===============================
local gui = Instance.new("ScreenGui")
gui.Name = "Patrick_AutoSwing_GUI"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,120)
frame.Position = UDim2.new(0,30,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,35)
title.Text = "AUTO SWING"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.BackgroundColor3 = Color3.fromRGB(15,15,15)

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1,-20,0,40)
toggle.Position = UDim2.new(0,10,0,55)
toggle.Text = "AUTO SWING : OFF"
toggle.BackgroundColor3 = Color3.fromRGB(45,45,45)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.Gotham
toggle.TextSize = 13

toggle.MouseButton1Click:Connect(function()
    AUTO_SWING = not AUTO_SWING
    toggle.Text = "AUTO SWING : "..(AUTO_SWING and "ON" or "OFF")
end)

--===============================
-- HIDE GUI (=)
--===============================
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Equals then
        frame.Visible = not frame.Visible
    end
end)
