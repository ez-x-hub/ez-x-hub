-- ==========================================
-- COMBINED SCRIPT: AIMBOT & FULL ESP (MODERN UI + CUSTOM AIM KEY)
-- ==========================================
local players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")
local coreGui = game:GetService("CoreGui")
local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local localPlayer = players.LocalPlayer

local fovSize = 200
local aimKey = Enum.KeyCode.F
local toggleAimKey = Enum.KeyCode.E
local aimbotEnabled = false
local strongLock = false
local wallCheck = true
local aimPartName = "Head"
local ignoreList = {}

local currentLockedTargetPart = nil
local ESPEnabled = false
local changingKey = false -- สถานะกำลังรอรับปุ่มใหม่สำหรับ Aim Key

local function checkWall(targetPart, targetChar)
    if not targetPart then return false end
    local origin = camera.CFrame.Position
    local direction = targetPart.Position - origin
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local filter = {}
    if localPlayer.Character then table.insert(filter, localPlayer.Character) end
    if targetChar then table.insert(filter, targetChar) end
    raycastParams.FilterDescendantsInstances = filter
    raycastParams.IgnoreWater = true
    return workspace:Raycast(origin, direction, raycastParams) == nil
end

local HighlightsFolder = workspace:FindFirstChild("EZx_ESP_Folder") or Instance.new("Folder")
HighlightsFolder.Name = "EZx_ESP_Folder"
HighlightsFolder.Parent = workspace

local function UpdateESPForCharacter(character, nameStr, isNPC)
    if not character then return end
    local hum = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
    
    if hum and hum.Health > 0 and rootPart then
        local hlName = isNPC and ("NPC_" .. nameStr) or nameStr
        local hl = HighlightsFolder:FindFirstChild(hlName)
        if not hl then
            hl = Instance.new("Highlight")
            hl.Name = hlName
            hl.Adornee = character
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0
            hl.Parent = HighlightsFolder
        end
        
        local isTarget = (currentLockedTargetPart and currentLockedTargetPart.Parent == character)
        if isTarget then
            hl.FillColor = Color3.fromRGB(0, 255, 255)
            hl.OutlineColor = Color3.fromRGB(0, 255, 255)
        else
            hl.FillColor = Color3.fromRGB(240, 240, 245)
            hl.OutlineColor = Color3.fromRGB(180, 180, 190)
        end
        
        local billboard = character:FindFirstChild("EZx_InfoTag")
        if not billboard then
            billboard = Instance.new("BillboardGui")
            billboard.Name = "EZx_InfoTag"
            billboard.Size = UDim2.new(0, 200, 0, 65)
            billboard.StudsOffset = Vector3.new(0, 3.2, 0)
            billboard.AlwaysOnTop = true
            billboard.Adornee = character:FindFirstChild("Head") or rootPart
            
            local textLabel = Instance.new("TextLabel")
            textLabel.Name = "InfoText"
            textLabel.Size = UDim2.new(1, 0, 0, 35)
            textLabel.BackgroundTransparency = 1
            textLabel.Font = Enum.Font.Code
            textLabel.TextSize = 13
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.TextStrokeTransparency = 0.4
            textLabel.TextXAlignment = Enum.TextXAlignment.Center
            textLabel.TextYAlignment = Enum.TextYAlignment.Center
            textLabel.Parent = billboard
            
            local barBg = Instance.new("Frame")
            barBg.Name = "HealthBarBg"
            barBg.Size = UDim2.new(0, 120, 0, 6)
            barBg.Position = UDim2.new(0.5, -60, 0, 38)
            barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            barBg.BorderSizePixel = 1
            barBg.BorderColor3 = Color3.fromRGB(15, 15, 20)
            barBg.Parent = billboard
            
            local bgCorner = Instance.new("UICorner")
            bgCorner.CornerRadius = UDim.new(1, 0)
            bgCorner.Parent = barBg
            
            local barFill = Instance.new("Frame")
            barFill.Name = "HealthBarFill"
            barFill.Size = UDim2.new(1, 0, 1, 0)
            barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
            barFill.BorderSizePixel = 0
            barFill.Parent = barBg
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = barFill
            
            billboard.Parent = character
        end
        
        local textLabel = billboard:FindFirstChild("InfoText")
        local barBg = billboard:FindFirstChild("HealthBarBg")
        local barFill = barBg and barBg:FindFirstChild("HealthBarFill")
        
        if textLabel then
            local dist = math.floor((rootPart.Position - camera.CFrame.Position).Magnitude)
            local hp = math.floor(hum.Health)
            local maxHp = math.floor(hum.MaxHealth)
            textLabel.Text = string.format("%s\n[%dm] HP: %d/%d", nameStr, dist, hp, maxHp)
            textLabel.TextColor3 = isTarget and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 255, 255)
        end
        
        if barFill then
            local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            barFill.Size = UDim2.new(healthPercent, 0, 1, 0)
        end
    else
        local hlName = isNPC and ("NPC_" .. nameStr) or nameStr
        if HighlightsFolder:FindFirstChild(hlName) then HighlightsFolder[hlName]:Destroy() end
        if character:FindFirstChild("EZx_InfoTag") then character.EZx_InfoTag:Destroy() end
    end
