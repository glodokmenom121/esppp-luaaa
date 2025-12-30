--========================================
-- RACKET RIVALS - BALL HITBOX (FIXED)
--========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

--====================
-- STATE
--====================
local HITBOX_ON = false
local HITBOX_SIZE = 10
local GUI_VISIBLE = true

local currentBall
local adorn

--====================
-- FIND REAL BALL
--====================
local function findBall()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart")
        and v.Size.Magnitude < 8
        and v.AssemblyLinearVelocity.Magnitude > 1
        and not v.Anchored
        and v.CanCollide == false then
            return v
        end
    end
end

--====================
-- APPLY HITBOX
--====================
local function attachHitbox(ball)
    if adorn then adorn:Destroy() end

    adorn = Instance.new("BoxHandleAdornment")
    adorn.Name = "BallHitbox"
    adorn.Adornee = ball
    adorn.AlwaysOnTop = true
    adorn.ZIndex = 10
    adorn.Transparency = 0.5
    adorn.Color3 = Color3.fromRGB(0,255,0)
    adorn.Size = Vector3.new(HITBOX_SIZE, HITBOX_SIZE, HITBOX_SIZE)
    adorn.Parent = ball
end

--====================
-- LOOP
--====================
RunService.RenderStepped:Connect(function()
    if not HITBOX_ON then
        if adorn then adorn.Visible = false end
        return
    end

    local ball = findBall()
    if ball then
        if ball ~= currentBall then
            currentBall = ball
            attachHitbox(ball)
        end
        adorn.Size = Vector3.new(HITBOX_SIZE, HITBOX_SIZE, HITBOX_SIZE)
        adorn.Visible = true
    end
end)

--====================
-- GUI
--====================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(220,170)
frame.Posi
