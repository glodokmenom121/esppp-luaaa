--====================================
-- RACKET RIVALS - AUTO BALL HITBOX
--====================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer

--====================
-- SETTINGS
--====================
local ENABLED = false
local HITBOX_SIZE = 12
local ATTACH_RADIUS = 18
local GUI_VISIBLE = true

local currentBall
local adorn
local rangeCircle

--====================
-- CHARACTER
--====================
local function getHRP()
    local char = LP.Character
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
end

--====================
-- FIND BALL NEAR PLAYER
--====================
local function findBallNear()
    local hrp = getHRP()
    if not hrp then return end

    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart")
        and not v.Anchored
        and not v.CanCollide
        and v.Size.Magnitude < 8 then

            local dist = (v.Position - hrp.Position).Magnitude
            if dist <= ATTACH_RADIUS then
                return v
            end
        end
    end
end

--====================
-- ATTACH HITBOX
--====================
local function attach(ball)
    if adorn then adorn:Destroy() end

    adorn = Instance.new("BoxHandleAdornment")
    adorn.Adornee = ball
    adorn.Size = Vector3.new(HITBOX_SIZE,HITBOX_SIZE,HITBOX_SIZE)
    adorn.Transparency = 0.5
    adorn.Color3 = Color3.fromRGB(0,255,0)
    adorn.AlwaysOnTop = true
    adorn.ZIndex = 10
    adorn.Parent = ball
end

--====================
-- RANGE VISUAL
--====================
local function createCircle()
    if rangeCircle then rangeCircle:Destroy() end

    rangeCircle = Instance.new("CylinderHandleAdornment")
    rangeCircle.Color3 = Color3.fromRGB(0,150,255)
    rangeCircle.Transparency = 0.7
    rangeCircle.Radius = ATTACH_RADIUS
    rangeCircle.Height = 0.1
    rangeCircle.AlwaysOnTop = true
    rangeCircle.Parent = getHRP()
    rangeCircle.Adornee = getHRP()
end

--====================
-- LOOP
--====================
RunService.RenderStepped:Connect(function()
    if not ENABLED then
        if adorn then adorn.Visible = false end
        if rangeCircle then rangeCircle.Visible = false end
        return
    end

    local hrp = getHRP()
    if not hrp then return end

    if not rangeCircle then
        createCircle()
    end
    rangeCircle.Visible = true

    local ball = findBallNear()
    if ball then
        if ball ~= currentBall then
            currentBall = ball
            attach(ball)
        end
        adorn.Size = Vector3.new(HITBOX_SIZE,HITBOX_SIZE,HITBOX_SIZE)
        adorn.Visible = true
    else
        if adorn then adorn.Visible = false end
        currentBall = nil
    end
end)

--====================
-- GUI
--====================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(230,200)
frame.Position = UDim2.fromScale(0.05,0.4)
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

local function btn(txt,y,cb)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-20,0,30)
    b.Position = UDim2.new(0,10,0,y)
    b.Text = txt
    b.Font = Enum.Font.SourceSans
    b.TextSize = 16
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(cb)
    return b
end

local toggle = btn("HITBOX : OFF",40,function()
    ENABLED = not ENABLED
    toggle.Text = "HITBOX : "..(ENABLED and "ON" or "OFF")
end)

btn("SIZE +",80,function()
    HITBOX_SIZE += 2
end)

btn("SIZE -",120,function()
    HITBOX_SIZE = math.max(6, HITBOX_SIZE - 2)
end)

btn("RADIUS +",160,function()
    ATTACH_RADIUS += 2
    createCircle()
end)

btn("RADIUS -",200,function()
    ATTACH_RADIUS = math.max(10, ATTACH_RADIUS - 2)
    createCircle()
end)

--====================
-- HIDE GUI (=)
--====================
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.Equals then
        GUI_VISIBLE = not GUI_VISIBLE
        frame.Visible = GUI_VISIBLE
    end
end)
