--=====================================
-- AUTO SWING (REAL HIT FIX)
--=====================================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- CHARACTER
local Char = LP.Character or LP.CharacterAdded:Wait()
LP.CharacterAdded:Connect(function(c)
    Char = c
end)

--=====================================
-- STATE
--=====================================
local AUTO = false
local RANGE = 14
local COOLDOWN = false

--=====================================
-- GET RACKET TOOL
--=====================================
local function getRacket()
    if not Char then return end
    for _,v in pairs(Char:GetChildren()) do
        if v:IsA("Tool") then
            return v
        end
    end
end

--=====================================
-- FIND BALL (FLEXIBLE)
--=====================================
local function getBall()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            local n = v.Name:lower()
            if n:find("ball") or n:find("shuttle") then
                return v
            end
        end
    end
end

--=====================================
-- AUTO SWING LOOP
--=====================================
RunService.Heartbeat:Connect(function()
    if not AUTO then return end
    if COOLDOWN then return end
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end

    local ball = getBall()
    local racket = getRacket()
    if not ball or not racket then return end

    local hrp = Char.HumanoidRootPart
    local dist = (ball.Position - hrp.Position).Magnitude

    if dist <= RANGE then
        COOLDOWN = true

        -- 🔥 REAL SWING
        pcall(function()
            racket:Activate()
        end)

        task.delay(0.18, function()
            COOLDOWN = false
        end)
    end
end)

--=====================================
-- GUI
--=====================================
local gui = Instance.new("ScreenGui")
gui.Name = "AutoSwingGUI"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,110)
frame.Position = UDim2.new(0,40,0.45,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "AUTO SWING"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(15,15,15)
title.BorderSizePixel = 0

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1,-20,0,45)
toggle.Position = UDim2.new(0,10,0,45)
toggle.Text = "AUTO SWING : OFF"
toggle.Font = Enum.Font.Gotham
toggle.TextSize = 13
toggle.TextColor3 = Color3.new(1,1,1)
toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggle.BorderSizePixel = 0

Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,6)

toggle.MouseButton1Click:Connect(function()
    AUTO = not AUTO
    toggle.Text = "AUTO SWING : "..(AUTO and "ON" or "OFF")
    toggle.BackgroundColor3 = AUTO and Color3.fromRGB(0,120,0) or Color3.fromRGB(40,40,40)
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

print("✅ Auto Swing REAL Loaded")
