-- patrickkprojeck (GUI TEST FIX)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ===== GUI SAFE PARENT =====
local gui = Instance.new("ScreenGui")
gui.Name = "patrickkprojeck"
gui.ResetOnSpawn = false

pcall(function()
    gui.Parent = gethui()
end)

if not gui.Parent then
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ===== FRAME =====
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 260, 0, 180)
frame.Position = UDim2.new(0, 50, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Visible = true
frame.Active = true
frame.Draggable = true

-- ===== TITLE =====
local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "patrickkprojeck"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

-- ===== INFO TEXT =====
local info = Instance.new("TextLabel")
info.Parent = frame
info.Position = UDim2.new(0,0,0,60)
info.Size = UDim2.new(1,0,0,40)
info.BackgroundTransparency = 1
info.Text = "MENU BERHASIL MUNCUL\nTekan '=' untuk hide/show"
info.TextColor3 = Color3.fromRGB(200,200,200)
info.Font = Enum.Font.SourceSans
info.TextSize = 14
info.TextWrapped = true

-- ===== OPEN / CLOSE WITH = =====
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Equals then
        frame.Visible = not frame.Visible
    end
end)

print("patrickkprojeck GUI loaded successfully")
