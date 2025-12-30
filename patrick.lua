--================================
-- SERVICES
--================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--================================
-- FLAGS
--================================
local ESP_ON = false
local TEXT_ON = false
local LINE_ON = false
local BONES_ON = false
local FLY_ON = false

--================================
-- ESP STORAGE (PENTING)
--================================
local ESPObjects = {}

local function ClearESP()
    for _,v in pairs(ESPObjects) do
        if v and v.Remove then
            v:Remove()
        end
    end
    table.clear(ESPObjects)
end

--================================
-- CREATE DRAWING
--================================
local function NewLine(thick)
    local l = Drawing.new("Line")
    l.Visible = false
    l.Thickness = thick or 2
    l.Color = Color3.new(1,1,1)
    table.insert(ESPObjects, l)
    return l
end

local function NewText()
    local t = Drawing.new("Text")
    t.Size = 14
    t.Center = true
    t.Outline = true
    t.Color = Color3.new(1,1,1)
    t.Visible = false
    table.insert(ESPObjects, t)
    return t
end

--================================
-- BONES CONNECTIONS
--================================
local BonePairs = {
    {"Head","UpperTorso"},
    {"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},
    {"LeftUpperArm","LeftLowerArm"},
    {"UpperTorso","RightUpperArm"},
    {"RightUpperArm","RightLowerArm"},
    {"LowerTorso","LeftUpperLeg"},
    {"LeftUpperLeg","LeftLowerLeg"},
    {"LowerTorso","RightUpperLeg"},
    {"RightUpperLeg","RightLowerLeg"},
}

--================================
-- ESP LOOP
--================================
RunService.RenderStepped:Connect(function()
    if not (ESP_ON or TEXT_ON or LINE_ON or BONES_ON) then return end

    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local char = plr.Character
            local hrp = char.HumanoidRootPart
            local head = char:FindFirstChild("Head")

            local hrpPos, onscreen = Camera:WorldToViewportPoint(hrp.Position)
            if not onscreen then continue end

            -- TEXT ESP
            if TEXT_ON and head then
                local txt = NewText()
                txt.Text = plr.Name
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0))
                txt.Position = Vector2.new(headPos.X, headPos.Y)
                txt.Visible = true
            end

            -- LINE / TRACER
            if LINE_ON then
                local ln = NewLine(2.5)
                ln.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                ln.To = Vector2.new(hrpPos.X, hrpPos.Y)
                ln.Visible = true
            end

            -- BONES ESP
            if BONES_ON then
                for _,pair in pairs(BonePairs) do
                    local p1 = char:FindFirstChild(pair[1])
                    local p2 = char:FindFirstChild(pair[2])
                    if p1 and p2 then
                        local a, on1 = Camera:WorldToViewportPoint(p1.Position)
                        local b, on2 = Camera:WorldToViewportPoint(p2.Position)
                        if on1 and on2 then
                            local bone = NewLine(2)
                            bone.From = Vector2.new(a.X,a.Y)
                            bone.To = Vector2.new(b.X,b.Y)
                            bone.Visible = true
                        end
                    end
                end
            end
        end
    end
end)

--================================
-- AUTO CLEAR SAAT OFF
--================================
RunService.RenderStepped:Connect(function()
    if not (ESP_ON or TEXT_ON or LINE_ON or BONES_ON) then
        ClearESP()
    end
end)

--================================
-- FLY (TAHAN SPASI MELAYANG)
--================================
local BodyVelocity
local flying = false

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Space and FLY_ON then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            flying = true
            BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.MaxForce = Vector3.new(0,math.huge,0)
            BodyVelocity.Velocity = Vector3.new(0,50,0)
            BodyVelocity.Parent = char.HumanoidRootPart
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then
        flying = false
        if BodyVelocity then
            BodyVelocity:Destroy()
            BodyVelocity = nil
        end
    end
end)

--================================
-- TOGGLE FUNCTIONS (PAKAI DI MENU KAMU)
--================================
_G.ToggleESP = function(v) ESP_ON = v if not v then ClearESP() end end
_G.ToggleText = function(v) TEXT_ON = v if not v then ClearESP() end end
_G.ToggleLine = function(v) LINE_ON = v if not v then ClearESP() end end
_G.ToggleBones = function(v) BONES_ON = v if not v then ClearESP() end end
_G.ToggleFly = function(v) FLY_ON = v end
--==============================
-- SIMPLE GUI
--==============================
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "patrickkkprojeck_GUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,260)
frame.Position = UDim2.new(0,20,0,120)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.Text = "patrickkkprojeck"
title.BackgroundColor3 = Color3.fromRGB(18,18,18)
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

--==============================
-- BUTTON MAKER
--==============================
local function makeButton(text, y, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1,-20,0,35)
    btn.Position = UDim2.new(0,10,0,y)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.MouseButton1Click:Connect(callback)
    return btn
end

--==============================
-- TOGGLES
--==============================
local esp=false
local text=false
local line=false
local bones=false
local fly=false

makeButton("ESP : OFF", 50, function(btn)
    esp = not esp
    btn.Text = "ESP : "..(esp and "ON" or "OFF")
    _G.ToggleESP(esp)
end)

makeButton("TEXT : OFF", 90, function(btn)
    text = not text
    btn.Text = "TEXT : "..(text and "ON" or "OFF")
    _G.ToggleText(text)
end)

makeButton("LINE : OFF", 130, function(btn)
    line = not line
    btn.Text = "LINE : "..(line and "ON" or "OFF")
    _G.ToggleLine(line)
end)

makeButton("BONES : OFF", 170, function(btn)
    bones = not bones
    btn.Text = "BONES : "..(bones and "ON" or "OFF")
    _G.ToggleBones(bones)
end)

makeButton("INF JUMP : OFF", 210, function(btn)
    fly = not fly
    btn.Text = "INF JUMP : "..(fly and "ON" or "OFF")
    _G.ToggleFly(fly)
end)