end

-- ลบ UI เก่าป้องกันซ้ำ
if coreGui:FindFirstChild("AimbotAndESPUI") then
    coreGui.AimbotAndESPUI:Destroy()
end

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "AimbotAndESPUI"
mainGui.ResetOnSpawn = false
pcall(function() mainGui.Parent = coreGui end)
if not mainGui.Parent then mainGui.Parent = localPlayer:WaitForChild("PlayerGui") end

local fovGuiCircle = Instance.new("Frame", mainGui)
fovGuiCircle.Name = "FOVCircle"
fovGuiCircle.BackgroundTransparency = 1
fovGuiCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovGuiCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovGuiCircle.Visible = false
Instance.new("UICorner", fovGuiCircle).CornerRadius = UDim.new(1, 0)
local fovUIStroke = Instance.new("UIStroke", fovGuiCircle)
fovUIStroke.Thickness = 2
fovUIStroke.Color = Color3.fromRGB(0, 255, 255)

-- หน้าต่าง UI หลักดีไซน์โมเดิร์น
local aimbotPanel = Instance.new("Frame", mainGui)
aimbotPanel.Size = UDim2.new(0, 280, 0, 310)
aimbotPanel.Position = UDim2.new(0.6, 0, 0.3, 0)
aimbotPanel.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
aimbotPanel.BorderSizePixel = 0
aimbotPanel.Active = true
Instance.new("UICorner", aimbotPanel).CornerRadius = UDim.new(0, 12)

-- แถบหัวข้อ UI
local topBar = Instance.new("Frame", aimbotPanel)
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
topBar.BorderSizePixel = 0
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12)

local topBarCover = Instance.new("Frame", topBar)
topBarCover.Size = UDim2.new(1, 0, 0.5, 0)
topBarCover.Position = UDim2.new(0, 0, 0.5, 0)
topBarCover.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
topBarCover.BorderSizePixel = 0

local panelTitle = Instance.new("TextLabel", topBar)
panelTitle.Size = UDim2.new(1, -16, 1, 0)
panelTitle.Position = UDim2.new(0, 12, 0, 0)
panelTitle.BackgroundTransparency = 1
panelTitle.Text = "⚡ AIMBOT & ESP HUB"
panelTitle.Font = Enum.Font.GothamBold
panelTitle.TextSize = 13
panelTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
panelTitle.TextXAlignment = Enum.TextXAlignment.Left

