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
frame.Size = UDim2.new(0, 260, 0, 300)
frame.Position = UDim2.new(0, 30, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Visible = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.Text = "patrickkprojeck"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

-- ================= BUTTON CREATOR =================
local function makeButton(text, posY)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1,-20,0,40)
    btn.Position = UDim2.new(0,10,0,posY)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    return btn
end

local espBtn = makeButton("ESP : OFF", 50)
local boxBtn = makeButton("BOX : ON", 100)
local lineBtn = makeButton("LINE : ON", 150)
local textBtn = makeButton("TEXT : ON", 200)
local flyBtn = makeButton("FLY : OFF", 250)

-- ================= SETTINGS =================
local ESP = false
local BOX = true
local LINE = true
local TEXT = true
local FLY = false

local drawings = {}

-- ================= ESP FUNCTIONS =================
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
        box = Drawing.new("Square"),
        line = Drawing.new("Line"),
        text = Drawing.new("Text")
    }
end

RunService.RenderStepped:Connect(function()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if ESP then
                if not drawings[plr] then createESP(plr) end
                local hrp = plr.Character.HumanoidRootPart
                local pos, onscreen = Camera:WorldToViewportPoint(hrp.Position)

                if onscreen then
                    local dist = math.floor((hrp.Position - Camera.CFrame.Position).Magnitude)

                    -- BOX
                    local box = drawings[plr].box
                    box.Visible = BOX
                    box.Size = Vector2.new(60,100)
                    box.Position = Vector2.new(pos.X-30, pos.Y-50)
                    box.Color = Color3.new(1,1,1)
                    box.Thickness = 1

                    -- LINE
                    local line = drawings[plr].line
                    line.Visible = LINE
                    line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    line.To = Vector2.new(pos.X, pos.Y)
                    line.Color = Color3.new(1,1,1)
                    line.Thickness = 1

                    -- TEXT
                    local text = drawings[plr].text
                    text.Visible = TEXT
                    text.Text = plr.Name.." ["..dist.."m]"
                    text.Position = Vector2.new(pos.X, pos.Y-60)
                    text.Size = 16
                    text.Center = true
                    text.Color = Color3.new(1,1,1)
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

boxBtn.MouseButton1Click:Connect(function()
    BOX = not BOX
    boxBtn.Text = "BOX : "..(BOX and "ON" or "OFF")
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

-- ================= OPEN / CLOSE (+) =================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Equals then
        frame.Visible = not frame.Visible
    end
end)
