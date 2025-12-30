-- patrickkprojeck

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ================= GUI =================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "patrickkprojeck"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,300)
frame.Position = UDim2.new(0,30,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Visible = true
frame.Active = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.Text = "patrickkprojeck"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

-- ================= BUTTON =================
local function makeButton(text, y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-20,0,40)
    b.Position = UDim2.new(0,10,0,y)
    b.Text = text
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 16
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    return b
end

local espBtn  = makeButton("ESP : OFF", 50)
local boneBtn = makeButton("BONE : ON", 100)
local lineBtn = makeButton("LINE : ON", 150)
local textBtn = makeButton("TEXT : ON", 200)
local flyBtn  = makeButton("FLY : OFF", 250)

-- ================= SETTINGS =================
local ESP  = false
local BONE = true
local LINE = true
local TEXT = true
local FLY  = false

local drawings = {}

-- ================= ESP =================
local function clearESP(plr)
    if drawings[plr] then
        for _,d in pairs(drawings[plr]) do
            d:Remove()
        end
        drawings[plr] = nil
    end
end

local function createESP(plr)
    if plr == LocalPlayer then return end

    drawings[plr] = {
        head = Drawing.new("Line"),
        body = Drawing.new("Line"),
        lArm = Drawing.new("Line"),
        rArm = Drawing.new("Line"),
        lLeg = Drawing.new("Line"),
        rLeg = Drawing.new("Line"),
        line = Drawing.new("Line"),
        text = Drawing.new("Text")
    }

    for _,v in pairs(drawings[plr]) do
        if v.ClassName == "Line" then
            v.Thickness = 2
            v.Color = Color3.new(1,1,1)
        end
    end
end

local function w2s(part)
    local p, vis = Camera:WorldToViewportPoint(part.Position)
    return Vector2.new(p.X,p.Y), vis
end

RunService.RenderStepped:Connect(function()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if ESP then
                if not drawings[plr] then createESP(plr) end

                local char = plr.Character
                local hrp = char.HumanoidRootPart
                local head = char:FindFirstChild("Head")

                if head then
                    local headPos = w2s(head)
                    local bodyPos = w2s(hrp)

                    local sk = drawings[plr]

                    -- skeleton
                    sk.head.From = headPos
                    sk.head.To = bodyPos
                    sk.head.Visible = BONE

                    sk.body.From = bodyPos
                    sk.body.To = bodyPos + Vector2.new(0,40)
                    sk.body.Visible = BONE

                    local function bone(part, line)
                        if part then
                            line.From = bodyPos
                            line.To = w2s(part)
                            line.Visible = BONE
                        end
                    end

                    bone(char:FindFirstChild("LeftUpperArm"), sk.lArm)
                    bone(char:FindFirstChild("RightUpperArm"), sk.rArm)
                    bone(char:FindFirstChild("LeftUpperLeg"), sk.lLeg)
                    bone(char:FindFirstChild("RightUpperLeg"), sk.rLeg)

                    -- line
                    sk.line.Visible = LINE
                    sk.line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    sk.line.To = bodyPos

                    -- text
                    local dist = math.floor((hrp.Position - Camera.CFrame.Position).Magnitude)
                    sk.text.Visible = TEXT
                    sk.text.Text = plr.Name.." ["..dist.."m]"
                    sk.text.Position = headPos - Vector2.new(0,15)
                    sk.text.Size = 16
                    sk.text.Center = true
                    sk.text.Color = Color3.new(1,1,1)
                end
            else
                clearESP(plr)
            end
        end
    end
end)

-- ================= BUTTON ACTION =================
espBtn.MouseButton1Click:Connect(function()
    ESP = not ESP
    espBtn.Text = "ESP : "..(ESP and "ON" or "OFF")
end)

boneBtn.MouseButton1Click:Connect(function()
    BONE = not BONE
    boneBtn.Text = "BONE : "..(BONE and "ON" or "OFF")
end)

lineBtn.MouseButton1Click:Connect(function()
    LINE = not LINE
    lineBtn.Text = "LINE : "..(LINE and "ON" or "OFF")
end)

textBtn.MouseButton1Click:Connect(function()
    TEXT = not TEXT
    textBtn.Text = "TEXT : "..(TEXT and "ON" or "OFF")
end)

-- ================= FLY =================
local bv, bg
RunService.RenderStepped:Connect(function()
    if FLY and bv and bg then
        bg.CFrame = Camera.CFrame
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            bv.Velocity = Camera.CFrame.LookVector * 60
        else
            bv.Velocity = Vector3.zero
        end
    end
end)

flyBtn.MouseButton1Click:Connect(function()
    FLY = not FLY
    flyBtn.Text = "FLY : "..(FLY and "ON" or "OFF")

    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if FLY then
        bg = Instance.new("BodyGyro", hrp)
        bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
        bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    else
        if bg then bg:Destroy() end
        if bv then bv:Destroy() end
    end
end)

-- ================= OPEN / CLOSE (=) =================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Equals then
        frame.Visible = not frame.Visible
    end
end)

-- ================= DRAG =================
local drag, startPos, dragStart

frame.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true
        dragStart = i.Position
        startPos = frame.Position
    end
end)

frame.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = false
    end
end)

UserInputService.InputChanged:Connect(function(i)
    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
