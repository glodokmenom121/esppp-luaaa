--================================
-- SIMPLE ESP MENU GUI
--================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

--================================
-- STATE (TINGGAL DIPAKAI DI ESP)
--================================
ESP_ON = false
TEXT_ON = false
LINE_ON = false
BONES_ON = false
INFJUMP_ON = false

--================================
-- GUI
--================================
local gui = Instance.new("ScreenGui")
gui.Name = "ESP_MENU_GUI"
gui.ResetOnSpawn = false
gui.Parent = LP:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,230,0,300)
frame.Position = UDim2.new(0,30,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
frame.Visible = true

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.Text = "ESP MENU"
title.BackgroundColor3 = Color3.fromRGB(15,15,15)
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

--================================
-- BUTTON CREATOR
--================================
local function createButton(text, y, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1,-20,0,35)
    btn.Position = UDim2.new(0,10,0,y)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Text = text
    btn.AutoButtonColor = false

    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
end

--================================
-- BUTTONS
--================================
createButton("ESP : OFF", 50, function(b)
    ESP_ON = not ESP_ON
    b.Text = "ESP : " .. (ESP_ON and "ON" or "OFF")
end)

createButton("NAME + DIST : OFF", 90, function(b)
    TEXT_ON = not TEXT_ON
    b.Text = "NAME + DIST : " .. (TEXT_ON and "ON" or "OFF")
end)

createButton("LINE : OFF", 130, function(b)
    LINE_ON = not LINE_ON
    b.Text = "LINE : " .. (LINE_ON and "ON" or "OFF")
end)

createButton("BONES : OFF", 170, function(b)
    BONES_ON = not BONES_ON
    b.Text = "BONES : " .. (BONES_ON and "ON" or "OFF")
end)

createButton("INF JUMP : OFF", 210, function(b)
    INFJUMP_ON = not INFJUMP_ON
    b.Text = "INF JUMP : " .. (INFJUMP_ON and "ON" or "OFF")
end)

-- INFO
local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1,0,0,30)
info.Position = UDim2.new(0,0,1,-30)
info.BackgroundTransparency = 1
info.Text = "[ + ] Hide / Show Menu"
info.TextColor3 = Color3.fromRGB(180,180,180)
info.Font = Enum.Font.Gotham
info.TextSize = 11

--================================
-- TOGGLE GUI WITH +
--================================
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Equals then -- tombol +
        frame.Visible = not frame.Visible
    end
end)

--================================
-- INFINITE JUMP (SPASI)
--================================
UIS.JumpRequest:Connect(function()
    if INFJUMP_ON then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
