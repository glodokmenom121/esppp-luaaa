--========================================
-- PATRICK OP AUTO HIT (RACKET RIVALS)
--========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

local LP = Players.LocalPlayer

--========================
-- SETTINGS
--========================
local ENABLED = false
local SILENT = true
local HIT_RADIUS = 22       -- makin gede makin OP
local HIT_DELAY = 0.03      -- makin kecil makin brutal
local lastHit = 0

--========================
-- GET HRP
--========================
local function getHRP()
    local c = LP.Character
    if c then
        return c:FindFirstChild("HumanoidRootPart")
    end
end

--========================
-- FIND BALL (RR SAFE)
--========================
local function getBall()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart")
        and not v.Anchored
        and v.Size.Magnitude < 9
        and v.Velocity.Magnitude > 1 then
            return v
        end
    end
end

--========================
-- HIT FUNCTION
--========================
local function doHit()
    if SILENT then
        -- silent (no mouse move)
        VIM:SendMouseButtonEvent(0,0,0,true,game,0)
        VIM:SendMouseButtonEvent(0,0,0,false,game,0)
    else
        -- normal click
        mouse1click()
    end
end

--========================
-- MAIN LOOP (SERVER ABUSE)
--========================
RunService.Heartbeat:Connect(function()
    if not ENABLED then return end

    local hrp = getHRP()
    if not hrp then return end

    local ball = getBall()
    if not ball then return end

    local dist = (ball.Position - hrp.Position).Magnitude
    if dist <= HIT_RADIUS and tick() - lastHit > HIT_DELAY then
        lastHit = tick()
        doHit()
    end
end)

--========================
-- GUI
--========================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.Name = "Patrick_OP_RR"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,230,0,180)
frame.Position = UDim2.new(0,20,0.35,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,35)
title.Text = "PATRICK OP HIT"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.BackgroundColor3 = Color3.fromRGB(15,15,15)

local function button(text,y,cb)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-20,0,35)
    b.Position = UDim2.new(0,10,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 13
    b.MouseButton1Click:Connect(function()
        cb(b)
    end)
end

button("AUTO HIT : OFF",45,function(b)
    ENABLED = not ENABLED
    b.Text = "AUTO HIT : "..(ENABLED and "ON" or "OFF")
end)

button("SILENT HIT : ON",85,function(b)
    SILENT = not SILENT
    b.Text = "SILENT HIT : "..(SILENT and "ON" or "OFF")
end)

button("RADIUS : 22",125,function(b)
    HIT_RADIUS = HIT_RADIUS + 4
    if HIT_RADIUS > 32 then HIT_RADIUS = 16 end
    b.Text = "RADIUS : "..HIT_RADIUS
end)

--========================
-- TOGGLE GUI (=)
--========================
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.Equals then
        frame.Visible = not frame.Visible
    end
end)
