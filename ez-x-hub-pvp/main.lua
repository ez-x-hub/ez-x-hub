-- ==================== MODERN KEY SYSTEM & SCRIPT LOADER ====================
local CoreGui = game:GetService("CoreGui")

-- ตั้งค่าคีย์และลิงก์สคริปต์หลักที่นี่
local CORRECT_KEY = "23041655"
local SCRIPT_URL = "https://pastefy.app/ub8wLvTT/raw" -- เปลี่ยนเป็นลิงก์ Raw สคริปต์ของคุณ

local KeyScreenGui = Instance.new("ScreenGui")
KeyScreenGui.Name = "GM_KeySystem"
KeyScreenGui.Parent = CoreGui
KeyScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 360, 0, 210)
KeyFrame.Position = UDim2.new(0.5, -180, 0.5, -105)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = KeyScreenGui
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 16)

local KeyStroke = Instance.new("UIStroke")
KeyStroke.Color = Color3.fromRGB(255, 15, 123)
KeyStroke.Thickness = 2
KeyStroke.Parent = KeyFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 50)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Text = "EZ x HUB - Security"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.TextSize = 18
KeyTitle.Parent = KeyFrame

local KeySubTitle = Instance.new("TextLabel")
KeySubTitle.Size = UDim2.new(1, 0, 0, 20)
KeySubTitle.Position = UDim2.new(0, 0, 0, 45)
KeySubTitle.BackgroundTransparency = 1
KeySubTitle.Font = Enum.Font.Gotham
KeySubTitle.Text = "Please enter your access key to continue"
KeySubTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
KeySubTitle.TextSize = 12
KeySubTitle.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.85, 0, 0, 42)
KeyBox.Position = UDim2.new(0.075, 0, 0.42, 0)
KeyBox.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.PlaceholderText = "Enter Key here..."
KeyBox.Text = ""
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = KeyFrame
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 10)

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0.85, 0, 0, 42)
SubmitBtn.Position = UDim2.new(0.075, 0, 0.72, 0)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(255, 15, 123)
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.Text = "Verify Key"
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextSize = 14
SubmitBtn.Parent = KeyFrame
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 10)

local authorized = false
SubmitBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == CORRECT_KEY then
        authorized = true
        KeyScreenGui:Destroy()
        
        -- โหลดสคริปต์หลักต่อทันทีหลังจากผ่าน Key
        task.spawn(function()
            local success, err = pcall(function()
                loadstring(game:HttpGet(SCRIPT_URL))()
            end)
            if not success then
                warn("Failed to load main script: " .. tostring(err))
            end
        end)
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "Invalid Key! Try again"
    end
end)
