--================================
-- SERVICES
--================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--================================
-- STATES
--================================
ESP_ON = false
TEXT_ON = false
LINE_ON = false
BONES_ON = false
INFJUMP_ON = false

--================================
-- GUI
--================================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,230,0,300)
frame.Position = UDim2.new(0,20,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.Text = "ESP MENU"
title.BackgroundColor3 = Color3.fromRGB(15,15,15)
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

local function button(text, y, cb)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-20,0,35)
    b.Position = UDim2.new(0,10,0,y)
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextSize = 13

    b.MouseButton1Click:Connect(function()
        cb(b)
    end)
end

button("ESP : OFF",50,function(b)
    ESP_ON = not ESP_ON
    b.Text = "ESP : "..(ESP_ON and "ON" or "OFF")
end)

button("NAME + DIST : OFF",90,function(b)
    TEXT_ON = not TEXT_ON
    b.Text = "NAME + DIST : "..(TEXT_ON and "ON" or "OFF")
end)

button("LINE : OFF",130,function(b)
    LINE_ON = not LINE_ON
    b.Text = "LINE : "..(LINE_ON and "ON" or "OFF")
end)

button("BONES : OFF",170,function(b)
    BONES_ON = not BONES_ON
    b.Text = "BONES : "..(BONES_ON and "ON" or "OFF")
end)

button("INF JUMP : OFF",210,function(b)
    INFJUMP_ON = not INFJUMP_ON
    b.Text = "INF JUMP : "..(INFJUMP_ON and "ON" or "OFF")
end)

UIS.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.Equals then
        frame.Visible = not frame.Visible
    end
end)

--================================
-- INFINITE JUMP
--================================
UIS.JumpRequest:Connect(function()
    if INFJUMP_ON then
        local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h then
            h:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

--================================
-- DRAWING ESP
--================================
local drawings = {}

local function clear(plr)
    if drawings[plr] then
        for _,v in pairs(drawings[plr]) do
            v:Remove()
        end
        drawings[plr] = nil
    end
end

RunService.RenderStepped:Connect(function()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            local char = plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")

            if not ESP_ON or not hrp or not hum or hum.Health <= 0 then
                clear(plr)
                continue
            end

            local pos, onscreen = Camera:WorldToViewportPoint(hrp.Position)
            if not onscreen then
                clear(plr)
                continue
            end

            drawings[plr] = drawings[plr] or {}

            -- NAME + DIST
            if TEXT_ON then
                local t = drawings[plr].text or Drawing.new("Text")
                t.Text = plr.Name.." ["..math.floor((Camera.CFrame.Position-hrp.Position).Magnitude).."]"
                t.Size = 14
                t.Center = true
                t.Outline = true
                t.Color = Color3.new(1,1,1)
                t.Position = Vector2.new(pos.X,pos.Y-30)
                t.Visible = true
                drawings[plr].text = t
            end

            -- LINE
            if LINE_ON then
                local l = drawings[plr].line or Drawing.new("Line")
                l.From = Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y)
                l.To = Vector2.new(pos.X,pos.Y)
                l.Color = Color3.new(1,1,1)
                l.Thickness = 1
                l.Visible = true
                drawings[plr].line = l
            end
        end
    end
end)
