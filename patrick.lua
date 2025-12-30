--==================================================
-- SERVICES
--==================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer

--==================================================
-- STATE
--==================================================
local ESP = {
    Enabled = false,
    Text = false,
    Line = false,
    Bones = false,
    InfJump = false
}

--==================================================
-- GUI
--==================================================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,230,0,320)
main.Position = UDim2.new(0,20,0.3,0)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "ESP MENU"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(12,12,12)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

local function Toggle(text, y, callback)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(1,-20,0,36)
    b.Position = UDim2.new(0,10,0,y)
    b.BackgroundColor3 = Color3.fromRGB(35,35,35)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 13
    b.Text = text..": OFF"

    b.MouseButton1Click:Connect(function()
        local state = callback()
        b.Text = text..": "..(state and "ON" or "OFF")
    end)
end

Toggle("ESP",50,function()
    ESP.Enabled = not ESP.Enabled
    return ESP.Enabled
end)

Toggle("NAME + DIST",90,function()
    ESP.Text = not ESP.Text
    return ESP.Text
end)

Toggle("LINE",130,function()
    ESP.Line = not ESP.Line
    return ESP.Line
end)

Toggle("BONES",170,function()
    ESP.Bones = not ESP.Bones
    return ESP.Bones
end)

Toggle("INF JUMP",210,function()
    ESP.InfJump = not ESP.InfJump
    return ESP.InfJump
end)

UIS.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.Equals then
        main.Visible = not main.Visible
    end
end)

--==================================================
-- INFINITE JUMP
--==================================================
UIS.JumpRequest:Connect(function()
    if ESP.InfJump then
        local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h then
            h:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

--==================================================
-- ESP CORE
--==================================================
local drawings = {}

local function getRoot(char)
    return char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("Torso")
end

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
        if plr == LP then continue end

        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and getRoot(char)

        if not ESP.Enabled or not char or not hum or hum.Health <= 0 or not root then
            clear(plr)
            continue
        end

        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        if not onScreen then
            clear(plr)
            continue
        end

        drawings[plr] = drawings[plr] or {}

        -- TEXT
        if ESP.Text then
            local t = drawings[plr].Text or Drawing.new("Text")
            t.Center = true
            t.Outline = true
            t.Size = 14
            t.Color = Color3.new(1,1,1)
            t.Text = plr.Name.." ["..math.floor((Camera.CFrame.Position-root.Position).Magnitude).."]"
            t.Position = Vector2.new(pos.X,pos.Y-35)
            t.Visible = true
            drawings[plr].Text = t
        end

        -- LINE
        if ESP.Line then
            local l = drawings[plr].Line or Drawing.new("Line")
            l.From = Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y)
            l.To = Vector2.new(pos.X,pos.Y)
            l.Color = Color3.new(1,1,1)
            l.Thickness = 1
            l.Visible = true
            drawings[plr].Line = l
        end

        -- SIMPLE BONES (HEAD → ROOT)
        if ESP.Bones then
            local head = char:FindFirstChild("Head")
            if head then
                local hpos, hon = Camera:WorldToViewportPoint(head.Position)
                if hon then
                    local b = drawings[plr].Bone or Drawing.new("Line")
                    b.From = Vector2.new(hpos.X,hpos.Y)
                    b.To = Vector2.new(pos.X,pos.Y)
                    b.Color = Color3.fromRGB(0,255,0)
                    b.Thickness = 1
                    b.Visible = true
                    drawings[plr].Bone = b
                end
            end
        end
    end
end)
