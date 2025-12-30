-- patrickkprojeck FINAL STABLE (NO DRAWING)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ================= GUI SAFE =================
local gui = Instance.new("ScreenGui")
gui.Name = "patrickkprojeck"
gui.ResetOnSpawn = false

pcall(function()
    gui.Parent = gethui()
end)

if not gui.Parent then
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ================= FRAME =================
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,240)
frame.Position = UDim2.new(0,50,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "patrickkprojeck"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

local function makeButton(text, y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-20,0,40)
    b.Position = UDim2.new(0,10,0,y)
    b.Text = text
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 16
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(45,45,45)
    return b
end

local espBtn   = makeButton("ESP : OFF", 50)
local textBtn  = makeButton("TEXT : ON", 100)
local lineBtn  = makeButton("TRACER : OFF", 150)
local jumpBtn  = makeButton("INF JUMP : OFF", 200)

-- ================= SETTINGS =================
local ESP = false
local TEXT = true
local TRACER = false
local INFJUMP = false

local espFolder = Instance.new("Folder", workspace)
espFolder.Name = "patrickk_esp"

-- ================= CLEAN =================
local function clearESP(plr)
    if espFolder:FindFirstChild(plr.Name) then
        espFolder[plr.Name]:Destroy()
    end
end

Players.PlayerRemoving:Connect(clearESP)

-- ================= CREATE ESP =================
local function createESP(plr)
    clearESP(plr)

    local folder = Instance.new("Folder", espFolder)
    folder.Name = plr.Name

    local bill = Instance.new("BillboardGui", folder)
    bill.Name = "ESP"
    bill.Size = UDim2.new(0,200,0,50)
    bill.AlwaysOnTop = true

    local label = Instance.new("TextLabel", bill)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 14

    local tracer = Instance.new("Beam", folder)
    tracer.Enabled = false
    tracer.Width0 = 0.15
    tracer.Width1 = 0.15
    tracer.Color = ColorSequence.new(Color3.new(1,1,1))

    return bill, label, tracer
end

-- ================= ESP LOOP =================
RunService.RenderStepped:Connect(function()
    if not ESP then
        espFolder:ClearAllChildren()
        return
    end

    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart

            local folder = espFolder:FindFirstChild(plr.Name)
            local bill, label, tracer

            if not folder then
                bill, label, tracer = createESP(plr)
            else
                bill = folder:FindFirstChild("ESP")
                label = bill and bill:FindFirstChildOfClass("TextLabel")
                tracer = folder:FindFirstChildOfClass("Beam")
            end

            if bill and label then
                bill.Adornee = hrp
                bill.Enabled = TEXT

                local dist = math.floor((hrp.Position - workspace.CurrentCamera.CFrame.Position).Magnitude)
                label.Text = plr.Name.." ["..dist.."m]"
            end

            if tracer then
                tracer.Enabled = TRACER
            end
        end
    end
end)

-- ================= BUTTONS =================
espBtn.MouseButton1Click:Connect(function()
    ESP = not ESP
    espBtn.Text = "ESP : "..(ESP and "ON" or "OFF")
end)

textBtn.MouseButton1Click:Connect(function()
    TEXT = not TEXT
    textBtn.Text = "TEXT : "..(TEXT and "ON" or "OFF")
end)

lineBtn.MouseButton1Click:Connect(function()
    TRACER = not TRACER
    lineBtn.Text = "TRACER : "..(TRACER and "ON" or "OFF")
end)

jumpBtn.MouseButton1Click:Connect(function()
    INFJUMP = not INFJUMP
    jumpBtn.Text = "INF JUMP : "..(INFJUMP and "ON" or "OFF")
end)

-- ================= INFINITE JUMP =================
RunService.RenderStepped:Connect(function()
    if INFJUMP and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ================= OPEN / CLOSE (= / +) =================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Equals then
        frame.Visible = not frame.Visible
    end
end)

print("patrickkprojeck loaded successfully")
