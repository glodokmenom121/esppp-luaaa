--================================
-- patrickkkprojeck FULL FINAL (ESP FIX TOTAL + GUI FIX)
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
local ESP_ON = true
local TEXT_ON = true
local LINE_ON = true
local BONES_ON = false
local INFJUMP_ON = false

local drawings = {}

--================================
-- GUI (FIX AUTO SHOW)
--================================
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name = "patrickkkGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(200,180)
frame.Position = UDim2.fromOffset(30,200)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local function btn(txt,y,cb)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-10,0,30)
    b.Position = UDim2.fromOffset(5,y)
    b.Text = txt
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.MouseButton1Click:Connect(cb)
end

btn("ESP",10,function() ESP_ON = not ESP_ON end)
btn("TEXT",45,function() TEXT_ON = not TEXT_ON end)
btn("LINE",80,function() LINE_ON = not LINE_ON end)
btn("BONES",115,function() BONES_ON = not BONES_ON end)
btn("INF JUMP",150,function() INFJUMP_ON = not INFJUMP_ON end)

--================================
-- VISIBILITY CHECK (SUPER FIX)
--================================
local function validESP(worldPos)
    local camCF = Camera.CFrame
    local dir = worldPos - camCF.Position

    if dir.Magnitude < 2 then return false end
    if camCF.LookVector:Dot(dir.Unit) <= 0 then return false end

    local pos, onScreen = Camera:WorldToViewportPoint(worldPos)
    if not onScreen then return false end

    if pos.X < 0 or pos.Y < 0
    or pos.X > Camera.ViewportSize.X
    or pos.Y > Camera.ViewportSize.Y then
        return false
    end

    return true, pos
end

--================================
-- CLEAR ESP
--================================
local function clear(plr)
    if drawings[plr] then
        for _,o in pairs(drawings[plr]) do
            if typeof(o) == "table" then
                for _,x in pairs(o) do pcall(function() x:Remove() end) end
            else
                pcall(function() o:Remove() end)
            end
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

    for _,pair in pairs({
        {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
        {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},
        {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},
        {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},
        {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"}
    }) do
        local l = Drawing.new("Line")
        l.Thickness = 3
        l.Color = Color3.fromRGB(255,0,0)
        table.insert(drawings[plr].bones,{l,pair})
    end
end

--================================
-- RENDER LOOP (FINAL FIX)
--================================
RunService.RenderStepped:Connect(function()
    for _,plr in ipairs(Players:GetPlayers()) do

        -- 🚫 HARD BLOCK LOCALPLAYER
        if plr == LP then
            clear(plr)
            continue
        end

        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not ESP_ON or not hrp then
            clear(plr)
            continue
        end

        if not drawings[plr] then
            create(plr)
        end

        local ok, pos = validESP(hrp.Position)
        if not ok then
            drawings[plr].text.Visible = false
            drawings[plr].line.Visible = false
            for _,b in pairs(drawings[plr].bones) do b[1].Visible = false end
            continue
        end

        -- TEXT
        local t = drawings[plr].text
        t.Visible = TEXT_ON
        t.Text = plr.Name
        t.Size = 17
        t.Center = true
        t.Outline = true
        t.Color = Color3.new(1,1,1)
        t.Position = Vector2.new(pos.X, pos.Y - 40)

        -- LINE
        local ln = drawings[plr].line
        ln.Visible = LINE_ON
        ln.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
        ln.To = Vector2.new(pos.X,pos.Y)
        ln.Thickness = 1
        ln.Color = Color3.new(1,1,1)

        -- BONES
        for _,b in pairs(drawings[plr].bones) do
            local line,parts = b[1],b[2]
            local p1,p2 = char:FindFirstChild(parts[1]), char:FindFirstChild(parts[2])
            if BONES_ON and p1 and p2 then
                local o1,v1 = validESP(p1.Position)
                local o2,v2 = validESP(p2.Position)
                line.Visible = o1 and o2
                if line.Visible then
                    line.From = Vector2.new(v1.X,v1.Y)
                    line.To = Vector2.new(v2.X,v2.Y)
                end
            else
                line.Visible = false
            end
        end
    end
end)

--================================
-- INFINITE JUMP
--================================
UIS.JumpRequest:Connect(function()
    if INFJUMP_ON then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)
