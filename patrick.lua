--================================
-- patrickkkprojeck FULL FINAL (ESP FIX TOTAL)
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
-- VISIBILITY CHECK (SUPER FIX)
--================================
local function validESP(worldPos)
    local cam = Camera
    local camCF = cam.CFrame
    local dir = worldPos - camCF.Position

    if dir.Magnitude < 2 then return false end

    -- belakang kamera
    if camCF.LookVector:Dot(dir.Unit) <= 0 then
        return false
    end

    local pos, onScreen = cam:WorldToViewportPoint(worldPos)
    if not onScreen then return false end

    if pos.X < 0 or pos.Y < 0
    or pos.X > cam.ViewportSize.X
    or pos.Y > cam.ViewportSize.Y then
        return false
    end

    return true, pos
end

--================================
-- CLEAN PLAYER ESP
--================================
local function clear(plr)
    if drawings[plr] then
        for _,obj in pairs(drawings[plr]) do
            if typeof(obj) == "table" then
                for _,x in pairs(obj) do
                    pcall(function() x:Remove() end)
                end
            else
                pcall(function() obj:Remove() end)
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
        l.Thickness = 4
        l.Color = Color3.fromRGB(255,0,0)
        table.insert(drawings[plr].bones,{l,bone})
    end
end

--================================
-- RENDER LOOP (FIXED TOTAL)
--================================
RunService.RenderStepped:Connect(function()
    for _,plr in ipairs(Players:GetPlayers()) do

        -- 🔴 HARD BLOCK LOCALPLAYER
        if plr == LP or plr.Character == LP.Character then
            clear(plr)
            continue
        end

        if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
            clear(plr)
            continue
        end

        if not ESP_ON then
            clear(plr)
            continue
        end

        if not drawings[plr] then
            create(plr)
        end

        local hrp = plr.Character.HumanoidRootPart
        local ok, pos = validESP(hrp.Position)

        -- ❌ TIDAK TERLIHAT → SEMUA HILANG
        if not ok then
            drawings[plr].text.Visible = false
            drawings[plr].line.Visible = false
            for _,b in pairs(drawings[plr].bones) do
                b[1].Visible = false
            end
            continue
        end

        -- TEXT
        local t = drawings[plr].text
        t.Visible = TEXT_ON
        t.Text = plr.Name
        t.Size = 17
        t.Font = Drawing.Fonts.UI
        t.Center = true
        t.Outline = true
        t.Color = Color3.new(1,1,1)
        t.Position = Vector2.new(pos.X, pos.Y - 45)

        -- LINE (TRACER FIX)
        local ln = drawings[plr].line
        ln.Visible = LINE_ON
        ln.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y - 10)
        ln.To = Vector2.new(pos.X, pos.Y)
        ln.Color = Color3.new(1,1,1)
        ln.Thickness = 1

        -- BONES
        for _,b in pairs(drawings[plr].bones) do
            local line,parts = b[1], b[2]
            local p1 = plr.Character:FindFirstChild(parts[1])
            local p2 = plr.Character:FindFirstChild(parts[2])

            if BONES_ON and p1 and p2 then
                local ok1,v1 = validESP(p1.Position)
                local ok2,v2 = validESP(p2.Position)
                if ok1 and ok2 then
                    line.Visible = true
                    line.From = Vector2.new(v1.X,v1.Y)
                    line.To = Vector2.new(v2.X,v2.Y)
                else
                    line.Visible = false
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
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