-- ระบบลากหน้าต่าง
local dragging, dragInput, dragStart, startPos
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = aimbotPanel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
userInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
runService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        aimbotPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ปุ่ม Aimbot
local btnAimbot = Instance.new("TextButton", aimbotPanel)
btnAimbot.Size = UDim2.new(0.5, -12, 0, 36)
btnAimbot.Position = UDim2.new(0, 8, 0, 45)
btnAimbot.Text = "AIMBOT: OFF"
btnAimbot.Font = Enum.Font.GothamBold
btnAimbot.TextSize = 12
btnAimbot.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAimbot.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
Instance.new("UICorner", btnAimbot).CornerRadius = UDim.new(0, 8)

-- ปุ่ม Strong Lock
local btnStrongLock = Instance.new("TextButton", aimbotPanel)
btnStrongLock.Size = UDim2.new(0.5, -12, 0, 36)
btnStrongLock.Position = UDim2.new(0.5, 4, 0, 45)
btnStrongLock.Text = "STRONG: OFF"
btnStrongLock.Font = Enum.Font.GothamBold
btnStrongLock.TextSize = 12
btnStrongLock.TextColor3 = Color3.fromRGB(255, 255, 255)
btnStrongLock.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
Instance.new("UICorner", btnStrongLock).CornerRadius = UDim.new(0, 8)

-- ปุ่ม Wallcheck
local btnWallCheck = Instance.new("TextButton", aimbotPanel)
btnWallCheck.Size = UDim2.new(0.5, -12, 0, 32)
btnWallCheck.Position = UDim2.new(0, 8, 0, 89)
btnWallCheck.Text = "WALLCHECK: ON"
btnWallCheck.Font = Enum.Font.Gotham
btnWallCheck.TextSize = 11
btnWallCheck.TextColor3 = Color3.fromRGB(255, 255, 255)
btnWallCheck.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
Instance.new("UICorner", btnWallCheck).CornerRadius = UDim.new(0, 8)

-- ปุ่มเปลี่ยนจุดเล็ง (Head / HRP)
local btnAimPart = Instance.new("TextButton", aimbotPanel)
btnAimPart.Size = UDim2.new(0.5, -12, 0, 32)
btnAimPart.Position = UDim2.new(0.5, 4, 0, 89)
btnAimPart.Text = "AIM PART: Head"
btnAimPart.Font = Enum.Font.Gotham
btnAimPart.TextSize = 11
btnAimPart.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAimPart.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
Instance.new("UICorner", btnAimPart).CornerRadius = UDim.new(0, 8)

-- ปุ่มตั้งค่าคีย์ลัด Aim Key (เพิ่มระบบเลือกปุ่มใหม่)
local btnSetKey = Instance.new("TextButton", aimbotPanel)
btnSetKey.Size = UDim2.new(1, -16, 0, 32)
btnSetKey.Position = UDim2.new(0, 8, 0, 129)
btnSetKey.Text = "AIM KEY: [ F ] (Click to Change)"
btnSetKey.Font = Enum.Font.GothamBold
btnSetKey.TextSize = 11
btnSetKey.TextColor3 = Color3.fromRGB(200, 200, 210)
btnSetKey.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Instance.new("UICorner", btnSetKey).CornerRadius = UDim.new(0, 8)

btnSetKey.MouseButton1Click:Connect(function()
    changingKey = true
    btnSetKey.Text = "PRESS ANY KEY..."
    btnSetKey.TextColor3 = Color3.fromRGB(0, 255, 255)
end)

-- ปุ่ม Full ESP
local btnEspToggle = Instance.new("TextButton", aimbotPanel)
btnEspToggle.Size = UDim2.new(1, -16, 0, 35)
btnEspToggle.Position = UDim2.new(0, 8, 0, 169)
btnEspToggle.Text = "FULL ESP: [OFF]"
btnEspToggle.Font = Enum.Font.GothamBold
btnEspToggle.TextSize = 12
btnEspToggle.TextColor3 = Color3.fromRGB(200, 200, 200)
btnEspToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Instance.new("UICorner", btnEspToggle).CornerRadius = UDim.new(0, 8)

