-- patrickkprojeck FINAL

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ================= GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "patrickkprojeck"
gui.Parent = game.CoreGui

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

local espBtn   = makeButton("ESP : OFF", 50)
local skelBtn  = makeButton("SKELETON : ON", 100)
local lineBtn  = makeButton("TRACER : ON", 150)
local textBtn  = makeButton("TEXT : ON", 200)
local jumpBtn  = makeButton("INF JUMP : OFF", 250)

-- ================= SETTINGS =================
local ESP = false
local SKELETON = true
local TRACER = true
local TEXT = true
local INFJUMP = false

local drawings = {}

-- ================= CLEAN =================
local function clearESP(plr)
    if drawings[plr] then
        for _,v in pairs(drawings[plr]) do
            if typeof(v) == "table" then
                for _,l in pairs(v) do l:Remove() end
            else
                v:Remove()
            end
        end
        drawings[plr] = nil
    end
end

Players.PlayerRemoving:Connect(clearESP)

-- ================= CREATE ESP =================
local function createESP(plr)
    drawings[plr] = {
        skeleton = {
            head = Drawing.new("Line"),
            body = Drawing.new("Line"),
            leg = Drawing.new("Line")
        },
        tracer = Drawing.new("Line"),
        text = Drawing.new("Text")
    }
end

-- ================= ESP LOOP =================
RunService.RenderStepped:Connect(function
