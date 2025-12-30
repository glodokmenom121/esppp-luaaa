-- patrickkprojeck FINAL FIXED (LINE + BONES)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ================= GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "patrickkprojeck"
gui.ResetOnSpawn = false
pcall(function() gui.Parent = gethui() end)
if not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,260)
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

-- ================= INFINITE JUMP TOGGLE =================
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

_G.InfJump = false

-- fungsi lompat
UIS.JumpRequest:Connect(function()
    if _G.InfJump then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local function btn(text,y)
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

local espBtn   = btn("ESP : OFF",50)
local textBtn  = btn("TEXT : ON",100)
local lineBtn  = btn("LINE : OFF",150)
local boneBtn  = btn("BONES : OFF",200)

-- ================= SETTINGS =================
local ESP, TEXT, LINE, BONES = false, true, false, false
local drawings = {}

-- ================= CLEAN =================
local function clear(plr)
    if drawings[plr] then
        for _,d in pairs(drawings[plr]) do d:Remove() end
        drawings[plr] = nil
    end
end

Players.PlayerRemoving:Connect(clear)

-- ================= CREATE =================
local function create(plr)
    drawings[plr] = {
        text = Drawing.new("Text"),
        line = Drawing.new("Line"),
        bones = {}
    }

    drawings[plr].text.Center = true
    drawings[plr].text.Outline = true
    drawings[plr].text.Size = 14
end

-- ================= BONE MAKER =================
local function boneLine()
    local l = Drawing.new("Line")
    l.Thickness = 2
    l.Color = Color3.new(1,1,1)
    return l
end

-- ================= ESP LOOP =================
RunService.RenderStepped:Connect(function()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if not ESP then clear(plr) continue end
            if not drawings[plr] then create(plr) end

            local char = plr.Character
            local hrp = char.HumanoidRootPart
            local pos, onscreen = Camera:WorldToViewportPoint(hrp.Position)
            if not onscreen then continue end

            local dist = math.floor((hrp.Position - Camera.CFrame.Position).Magnitude)

            -- TEXT
            local txt = drawings[plr].text
            txt.Visible = TEXT
            txt.Text = plr.Name.." ["..dist.."m]"
            txt.Position = Vector2.new(pos.X, pos.Y - 50)
            txt.Color = Color3.new(1,1,1)

            -- LINE TRACER
            local ln = drawings[plr].line
            ln.Visible = LINE
            ln.Thickness = 2
            ln.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
            ln.To = Vector2.new(pos.X, pos.Y)
            ln.Color = Color3.new(1,1,1)

            -- BONES
            if BONES then
                local function draw(a,b)
                    local A,onA = Camera:WorldToViewportPoint(a.Position)
                    local B,onB = Camera:WorldToViewportPoint(b.Position)
                    if onA and onB then
                        local l = boneLine()
                        l.From = Vector2.new(A.X,A.Y)
                        l.To   = Vector2.new(B.X,B.Y)
                        table.insert(drawings[plr].bones,l)
                    end
                end

                for _,l in pairs(drawings[plr].bones) do l:Remove() end
                drawings[plr].bones = {}

                if char:FindFirstChild("Head") then
                    draw(char.Head, hrp)
                end
                if char:FindFirstChild("LeftHand") then
                    draw(char.LeftHand, hrp)
                end
                if char:FindFirstChild("RightHand") then
                    draw(char.RightHand, hrp)
                end
                if char:FindFirstChild("LeftFoot") then
                    draw(char.LeftFoot, hrp)
                end
                if char:FindFirstChild("RightFoot") then
                    draw(char.RightFoot, hrp)
                end
            else
                for _,l in pairs(drawings[plr].bones) do l:Remove() end
                drawings[plr].bones = {}
            end
        else
            clear(plr)
        end
    end
end)

-- ================= BUTTON =================
espBtn.MouseButton1Click:Connect(function()
    ESP = not ESP
    espBtn.Text = "ESP : "..(ESP and "ON" or "OFF")
end)

textBtn.MouseButton1Click:Connect(function()
    TEXT = not TEXT
    textBtn.Text = "TEXT : "..(TEXT and "ON" or "OFF")
end)

lineBtn.MouseButton1Click:Connect(function()
    LINE = not LINE
    lineBtn.Text = "LINE : "..(LINE and "ON" or "OFF")
end)

boneBtn.MouseButton1Click:Connect(function()
    BONES = not BONES
    boneBtn.Text = "BONES : "..(BONES and "ON" or "OFF")
end)

-- ================= OPEN / CLOSE (+) =================
UserInputService.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.Equals then
        frame.Visible = not frame.Visible
    end
end)

print("patrickkprojeck loaded | LINE + BONES OK")
