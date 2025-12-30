--=====================================
-- AUTO SWING (SERVER VALID)
--=====================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()

LP.CharacterAdded:Connect(function(c)
    Char = c
end)

--=====================================
-- STATE
--=====================================
local AUTO = false
local RANGE = 18
local COOLDOWN = false

--=====================================
-- GET RACKET
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
-- FIND BALL
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
    if not AUTO or COOLDOWN then return end
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end

    local ball = getBall()
    local racket = getRacket()
    if not ball or not racket then return end

    local hrp = Char.HumanoidRootPart
    local dist = (ball.Position - hrp.Position).Magnitude

    if dist <= RANGE then
        COOLDOWN = true

        -- 🔥 FACE BALL (INI PENTING)
        hrp.CFrame = CFrame.new(
            hrp.Position,
            Vector3.new(ball.Position.X, hrp.Position.Y, ball.Position.Z)
        )

        task.wait(0.05)

        -- 🔥 REAL MOUSE CLICK
        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait(0.02)
        VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)

        task.delay(0.25, function()
            COOLDOWN = false
        end)
    end
end)

--=====================================
-- GUI
--=====================================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.Name = "AutoSwingGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,110)
frame.Position = UDim2.new(0,40,0.45,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0

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

toggle.MouseButton1Click:Connect(function()
    AUTO = not AUTO
    toggle.Text = "AUTO SWING : "..(AUTO and "ON" or "OFF")
    toggle.BackgroundColor3 = AUTO and Color3.fromRGB(0,120,0) or Color3.fromRGB(40,40,40)
end)

--=====================================
-- HIDE GUI (=)
--=====================================
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.Equals then
        frame.Visible = not frame.Visible
    end
end)

print("✅ AUTO SWING SERVER VALID LOADED")
