--================================
-- patrickkkprojeck FULL FINAL (ESP FIX CAMERA)
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
-- VISIBILITY CHECK (FINAL FIX)
--================================
local function getScreenPos(worldPos)
    local camCF = Camera.CFrame
    local dir = worldPos - camCF.Position

    if dir.Magnitude < 1 then
        return false
    end

    -- 🔴 BENAR-BENAR DEPAN KAMERA
    if camCF.LookVector:Dot(dir.Unit) <= 0.25 then
        return false
    end

    local pos, onScreen = Camera:WorldToViewportPoint(worldPos)
    if not onScreen or pos.Z <= 0 then
        return false
    end

    if pos.X < 0 or pos.Y < 0
    or pos.X > Camera.ViewportSize.X
    or pos.Y > Camera.ViewportSize.Y then
        return false
    end

    return true, Vector2.new(pos.X, pos.Y)
end

--================================
-- CLEAN
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
-- CREATE
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
        l.Color = Color3.fromRGB(255,0,0)
        l.Thickness = 3
        table.insert(drawings[plr].bones,{l,bone})
    end
end

--================================
-- RENDER LOOP (FIXED)
--================================
RunService.RenderStepped:Connect(function()
    for _,plr in ipairs(Players:GetPlayers()) do

        -- ❌ BLOK LOCAL PLAYER TOTAL
        if plr == LP then
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
        local ok, pos = getScreenPos(hrp.Position)

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
        t.Size = 18
        t.Font = Drawing.Fonts.UI
        t.Outline = true
        t.Center = true
        t.Color = Color3.new(1,1,1)
        t.Position = pos + Vector2.new(0,-45)

        -- LINE (TRACER)
        local ln = drawings[plr].line
        ln.Visible = LINE_ON
        ln.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
        ln.To = pos
        ln.Color = Color3.new(1,1,1)
        ln.Thickness = 1

        -- BONES
        for _,b in pairs(drawings[plr].bones) do
            local line,parts = b[1], b[2]
            local p1 = plr.Character:FindFirstChild(parts[1])
            local p2 = plr.Character:FindFirstChild(parts[2])

            if BONES_ON and p1 and p2 then
                local ok1,v1 = getScreenPos(p1.Position)
                local ok2,v2 = getScreenPos(p2.Position)
                if ok1 and ok2 then
                    line.Visible = true
                    line.From = v1
                    line.To = v2
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
-- INF JUMP
--================================
UIS.JumpRequest:Connect(function()
    if INFJUMP_ON then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
