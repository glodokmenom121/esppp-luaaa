--========================================
-- PATRICK OP AUTO HIT (GUI FIX)
--========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui") -- <<< FIX UTAMA

--========================
-- SETTINGS
--========================
local ENABLED = false
local SILENT = true
local HIT_RADIUS = 22
local HIT_DELAY = 0.03
local lastHit = 0

--========================
-- CHARACTER SAFE
--========================
local function getHRP()
    local char = LP.Character or LP.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

--========================
-- FIND BALL
--========================
local function getBall()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart")
        and not v.Anchored
        and v.Velocity.Magnitude > 1
        and v.Size.Magnitude < 10 then
            return v
        end
    end
end

--========================
-- HIT
--========================
local function doHit()
    VIM:SendMouseButtonEvent(0,0,0,true,game,0)
    VIM:SendMouseButtonEvent(0,0,0,false,game,0)
end

--========================
-- MAIN LOOP
--========================
RunService.Heartbeat:Connect(function()
    if not ENABLED then return end

    local hrp = getHRP()
    local ball = getBall()
    if not ball then return end

    if (ball.Position - hrp.Position).Magnitude <= HIT_RADIUS then
        if tick() - lastHit >= HIT_DELAY then
            lastHit = tick()
            doHit()
        end
    end
end)

--========================
-- GUI
--========================
local gui = Instance.new("ScreenGui")
gui.Name = "Patrick_OP_GUI"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,230,0,160)
frame.Position = UDim2.new(0,30,0.35,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,35)
title.Text = "PATRICK OP HIT"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.BackgroundColor3 = Color3.fromRGB(15,15,15)

local function makeBtn(text,y,cb)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-20,0,35)
    b.Position = UDim2.new(0,10,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(45,45,45)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 13
    b.MouseButton1Click:Connect(function()
        cb(b)
    end)
end

makeBtn("AUTO HIT : OFF",45,function(b)
    ENABLED = not ENABLED
    b.Text = "AUTO HIT : "..(ENABLED and "ON" or "OFF")
end)

makeBtn("RADIUS : 22",85,function(b)
    HIT_RADIUS += 4
    if HIT_RADIUS > 32 then HIT_RADIUS = 16 end
    b.Text = "RADIUS : "..HIT_RADIUS
end)

makeBtn("SILENT : ON",125,function(b)
    SILENT = not SILENT
    b.Text = "SILENT : "..(SILENT and "ON" or "OFF")
end)

--========================
-- HIDE GUI (=)
--========================
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.Equals then
        frame.Visible = not frame.Visible
    end
end)