btnEspToggle.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    btnEspToggle.Text = "FULL ESP: " .. (ESPEnabled and "[ON]" or "[OFF]")
    btnEspToggle.TextColor3 = ESPEnabled and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(200, 200, 200)
    btnEspToggle.BackgroundColor3 = ESPEnabled and Color3.fromRGB(50, 50, 65) or Color3.fromRGB(35, 35, 45)
    if not ESPEnabled then
        if workspace:FindFirstChild("EZx_ESP_Folder") then
            for _, child in ipairs(workspace.EZx_ESP_Folder:GetChildren()) do child:Destroy() end
        end
    end
end)

local lblAimed = Instance.new("TextLabel", aimbotPanel)
lblAimed.Size = UDim2.new(1, -16, 0, 16)
lblAimed.Position = UDim2.new(0, 8, 0, 212)
lblAimed.BackgroundTransparency = 1
lblAimed.Text = "Target: None"
lblAimed.Font = Enum.Font.Gotham
lblAimed.TextSize = 11
lblAimed.TextColor3 = Color3.fromRGB(160, 160, 170)
lblAimed.TextXAlignment = Enum.TextXAlignment.Left

-- สไลเดอร์ปรับ FOV
local sliderFrame = Instance.new("Frame", aimbotPanel)
sliderFrame.Size = UDim2.new(1, -16, 0, 28)
sliderFrame.Position = UDim2.new(0, 8, 0, 234)
sliderFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 8)

local sliderFill = Instance.new("Frame", sliderFrame)
sliderFill.Size = UDim2.new((fovSize - 50) / 550, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0, 8)

local sliderText = Instance.new("TextLabel", sliderFrame)
sliderText.Size = UDim2.new(1, 0, 1, 0)
sliderText.BackgroundTransparency = 1
sliderText.Text = "FOV Size: " .. tostring(fovSize)
sliderText.Font = Enum.Font.GothamBold
sliderText.TextSize = 11
sliderText.TextColor3 = Color3.fromRGB(255, 255, 255)

