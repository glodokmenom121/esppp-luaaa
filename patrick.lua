--================================
-- patrickkkprojeck FULL FINAL
--================================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer

--================================
-- STATE
--================================
local ESP_ON = false
local TEXT_ON = false
local LINE_ON = false
local BONES_ON = false
local INFJUMP_ON = false

local drawings = {}

--================================
-- CLEAN PLAYER ESP
--================================
local function clear(plr)
    if drawings[plr] then
        for _,d in pairs(drawings[plr]) do
            pcall(function() d:Remove() end)
        end
        drawings[plr] = nil
    end
end

--================================
-- CREATE DRAWINGS
--================================
local function create(plr)
    drawings[plr] = {
        text = Drawing.new("Text"),
        line = Drawing.new("Line"),
        bones = {}
    }

    for _,bone in pairs({
        {"Head","UpperTorso"},
        {"UpperTorso","LowerTorso"},
        {"UpperTorso","LeftUpperArm"},
        {"LeftUpperArm","LeftLowerArm"},
        {"UpperTorso","RightUpperArm"},
        {"RightUpperArm","RightLowerArm"},
        {"LowerTorso","LeftUpperLeg"},
        {"LeftUpperLeg","LeftLowerLeg"},
        {"LowerTorso","RightUpperLeg"},
        {"RightUpperLeg","RightLowerLeg"}
    }) do
        local l = Drawing.new("Line")
        l.Thickness = 2
        table.insert(drawings[plr].bones,{l,bone})
    end
end

--================================
-- RENDER LOOP
--================================
RunService.RenderStepped:Connect(function()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if not ESP_ON then
                clear(plr)
                continue
            end

            if not drawings[plr] then
                create(plr)
            end

            local hrp = plr.Character.HumanoidRootPart
            local pos,vis = Camera:WorldToViewportPoint(hrp.Position)

if not vis then
    -- TEXT
    if drawings[plr].text then
        drawings[plr].text.Visible = false
    end

    -- LINE
    if drawings[plr].line then
        drawings[plr].line.Visible = false
    end

    -- BONES
    for _,b in pairs(drawings[plr].bones) do
        b[1].Visible = false
    end

    continue
end


            -- TEXT
            local t = drawings[plr].text
            t.Visible = TEXT_ON
            t.Text = plr.Name
            t.Size = 16
            t.Center = true
            t.Color = Color3.new(1,1,1)
            t.Position = Vector2.new(pos.X,pos.Y-50)

            -- LINE (TRACER)
            local ln = drawings[plr].line
            ln.Visible = LINE_ON
            ln.From = Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y)
            ln.To = Vector2.new(pos.X,pos.Y)
            ln.Color = Color3.new(1,1,1)
            ln.Thickness = 2

            -- BONES
            for _,b in pairs(drawings[plr].bones) do
                local line,parts = b[1], b[2]
                local p1 = plr.Character:FindFirstChild(parts[1])
                local p2 = plr.Character:FindFirstChild(parts[2])

                if BONES_ON and p1 and p2 then
                    local v1,on1 = Camera:WorldToViewportPoint(p1.Position)
                    local v2,on2 = Camera:WorldToViewportPoint(p2.Position)
                    if on1 and on2 then
                        line.Visible = true
                        line.From = Vector2.new(v1.X,v1.Y)
                        line.To = Vector2.new(v2.X,v2.Y)
                        line.Color = Color3.fromRGB(0,0,0)
                    else
                        line.Visible = false
                    end
                else
                    line.Visible = false
                end
            end
        else
            clear(plr)
        end
    end
end)

--================================
-- INFINITE JUMP (SPASI)
--================================
UIS.JumpRequest:Connect(function()
    if INFJUMP_ON then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

--================================
-- GUI
--================================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.Name = "patrickkkprojeck"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,260)
frame.Position = UDim2.new(0,20,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.Text = "patrickkkprojeck"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(15,15,15)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

local function btn(text,y,callback)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-20,0,35)
    b.Position = UDim2.new(0,10,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 13
    b.MouseButton1Click:Connect(function()
        callback(b)
    end)
end

btn("ESP : OFF",50,function(b)
    ESP_ON = not ESP_ON
    b.Text = "ESP : "..(ESP_ON and "ON" or "OFF")
    if not ESP_ON then
        for p,_ in pairs(drawings) do clear(p) end
    end
end)

btn("TEXT : OFF",90,function(b)
    TEXT_ON = not TEXT_ON
    b.Text = "TEXT : "..(TEXT_ON and "ON" or "OFF")
end)

btn("LINE : OFF",130,function(b)
    LINE_ON = not LINE_ON
    b.Text = "LINE : "..(LINE_ON and "ON" or "OFF")
end)

btn("BONES : OFF",170,function(b)
    BONES_ON = not BONES_ON
    b.Text = "BONES : "..(BONES_ON and "ON" or "OFF")
end)

btn("INF JUMP : OFF",210,function(b)
    INFJUMP_ON = not INFJUMP_ON
    b.Text = "INF JUMP : "..(INFJUMP_ON and "ON" or "OFF")
end)

--================================
-- TOGGLE GUI (+)
--================================
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.Equals then
        frame.Visible = not frame.Visible
    end
end)
