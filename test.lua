--==============================
-- BALL HITBOX GUI (RACKET RIVALS)
--==============================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

--==============================
-- STATE
--==============================
local HITBOX_ON = false
local HITBOX_SIZE = 8
local GUI_VISIBLE = true
local ballHitbox = nil

--==============================
-- FIND BALL
--==============================
local function findBall()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart")
        and string.find(v.Name:lower(),"ball") then
            return v
        end
    end
end

--==============================
-- APPLY HITBOX
--==============================
local function applyHitbox(ball)
    if not ball then return end

    if not ballHitbox then
        ballHitbox = Instance.new("BoxHandleAdornment")
        ballHitbox.Name = "BallHitbox"
        ballHitbox.Adornee = ball
        ballHitbox.AlwaysOnTop = true
        ballHitbox.ZIndex = 10
        ballHitbox.Transparency = 0.6
        ballHitbox.Color3 = Color3.fromRGB(0,255,0)
        ballHitbox.Parent = ball
    end

    ballHitbox.Size = Vector3.new(HITBOX_SIZE, HITBOX_SIZE, HITBOX_SIZE)
    ballHitbox.Visible = HITBOX_ON
end

--==============================
-- UPDATE LOOP
--==============================
RunService.RenderStepped:Connect(function()
    if not HITBOX_ON then
        if ballHitbox then
            ballHitbox.Visible = false
        end
        return
    end

    local ball = findBall()
    if ball then
        applyHitbox(ball)
    end
end)

--==============================
-- GUI
--==============================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.Name = "BallHitboxGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(220,160)
frame.Position = UDim2.fromScale(0.05,0.35)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "BALL HITBOX"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local function makeBtn(text,y,callback)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-20,0,30)
    b.Position = UDim2.new(0,10,0,y)
    b.Text = text
    b.Font = Enum.Font.SourceSans
    b.TextSize = 16
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(callback)
    return b
end

local toggleBtn = makeBtn("HITBOX : OFF",40,function()
    HITBOX_ON = not HITBOX_ON
    toggleBtn.Text = "HITBOX : "..(HITBOX_ON and "ON" or "OFF")
end)

local plusBtn = makeBtn("SIZE +",80,function()
    HITBOX_SIZE += 2
end)

local minusBtn = makeBtn("SIZE -",120,function()
    HITBOX_SIZE = math.max(4, HITBOX_SIZE - 2)
end)

--==============================
-- HIDE / SHOW GUI (=)
--==============================
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.Equals then
        GUI_VISIBLE = not GUI_VISIBLE
        frame.Visible = GUI_VISIBLE
    end
end)
