-- ══════════════════════════════════════════════════════
--  🏚️  UNDERGROUND FLOATING WIDGET (Max 200 + Keybind)
-- ══════════════════════════════════════════════════════
task.spawn(function()
    local Players = game:GetService("Players")
    local UIS     = game:GetService("UserInputService")
    local TweenS  = game:GetService("TweenService")
    
    local player = Players.LocalPlayer
    local r = player:WaitForChild("PlayerGui")

    local W = false
    local V = false
    local Y = 10        -- ระยะเริ่มต้น
    local baseTargetY = nil
    local currentKey = Enum.KeyCode.E -- ค่าเริ่มต้นปุ่มคีย์บอร์ด (เปลี่ยนได้)
    local waitingForKey = false

    local function getRootPart()
        local char = player.Character
        if char then
            return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
        end
        return nil
    end

    player.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        W = false
        V = false
        baseTargetY = nil
    end)

    -- สร้าง ScreenGui
    local sg = Instance.new("ScreenGui")
    sg.Name              = "UGWidget"
    sg.ResetOnSpawn    = false
    sg.IgnoreGuiInset  = true
    sg.DisplayOrder    = 999
    sg.Parent          = r

    -- กรอบหลัก (ขยายความสูงรองรับปุ่มเพิ่ม)
    local frame = Instance.new("Frame")
    frame.Size              = UDim2.new(0, 220, 0, 245)
    frame.Position          = UDim2.new(0, 12, 0.5, -100)
    frame.BackgroundColor3  = Color3.fromRGB(18, 18, 24)
    frame.BorderSizePixel   = 0
    frame.Active            = true
    frame.Parent            = sg
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
    local _fs = Instance.new("UIStroke", frame)
    _fs.Thickness = 1.2
    _fs.Color     = Color3.fromRGB(255, 100, 0)
    _fs.Transparency = 0.5

    -- Header
    local header = Instance.new("Frame")
    header.Size             = UDim2.new(1, 0, 0, 34)
    header.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
    header.BorderSizePixel  = 0
    header.Parent           = frame
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)

    local htitle = Instance.new("TextLabel")
    htitle.Size                 = UDim2.new(1, -10, 1, 0)
    htitle.Position             = UDim2.new(0, 10, 0, 0)
    htitle.BackgroundTransparency = 1
    htitle.Text                 = "⛏  Underground"
    htitle.Font                 = Enum.Font.GothamBold
    htitle.TextSize             = 13
    htitle.TextColor3           = Color3.fromRGB(240, 240, 240)
    htitle.TextXAlignment       = Enum.TextXAlignment.Left
    htitle.Parent               = header

    -- Drag System
    local dragging, dragStart, startPos = false, nil, nil
    header.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = i.Position
            startPos  = frame.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local _snapMode = "down"

    -- ปุ่มโหมด ⬇ มุดดิน / ⬆ ขึ้นบน
    local btnDown = Instance.new("TextButton")
    btnDown.Size              = UDim2.new(0.5, -10, 0, 36)
    btnDown.Position          = UDim2.new(0, 8, 0, 42)
    btnDown.BackgroundColor3  = Color3.fromRGB(255, 100, 0)
    btnDown.BorderSizePixel   = 0
    btnDown.Text              = "⬇ มุดดิน"
    btnDown.Font              = Enum.Font.GothamBold
    btnDown.TextSize          = 12
    btnDown.TextColor3        = Color3.fromRGB(255, 255, 255)
    btnDown.AutoButtonColor   = false
    btnDown.Parent            = frame
    Instance.new("UICorner", btnDown).CornerRadius = UDim.new(0, 10)

    local btnUp = Instance.new("TextButton")
    btnUp.Size              = UDim2.new(0.5, -10, 0, 36)
    btnUp.Position          = UDim2.new(0.5, 2, 0, 42)
    btnUp.BackgroundColor3  = Color3.fromRGB(38, 38, 50)
    btnUp.BorderSizePixel   = 0
    btnUp.Text              = "⬆ ขึ้นบน"
    btnUp.Font              = Enum.Font.GothamBold
    btnUp.TextSize          = 12
    btnUp.TextColor3        = Color3.fromRGB(140, 160, 200)
    btnUp.AutoButtonColor   = false
    btnUp.Parent            = frame
    Instance.new("UICorner", btnUp).CornerRadius = UDim.new(0, 10)

    local function updateModeUI()
        local ti = TweenInfo.new(0.12)
        if _snapMode == "down" then
            TweenS:Create(btnDown, ti, {BackgroundColor3 = Color3.fromRGB(255, 100, 0)}):Play()
            btnDown.TextColor3 = Color3.fromRGB(255, 255, 255)
            TweenS:Create(btnUp, ti, {BackgroundColor3 = Color3.fromRGB(38, 38, 50)}):Play()
            btnUp.TextColor3 = Color3.fromRGB(140, 160, 200)
        else
            TweenS:Create(btnUp, ti, {BackgroundColor3 = Color3.fromRGB(70, 140, 255)}):Play()
            btnUp.TextColor3 = Color3.fromRGB(255, 255, 255)
            TweenS:Create(btnDown, ti, {BackgroundColor3 = Color3.fromRGB(38, 38, 50)}):Play()
            btnDown.TextColor3 = Color3.fromRGB(200, 140, 100)
        end
    end

    btnDown.MouseButton1Click:Connect(function()
        _snapMode = "down"
        updateModeUI()
    end)

    btnUp.MouseButton1Click:Connect(function()
        _snapMode = "up"
        updateModeUI()
    end)

    -- ฟังก์ชันเปิด/ปิดการทำงานหลัก
    local function toggleAction()
        W = not W
        V = W
        local root = getRootPart()
        if W then
            if root then
                baseTargetY = root.Position.Y
            end
        else
            V = false
            baseTargetY = nil
        end
        -- อัปเดตปุ่มเปิด/ปิดใน UI
        local ti = TweenInfo.new(0.15)
        local btnMain = frame:FindFirstChild("MainToggleBtn")
        if btnMain then
            if V then
                TweenS:Create(btnMain, ti, {BackgroundColor3 = Color3.fromRGB(255, 100, 0)}):Play()
                btnMain.TextColor3 = Color3.fromRGB(255, 255, 255)
                btnMain.Text       = _snapMode == "down" and "⏻  สถานะ: ทำงาน (มุด)" or "⏻  สถานะ: ทำงาน (ลอย)"
            else
                TweenS:Create(btnMain, ti, {BackgroundColor3 = Color3.fromRGB(38, 38, 50)}):Play()
                btnMain.TextColor3 = Color3.fromRGB(180, 180, 200)
                btnMain.Text       = "⏻  เปิด / ปิด (กด " .. currentKey.Name .. ")"
            end
        end
    end

    -- ปุ่มใหญ่ เปิด/ปิด + ปุ่มตั้งค่าคีย์บอร์ด
    local btn = Instance.new("TextButton")
    btn.Name                = "MainToggleBtn"
    btn.Size              = UDim2.new(1, -56, 0, 36)
    btn.Position          = UDim2.new(0, 8, 0, 84)
    btn.BackgroundColor3  = Color3.fromRGB(38, 38, 50)
    btn.BorderSizePixel   = 0
    btn.Text              = "⏻  เปิด / ปิด (กด E)"
    btn.Font              = Enum.Font.GothamBold
    btn.TextSize          = 12
    btn.TextColor3        = Color3.fromRGB(180, 180, 200)
    btn.AutoButtonColor   = false
    btn.Parent            = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    btn.MouseButton1Click:Connect(toggleAction)

    -- ปุ่มตั้งค่าคีย์บอร์ด (⌨️)
    local keyBtn = Instance.new("TextButton")
    keyBtn.Size             = UDim2.new(0, 36, 0, 36)
    keyBtn.Position         = UDim2.new(1, -44, 0, 84)
    keyBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 50)
    keyBtn.BorderSizePixel  = false and 0 or 0
    keyBtn.Text             = "⌨️"
    keyBtn.Font             = Enum.Font.GothamBold
    keyBtn.TextSize         = 14
    keyBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
    keyBtn.AutoButtonColor  = false
    keyBtn.Parent           = frame
    Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 10)

    keyBtn.MouseButton1Click:Connect(function()
        waitingForKey = true
        keyBtn.Text = "..."
    end)

    -- รับค่าปุ่มคีย์บอร์ดเมื่อกด
    UIS.InputBegan:Connect(function(input, gameProcessed)
        if waitingForKey then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = input.KeyCode
                waitingForKey = false
                keyBtn.Text = "⌨️"
                local btnMain = frame:FindFirstChild("MainToggleBtn")
                if btnMain and not V then
                    btnMain.Text = "⏻  เปิด / ปิด (กด " .. currentKey.Name .. ")"
                end
            end
            return
        end

        if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentKey then
            toggleAction()
        end
    end)

    -- Label depth
    local depthLbl = Instance.new("TextLabel")
    depthLbl.Size                 = UDim2.new(1, -16, 0, 16)
    depthLbl.Position             = UDim2.new(0, 8, 0, 128)
    depthLbl.BackgroundTransparency = 1
    depthLbl.Text                 = "ระยะ : " .. Y
    depthLbl.Font                 = Enum.Font.GothamMedium
    depthLbl.TextSize             = 12
    depthLbl.TextColor3           = Color3.fromRGB(200, 200, 200)
    depthLbl.TextXAlignment       = Enum.TextXAlignment.Left
    depthLbl.Parent               = frame

    -- Custom Slider (1 ถึง 200)
    local MIN_V, MAX_V = 1, 200

    local track = Instance.new("Frame")
    track.Size             = UDim2.new(1, -16, 0, 22)
    track.Position         = UDim2.new(0, 8, 0, 148)
    track.BackgroundColor3 = Color3.fromRGB(40, 40, 54)
    track.BorderSizePixel  = 0
    track.Active           = true
    track.Parent           = frame
    Instance.new("UICorner", track).CornerRadius = UDim.new(0, 11)

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    fill.BorderSizePixel  = 0
    fill.Size             = UDim2.new((Y - MIN_V)/(MAX_V - MIN_V), 0, 1, 0)
    fill.Parent           = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 11)

    local knob = Instance.new("Frame")
    knob.Size             = UDim2.new(0, 22, 0, 22)
    knob.AnchorPoint      = Vector2.new(0.5, 0.5)
    knob.Position         = UDim2.new((Y - MIN_V)/(MAX_V - MIN_V), 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel  = 0
    knob.ZIndex           = 3
    knob.Parent           = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local valLbl = Instance.new("TextLabel")
    valLbl.Size                 = UDim2.new(1, 0, 1, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.Text                 = tostring(Y)
    valLbl.Font                 = Enum.Font.GothamBold
    valLbl.TextSize             = 10
    valLbl.TextColor3           = Color3.fromRGB(50, 50, 60)
    valLbl.ZIndex               = 4
    valLbl.Parent               = knob

    local sliding = false

    local function setSlider(val)
        val = math.clamp(math.round(val), MIN_V, MAX_V)
        Y   = val
        local pct = (val - MIN_V) / (MAX_V - MIN_V)
        fill.Size    = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, 0, 0.5, 0)
        valLbl.Text   = tostring(val)
        depthLbl.Text = "ระยะ : " .. val
    end

    local function onInput(i)
        if not sliding then return end
        local tx = track.AbsolutePosition.X
        local tw = track.AbsoluteSize.X
        local pct = math.clamp((i.Position.X - tx) / tw, 0, 1)
        setSlider(MIN_V + pct * (MAX_V - MIN_V))
    end

    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            sliding = true; onInput(i)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            onInput(i)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)

    -- ระบบล็อกความสูง (ถึง 200)
    task.spawn(function()
        while task.wait() do
            if V then
                local root = getRootPart()
                if root and baseTargetY then
                    local targetY = _snapMode == "down" and (baseTargetY - Y) or (baseTargetY + Y)
                    
                    root.CFrame = CFrame.new(root.Position.X, targetY, root.Position.Z) * (root.CFrame - root.CFrame.Position)
                    
                    if root:FindFirstChild("UG_Stabilizer") == nil then
                        local bv = Instance.new("BodyVelocity")
                        bv.Name = "UG_Stabilizer"
                        bv.MaxForce = Vector3.new(0, math.huge, 0)
                        bv.Velocity = Vector3.new(0, 0, 0)
                        bv.Parent = root
                    end
                end
            else
                local root = getRootPart()
                if root then
                    local bv = root:FindFirstChild("UG_Stabilizer")
                    if bv then bv:Destroy() end
                end
            end
        end
    end)
end)