local draggingSlider = false
sliderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSlider = true end
end)
userInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSlider = false end
end)
userInputService.InputChanged:Connect(function(input)
    if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = userInputService:GetMouseLocation()
        local relX = math.clamp((mousePos.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
        fovSize = math.floor(50 + (relX * 550))
        sliderFill.Size = UDim2.new(relX, 0, 1, 0)
        sliderText.Text = "FOV Size: " .. tostring(fovSize)
    end
end)

local function getTarget()
    local vpSize = camera.ViewportSize
    local center = Vector2.new(vpSize.X / 2, vpSize.Y / 2)
    local shortestDist = math.huge
    local targetPlayer = nil

    for _, p in ipairs(players:GetPlayers()) do
        if p ~= localPlayer and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum.Health > 0 and not ignoreList[p] then
                if not (p.Team and localPlayer.Team and p.Team == localPlayer.Team) then
                    local targetPart = p.Character:FindFirstChild(aimPartName) or p.Character:FindFirstChild("Head")
                    if targetPart then
                        local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                            if dist < fovSize and dist < shortestDist then
                                if not wallCheck or checkWall(targetPart, p.Character) then
                                    shortestDist = dist
                                    targetPlayer = p
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return targetPlayer
end

local currentTarget = nil
runService:BindToRenderStep("Aimbot_Render", Enum.RenderPriority.Camera.Value + 1, function()
    if aimbotEnabled then
        fovGuiCircle.Size = UDim2.new(0, fovSize * 2, 0, fovSize * 2)
        fovUIStroke.Color = Color3.fromHSV((tick() * 1.5) % 1, 1, 1)
        fovGuiCircle.Visible = true
    else
        fovGuiCircle.Visible = false
    end
    
    if ESPEnabled then
        for _, player in ipairs(players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                UpdateESPForCharacter(player.Character, player.Name, false)
            end
        end
        for _, model in ipairs(workspace:GetChildren()) do
            if model:IsA("Model") and model ~= localPlayer.Character and not players:GetPlayerFromCharacter(model) then
                if model:FindFirstChildOfClass("Humanoid") then
                    UpdateESPForCharacter(model, model.Name, true)
                end
            end
        end
    end

    if not aimbotEnabled then
        currentLockedTargetPart = nil
        return
    end

    if not currentTarget or not currentTarget.Character or not currentTarget.Character:FindFirstChildOfClass("Humanoid") or currentTarget.Character.Humanoid.Health <= 0 then
        currentTarget = getTarget()
    end

    if currentTarget and currentTarget.Character then
        local targetPart = currentTarget.Character:FindFirstChild(aimPartName) or currentTarget.Character:FindFirstChild("Head")
        if targetPart then
            currentLockedTargetPart = targetPart
            if wallCheck and not checkWall(targetPart, currentTarget.Character) then
                currentTarget = nil
                currentLockedTargetPart = nil
                lblAimed.Text = "Target: None"
                return
            end
            local newCFrame = CFrame.new(camera.CFrame.Position, targetPart.Position)
            if strongLock then
                camera.CFrame = newCFrame
                lblAimed.Text = "Target: " .. currentTarget.Name
                return
            end
            camera.CFrame = camera.CFrame:Lerp(newCFrame, 0.16)
            lblAimed.Text = "Target: " .. currentTarget.Name
            return
        end
    end
    currentLockedTargetPart = nil
    lblAimed.Text = "Target: None"
end)

local function toggleAimbotState(state)
    aimbotEnabled = state
    btnAimbot.Text = "AIMBOT: " .. (state and "ON" or "OFF")
    btnAimbot.BackgroundColor3 = state and Color3.fromRGB(0, 150, 90) or Color3.fromRGB(45, 45, 55)
    if not state then
        currentTarget = nil
        currentLockedTargetPart = nil
        lblAimed.Text = "Target: None"
        fovGuiCircle.Visible = false
    else
        currentTarget = getTarget()
    end
end

btnAimbot.MouseButton1Click:Connect(function() toggleAimbotState(not aimbotEnabled) end)
btnStrongLock.MouseButton1Click:Connect(function()
    strongLock = not strongLock
    btnStrongLock.Text = "STRONG: " .. (strongLock and "ON" or "OFF")
    btnStrongLock.BackgroundColor3 = strongLock and Color3.fromRGB(0, 150, 90) or Color3.fromRGB(45, 45, 55)
end)
btnWallCheck.MouseButton1Click:Connect(function()
    wallCheck = not wallCheck
    btnWallCheck.Text = "WALLCHECK: " .. (wallCheck and "ON" or "OFF")
    btnWallCheck.BackgroundColor3 = wallCheck and Color3.fromRGB(0, 150, 90) or Color3.fromRGB(45, 45, 55)
end)
btnAimPart.MouseButton1Click:Connect(function()
    if aimPartName == "Head" then
        aimPartName = "HumanoidRootPart"
        btnAimPart.Text = "AIM PART: HRP"
    else
        aimPartName = "Head"
        btnAimPart.Text = "AIM PART: Head"
    end
end)

userInputService.InputBegan:Connect(function(input, gp)
    -- ระบบเปลี่ยนปุ่ม Aim Key ผ่านการกดแป้นพิมพ์
    if changingKey then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            aimKey = input.KeyCode
            changingKey = false
            btnSetKey.Text = "AIM KEY: [ " .. input.KeyCode.Name .. " ] (Click to Change)"
            btnSetKey.TextColor3 = Color3.fromRGB(200, 200, 210)
        end
        return
    end

    if gp then return end
    if input.KeyCode == aimKey then
        toggleAimbotState(not aimbotEnabled)
    end
end)
