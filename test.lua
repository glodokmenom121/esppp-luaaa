--=====================================
-- RACKET RIVALS AUTO HIT (WORKING)
--=====================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LP = Players.LocalPlayer

local ENABLED = false
local HIT_RADIUS = 18
local HIT_DELAY = 0.05
local lastHit = 0

--====================
-- GET HRP
--====================
local function getHRP()
    local char = LP.Character
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
end

--====================
-- FIND BALL
--====================
local function findBall()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart")
        and not v.Anchored
        and v.Size.Magnitude < 8 then
            return v
        end
    end
end

--====================
-- LOOP
--====================
RunService.Heartbeat:Connect(function()
    if not ENABLED then return end

    local hrp = getHRP()
    if not hrp then return end

    local ball = findBall()
    if not ball then return end

    local dist = (ball.Position - hrp.Position).Magnitude
    if dist <= HIT_RADIUS and tick() - lastHit > HIT_DELAY then
        lastHit = tick()

        -- simulate click (hit)
        VirtualInputManager:SendMouseButtonEvent(
            0, 0, 0,
            true,
            game,
            0
        )
        VirtualInputManager:SendMouseButtonEvent(
            0, 0, 0,
            false,
            game,
            0
        )
    end
end)

--====================
-- TOGGLE (=)
--====================
game:GetService("UserInputService").InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.Equals then
        ENABLED = not ENABLED
        warn("AUTO HIT:", ENABLED)
    end
end)
