-- this was deobfuscated by Luaxom at https://discord.gg/Sps39CydcZ

local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")
local localPlayer = players.LocalPlayer

local v1 = {
Common = Color3.fromRGB(200, 200, 200),
Uncommon = Color3.fromRGB(86, 176, 62),
Rare = Color3.fromRGB(0, 162, 255),
Epic = Color3.fromRGB(170, 85, 255),
Legendary = Color3.fromRGB(255, 170, 0),
Omega = Color3.fromRGB(255, 75, 75),
}

local v2 = {}

local function f1(p1)
for index, value in ipairs(p1:GetChildren()) do
        local handle = value:FindFirstChild("Handle")
        local meshId = nil

        if handle then
                local specialMesh = handle:FindFirstChildOfClass("SpecialMesh")

                if specialMesh then
                        meshId = specialMesh.MeshId
                    elseif handle:IsA("MeshPart") then
                            meshId = handle.MeshId
                        end
                    end

                    if meshId then
                            v2[meshId] = {
                            Name = value:GetAttribute("DisplayName") or value.Name,
                            Rarity = value:GetAttribute("RarityName") or "Common",
                            ImageId = value:GetAttribute("ImageId") or "rbxassetid://7072725737",
                            }
                        elseif value.Name == "Fists" then
                                v2.Fists = {
                                Name = value:GetAttribute("DisplayName") or "Fists",
                                Rarity = value:GetAttribute("RarityName") or "Common",
                                ImageId = value:GetAttribute("ImageId") or "rbxassetid://116170302967943",
                                }
                            else
                                local name = value.Name

                                v2[name] = {
                                Name = value:GetAttribute("DisplayName") or value.Name,
                                Rarity = value:GetAttribute("RarityName") or "Common",
                                ImageId = value:GetAttribute("ImageId") or "rbxassetid://7072725737",
                                }
                            end
                        end
                    end

                    for index2, value2 in ipairs({
                        "gun", "melee", "throwable", "consumable", "farming", "misc", "rod", "fish",
                        }) do
                            f1(replicatedStorage:WaitForChild("Items")[value2])
                        end

                        local function f2(p2)
                        local handle2 = p2:FindFirstChild("Handle")

                        if not handle2 then
                                return nil
                            else
                                local specialMesh2 = handle2:FindFirstChildOfClass("SpecialMesh")

                                if specialMesh2 then
                                        return specialMesh2.MeshId
                                    end

                                    if handle2:IsA("MeshPart") then
                                            return handle2.MeshId
                                        end

                                        return nil
                                    end
                                end

                                local f3

                                local function f4(p3)
                                local v3 = {
                                Common = 1,
                                Uncommon = 2,
                                Rare = 3,
                                Epic = 4,
                                Legendary = 5,
                                Omega = 6,
                                }

                                local rarity = "Common"

                                for index3, value3 in ipairs(p3) do
                                        local v4 = f3(value3)

                                        if v3[v4.Rarity] and v3[v4.Rarity] > v3[rarity] then
                                                rarity = v4.Rarity
                                            end
                                        end

                                        return rarity
                                    end

                                    function f3(p4)
                                        local v5 = f2(p4)

                                        if v5 and v2[v5] then
                                                return v2[v5]
                                            end

                                            if p4.Name == "Fists" and v2.Fists then
                                                    return v2.Fists
                                                end

                                                if v2[p4.Name] then
                                                        return v2[p4.Name]
                                                    end

                                                    return { Name = "หมัด", Rarity = "Common", ImageId = "rbxassetid://116170302967943" }
                                                end

                                                local playerGui = localPlayer:WaitForChild("PlayerGui")

                                                local inventoryViewerGUI = Instance.new("ScreenGui", playerGui)
                                                inventoryViewerGUI.Name = "InventoryViewerGUI"

                                                local instance = Instance.new("Frame", inventoryViewerGUI)
                                                instance.Size = UDim2.new(0, 180, 0.4, 0)
                                                instance.Position = UDim2.new(0, 10, 0.3, 0)
                                                instance.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                                                instance.BackgroundTransparency = 0.2

                                                Instance.new("UICorner", instance).CornerRadius = UDim.new(0, 8)

                                                local instance2 = Instance.new("ScrollingFrame", instance)
                                                instance2.Size = UDim2.new(1, -10, 1, -10) -- ปรับขนาดให้เต็มพื้นที่เพราะเอาปุ่ม Refresh ออกแล้ว
                                                instance2.Position = UDim2.new(0, 5, 0, 5)
                                                instance2.BackgroundTransparency = 1
                                                instance2.ScrollBarThickness = 6
                                                instance2.AutomaticCanvasSize = Enum.AutomaticSize.Y

                                                Instance.new("UIListLayout", instance2).Padding = UDim.new(0, 4)

                                                -- (นำปุ่ม Refresh ออกเรียบร้อย)

                                                local instance4 = Instance.new("TextButton", instance)
                                                instance4.Size = UDim2.new(0, 30, 0, 30)
                                                instance4.Position = UDim2.new(1, -40, 0, 0)
                                                instance4.Text = "<<"
                                                instance4.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                                                instance4.TextColor3 = Color3.new(1, 1, 1)
                                                instance4.Font = Enum.Font.GothamBold
                                                instance4.TextScaled = true

                                                Instance.new("UICorner", instance4).CornerRadius = UDim.new(0, 6)

                                                local instance5 = Instance.new("Frame", inventoryViewerGUI)
                                                instance5.Size = UDim2.new(0, 350, 0, 300)
                                                instance5.Position = UDim2.new(0, 200, 0.3, 0)
                                                instance5.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                                                instance5.BackgroundTransparency = 0.2
                                                instance5.Visible = false

                                                Instance.new("UICorner", instance5).CornerRadius = UDim.new(0, 8)

                                                local instance6 = Instance.new("TextLabel", instance5)
                                                instance6.Size = UDim2.new(1, -40, 0, 30)
                                                instance6.Position = UDim2.new(0, 5, 0, 0)
                                                instance6.BackgroundTransparency = 1
                                                instance6.TextColor3 = Color3.new(1, 1, 1)
                                                instance6.Font = Enum.Font.GothamBold
                                                instance6.TextScaled = true
                                                instance6.TextXAlignment = Enum.TextXAlignment.Left

                                                local instance7 = Instance.new("TextButton", instance5)
                                                instance7.Size = UDim2.new(0, 30, 0, 30)
                                                instance7.Position = UDim2.new(1, -35, 0, 0)
                                                instance7.Text = "X"
                                                instance7.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
                                                instance7.TextColor3 = Color3.new(1, 1, 1)
                                                instance7.Font = Enum.Font.GothamBold
                                                instance7.TextScaled = true

                                                Instance.new("UICorner", instance7).CornerRadius = UDim.new(0, 6)

                                                local instance8 = Instance.new("ScrollingFrame", instance5)
                                                instance8.Position = UDim2.new(0, 10, 0, 40)
                                                instance8.Size = UDim2.new(1, -20, 1, -50)
                                                instance8.BackgroundTransparency = 1
                                                instance8.ScrollBarThickness = 6
                                                instance8.AutomaticCanvasSize = Enum.AutomaticSize.Y

                                                Instance.new("UIListLayout", instance8).Padding = UDim.new(0, 5)
                                                instance7.MouseButton1Click:Connect(function() instance5.Visible = false end)

                                                local function f5(p5)
                                                instance6.Text = "Inventory: " .. p5.Name
                                                instance5.Visible = true

                                                for index4, value4 in ipairs(instance8:GetChildren()) do
                                                        if not value4:IsA("UIListLayout") then
                                                                value4:Destroy()
                                                            end
                                                        end

                                                        local v6 = {}

                                                        for index5, value5 in ipairs({ "Backpack", "StarterGear", "StarterPack" }) do
                                                                local findFirstChild = p5:FindFirstChild(value5)

                                                                if findFirstChild then
                                                                        for index6, value6 in ipairs(findFirstChild:GetChildren()) do
                                                                                if value6:IsA("Tool") then
                                                                                        table.insert(v6, value6)
                                                                                    end
                                                                                end
                                                                            end
                                                                        end

                                                                        if p5.Character then
                                                                                for index7, value7 in ipairs(p5.Character:GetChildren()) do
                                                                                        if value7:IsA("Tool") then
                                                                                                table.insert(v6, value7)
                                                                                            end
                                                                                        end
                                                                                    end

                                                                                    for index8, value8 in ipairs(v6) do
                                                                                            local v7 = f3(value8)

                                                                                            local instance9 = Instance.new("Frame", instance8)
                                                                                            instance9.Size = UDim2.new(1, -10, 0, 50)
                                                                                            instance9.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                                                                                            instance9.BorderSizePixel = 0

                                                                                            Instance.new("UICorner", instance9).CornerRadius = UDim.new(0, 6)

                                                                                            local instance10 = Instance.new("ImageLabel", instance9)
                                                                                            instance10.Size = UDim2.new(0, 40, 0, 40)
                                                                                            instance10.Position = UDim2.new(0, 5, 0, 5)
                                                                                            instance10.Image = v7.ImageId
                                                                                            instance10.BackgroundTransparency = 1

                                                                                            Instance.new("UICorner", instance10).CornerRadius = UDim.new(0, 6)

                                                                                            local textLabel = Instance.new("TextLabel")
                                                                                            textLabel.Size = UDim2.new(0, 100, 0, 25)
                                                                                            textLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                                                                                            textLabel.TextColor3 = v1[v7.Rarity] or Color3.new(1, 1, 1)
                                                                                            textLabel.Text = v7.Rarity
                                                                                            textLabel.Font = Enum.Font.GothamBold
                                                                                            textLabel.TextSize = 14
                                                                                            textLabel.TextWrapped = true
                                                                                            textLabel.Visible = false
                                                                                            textLabel.Parent = instance9
                                                                                            textLabel.AnchorPoint = Vector2.new(0.5, 1)

                                                                                            instance10.MouseEnter:Connect(function()
                                                                                            textLabel.Visible = true
                                                                                            local absolutePosition = instance10.AbsolutePosition

                                                                                            textLabel.Position = UDim2.new(
                                                                                            0, absolutePosition.X + instance10.AbsoluteSize.X / 2, 0, absolutePosition.Y - 30
                                                                                            )

                                                                                            textLabel.ZIndex = 10
                                                                                        end)

                                                                                        instance10.MouseLeave:Connect(function() textLabel.Visible = false end)

                                                                                        local instance11 = Instance.new("TextLabel", instance9)
                                                                                        instance11.Size = UDim2.new(1, -50, 1, 0)
                                                                                        instance11.Position = UDim2.new(0, 50, 0, 0)
                                                                                        instance11.TextColor3 = v1[v7.Rarity] or Color3.new(1, 1, 1)
                                                                                        instance11.Text = v7.Name
                                                                                        instance11.Font = Enum.Font.GothamBold
                                                                                        instance11.TextSize = 18
                                                                                        instance11.TextXAlignment = Enum.TextXAlignment.Left
                                                                                        instance11.BackgroundTransparency = 1
                                                                                    end
                                                                                end

                                                                                local v8 = {}
                                                                                local v9 = {}
                                                                                local v10 = false

                                                                                local function f6(p6)
                                                                                if not v10 then
                                                                                        return
                                                                                    elseif p6 == localPlayer then
                                                                                            return
                                                                                        else
                                                                                            local character = p6.Character

                                                                                            if not character then
                                                                                                    return
                                                                                                else
                                                                                                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

                                                                                                    if not humanoidRootPart then
                                                                                                            return
                                                                                                        else
                                                                                                            if v9[p6] then
                                                                                                                    v9[p6]:Destroy()
                                                                                                                end

                                                                                                                local billboardGui = Instance.new("BillboardGui")
                                                                                                                billboardGui.Adornee = humanoidRootPart
                                                                                                                billboardGui.Size = UDim2.new(0, 150, 0, 30)
                                                                                                                billboardGui.StudsOffset = Vector3.new(0, 3, 0)
                                                                                                                billboardGui.AlwaysOnTop = true
                                                                                                                billboardGui.Parent = character
                                                                                                                billboardGui:ClearAllChildren()

                                                                                                                local v11 = {}

                                                                                                                for index9, value9 in ipairs({ "Backpack", "StarterGear", "StarterPack" }) do
                                                                                                                        local findFirstChild2 = p6:FindFirstChild(value9)

                                                                                                                        if findFirstChild2 then
                                                                                                                                for index10, value10 in ipairs(findFirstChild2:GetChildren()) do
                                                                                                                                        if value10:IsA("Tool") then
                                                                                                                                                table.insert(v11, value10)
                                                                                                                                            end
                                                                                                                                        end
                                                                                                                                    end
                                                                                                                                end

                                                                                                                                if p6.Character then
                                                                                                                                        for index11, value11 in ipairs(p6.Character:GetChildren()) do
                                                                                                                                                if value11:IsA("Tool") then
                                                                                                                                                        table.insert(v11, value11)
                                                                                                                                                    end
                                                                                                                                                end
                                                                                                                                            end

                                                                                                                                            local instance12 = Instance.new("UIListLayout", billboardGui)
                                                                                                                                            instance12.FillDirection = Enum.FillDirection.Horizontal
                                                                                                                                            instance12.SortOrder = Enum.SortOrder.LayoutOrder
                                                                                                                                            instance12.Padding = UDim.new(0, 8)
                                                                                                                                            instance12.HorizontalAlignment = Enum.HorizontalAlignment.Center

                                                                                                                                            for index12, value12 in ipairs(v11) do
                                                                                                                                                    local v12 = f3(value12)

                                                                                                                                                    if v12.Rarity ~= "Common" then
                                                                                                                                                            local instance13 = Instance.new("ImageLabel", billboardGui)
                                                                                                                                                            instance13.Size = UDim2.new(0, 28, 0, 28)
                                                                                                                                                            instance13.BackgroundTransparency = 1
                                                                                                                                                            instance13.Image = v12.ImageId
                                                                                                                                                            instance13.LayoutOrder = index12

                                                                                                                                                            Instance.new("UICorner", instance13).CornerRadius = UDim.new(0, 15)

                                                                                                                                                            local instance14 = Instance.new("Frame", instance13)
                                                                                                                                                            instance14.Size = UDim2.new(1, 6, 1, 6)
                                                                                                                                                            instance14.Position = UDim2.new(0, -3, 0, -3)
                                                                                                                                                            instance14.ZIndex = instance13.ZIndex - 1
                                                                                                                                                            instance14.BackgroundColor3 = v1[v12.Rarity] or Color3.new(1, 1, 1)
                                                                                                                                                            instance14.AnchorPoint = Vector2.new(0, 0)
                                                                                                                                                            instance14.ClipsDescendants = true

                                                                                                                                                            Instance.new("UICorner", instance14).CornerRadius = UDim.new(0, 8.5)
                                                                                                                                                        end
                                                                                                                                                    end

                                                                                                                                                    v9[p6] = billboardGui
                                                                                                                                                    return
                                                                                                                                                end
                                                                                                                                            end
                                                                                                                                        end
                                                                                                                                    end

                                                                                                                                    local function f7(p7)
                                                                                                                                    if not v10 then
                                                                                                                                            return
                                                                                                                                        else
                                                                                                                                            local v13 = {}

                                                                                                                                            for index13, value13 in ipairs({ "Backpack", "StarterGear", "StarterPack" }) do
                                                                                                                                                    local findFirstChild3 = p7:FindFirstChild(value13)

                                                                                                                                                    if findFirstChild3 then
                                                                                                                                                            for index14, value14 in ipairs(findFirstChild3:GetChildren()) do
                                                                                                                                                                    if value14:IsA("Tool") then
                                                                                                                                                                            table.insert(v13, value14)
                                                                                                                                                                        end
                                                                                                                                                                    end
                                                                                                                                                                end
                                                                                                                                                            end

                                                                                                                                                            if p7.Character then
                                                                                                                                                                    for index15, value15 in ipairs(p7.Character:GetChildren()) do
                                                                                                                                                                            if value15:IsA("Tool") then
                                                                                                                                                                                    table.insert(v13, value15)
                                                                                                                                                                                end
                                                                                                                                                                            end
                                                                                                                                                                        end

                                                                                                                                                                        local instance15 = Instance.new("TextButton", instance2)
                                                                                                                                                                        instance15.Size = UDim2.new(1, -10, 0, 28)
                                                                                                                                                                        instance15.Text = p7.Name
                                                                                                                                                                        instance15.TextScaled = true
                                                                                                                                                                        instance15.Font = Enum.Font.GothamBold
                                                                                                                                                                        instance15.BackgroundColor3 = v1[f4(v13)] or Color3.fromRGB(40, 40, 40)
                                                                                                                                                                        instance15.TextColor3 = Color3.new(1, 1, 1)

                                                                                                                                                                        Instance.new("UICorner", instance15).CornerRadius = UDim.new(0, 6)
                                                                                                                                                                        instance15.MouseButton1Click:Connect(function() f5(p7) end)
                                                                                                                                                                        f6(p7)
                                                                                                                                                                        v8[p7] = instance15
                                                                                                                                                                        return
                                                                                                                                                                    end
                                                                                                                                                                end

                                                                                                                                                                local function f8()
                                                                                                                                                                if not v10 then
                                                                                                                                                                        return
                                                                                                                                                                    end

                                                                                                                                                                    for index16, value16 in ipairs(instance2:GetChildren()) do
                                                                                                                                                                            if value16:IsA("TextButton") and value16 ~= instance4 then
                                                                                                                                                                                    value16:Destroy()
                                                                                                                                                                                end
                                                                                                                                                                            end

                                                                                                                                                                            v8 = {}

                                                                                                                                                                            for index17, value17 in ipairs(players:GetPlayers()) do
                                                                                                                                                                                    if value17 ~= localPlayer then
                                                                                                                                                                                            f7(value17)
                                                                                                                                                                                        end
                                                                                                                                                                                    end
                                                                                                                                                                                end

                                                                                                                                                                                -- (ตัดการเชื่อมต่อปุ่ม Refresh ออก)

                                                                                                                                                                                players.PlayerAdded:Connect(function(player)
                                                                                                                                                                                if player ~= localPlayer and v10 then
                                                                                                                                                                                        f7(player)
                                                                                                                                                                                    end
                                                                                                                                                                                end)

                                                                                                                                                                                players.PlayerRemoving:Connect(function(player2)
                                                                                                                                                                                if v8[player2] then
                                                                                                                                                                                        v8[player2]:Destroy()
                                                                                                                                                                                        v8[player2] = nil
                                                                                                                                                                                    end

                                                                                                                                                                                    if v9[player2] then
                                                                                                                                                                                            v9[player2]:Destroy()
                                                                                                                                                                                            v9[player2] = nil
                                                                                                                                                                                        end
                                                                                                                                                                                    end)

                                                                                                                                                                                    instance4.MouseButton1Click:Connect(function()
                                                                                                                                                                                    v10 = not v10

                                                                                                                                                                                    if v10 then
                                                                                                                                                                                            instance4.Text = ">>"

                                                                                                                                                                                            instance.Size = UDim2.new(0, 180, 0.4, 0)
                                                                                                                                                                                            instance.Position = UDim2.new(0, 10, 0.3, 0)

                                                                                                                                                                                            instance2.Visible = true
                                                                                                                                                                                            f8()
                                                                                                                                                                                        else
                                                                                                                                                                                            instance4.Text = "<<"

                                                                                                                                                                                            instance.Size = UDim2.new(0, 40, 0.4, 0)
                                                                                                                                                                                            instance.Position = UDim2.new(0, 10, 0.3, 0)

                                                                                                                                                                                            instance2.Visible = false
                                                                                                                                                                                            instance5.Visible = false

                                                                                                                                                                                            for key, value18 in pairs(v8) do
                                                                                                                                                                                                    if value18 then
                                                                                                                                                                                                            value18:Destroy()
                                                                                                                                                                                                        end
                                                                                                                                                                                                    end

                                                                                                                                                                                                    v8 = {}
                                                                                                                                                                                                end
                                                                                                                                                                                            end)

                                                                                                                                                                                            local instance16 = Instance.new("Frame", inventoryViewerGUI)
                                                                                                                                                                                            instance16.AnchorPoint = Vector2.new(1, 1)
                                                                                                                                                                                            instance16.Position = UDim2.new(1, -10, 1, -10)
                                                                                                                                                                                            instance16.Size = UDim2.new(0, 300, 0, 0)
                                                                                                                                                                                            instance16.BackgroundTransparency = 1
                                                                                                                                                                                            instance16.ClipsDescendants = true

                                                                                                                                                                                            local instance17 = Instance.new("UIListLayout", instance16)
                                                                                                                                                                                            instance17.SortOrder = Enum.SortOrder.LayoutOrder
                                                                                                                                                                                            instance17.Padding = UDim.new(0, 5)

                                                                                                                                                                                            local function f9(p8, p9)
                                                                                                                                                                                            local color = v1[p9] or Color3.new(1, 1, 1)

                                                                                                                                                                                            local instance18 = Instance.new("Frame", instance16)
                                                                                                                                                                                            instance18.Size = UDim2.new(1, 0, 0, 40)
                                                                                                                                                                                            instance18.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                                                                                                                                                                            instance18.BorderSizePixel = 0
                                                                                                                                                                                            instance18.ClipsDescendants = true
                                                                                                                                                                                            instance18.LayoutOrder = tick()
                                                                                                                                                                                            instance18.AnchorPoint = Vector2.new(0.5, 0.5)
                                                                                                                                                                                            instance18.Position = UDim2.new(0.5, 0, 0.5, 0)
                                                                                                                                                                                            instance18.BackgroundTransparency = 1

                                                                                                                                                                                            Instance.new("UICorner", instance18).CornerRadius = UDim.new(0, 10)

                                                                                                                                                                                            local instance19 = Instance.new("UIGradient", instance18)

                                                                                                                                                                                            instance19.Color = ColorSequence.new({
                                                                                                                                                                                            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                                                                                                                                                                                            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 220, 255)),
                                                                                                                                                                                            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
                                                                                                                                                                                            })

                                                                                                                                                                                            instance19.Rotation = 90

                                                                                                                                                                                            local instance20 = Instance.new("TextLabel", instance18)
                                                                                                                                                                                            instance20.Size = UDim2.new(1, -10, 1, 0)
                                                                                                                                                                                            instance20.Position = UDim2.new(0, 5, 0, 0)
                                                                                                                                                                                            instance20.BackgroundTransparency = 1
                                                                                                                                                                                            instance20.Font = Enum.Font.GothamBold
                                                                                                                                                                                            instance20.TextSize = 15
                                                                                                                                                                                            instance20.TextColor3 = color
                                                                                                                                                                                            instance20.TextXAlignment = Enum.TextXAlignment.Left

                                                                                                                                                                                            instance20.Text = ("ชื่อผู้เล่น : %s   ระดับความแรร์ : %s"):format(
                                                                                                                                                                                            p8, p9
                                                                                                                                                                                            )

                                                                                                                                                                                            instance16.Size = UDim2.new(0, 300, 0, instance16.Size.Y.Offset + 45)

                                                                                                                                                                                            instance18.Size = UDim2.new(0, 0, 0, 0)
                                                                                                                                                                                            instance18.Position = UDim2.new(0.5, 0, 0.5, 0)

                                                                                                                                                                                            local create = tweenService:Create(instance18, TweenInfo.new(
                                                                                                                                                                                            0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out
                                                                                                                                                                                            ), {
                                                                                                                                                                                            Size = UDim2.new(1, 0, 0, 40),
                                                                                                                                                                                            BackgroundTransparency = 0,
                                                                                                                                                                                            })

                                                                                                                                                                                            local create2 = tweenService:Create(instance18, TweenInfo.new(
                                                                                                                                                                                            0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out
                                                                                                                                                                                            ), { Size = UDim2.new(1.05, 0, 0, 44) })

                                                                                                                                                                                            local play = create.Play

                                                                                                                                                                                            local create3 = tweenService:Create(instance18, TweenInfo.new(
                                                                                                                                                                                            0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In
                                                                                                                                                                                            ), { Size = UDim2.new(1, 0, 0, 40) })

                                                                                                                                                                                            play(create)

                                                                                                                                                                                            create.Completed:Connect(function()
                                                                                                                                                                                            create2:Play()

                                                                                                                                                                                            create2.Completed:Connect(function()
                                                                                                                                                                                            create3:Play()

                                                                                                                                                                                            create3.Completed:Connect(function()
                                                                                                                                                                                            wait(5)

                                                                                                                                                                                            local create4 = tweenService:Create(instance18, TweenInfo.new(
                                                                                                                                                                                            0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In
                                                                                                                                                                                            ), {
                                                                                                                                                                                            BackgroundTransparency = 1,
                                                                                                                                                                                            Size = UDim2.new(0, 0, 0, 0),
                                                                                                                                                                                            })

                                                                                                                                                                                            create4:Play()

                                                                                                                                                                                            create4.Completed:Connect(function()
                                                                                                                                                                                            instance18:Destroy()
                                                                                                                                                                                            instance16.Size = UDim2.new(0, 300, 0, instance16.Size.Y.Offset - 45)
                                                                                                                                                                                        end)
                                                                                                                                                                                    end)
                                                                                                                                                                                end)
                                                                                                                                                                            end)
                                                                                                                                                                        end

                                                                                                                                                                        local v14 = {}

                                                                                                                                                                        local function f10(p10)
                                                                                                                                                                        local v15 = {}

                                                                                                                                                                        for index18, value19 in ipairs({ "Backpack", "StarterGear", "StarterPack" }) do
                                                                                                                                                                                local findFirstChild4 = p10:FindFirstChild(value19)

                                                                                                                                                                                if findFirstChild4 then
                                                                                                                                                                                        for index19, value20 in ipairs(findFirstChild4:GetChildren()) do
                                                                                                                                                                                                if value20:IsA("Tool") then
                                                                                                                                                                                                        table.insert(v15, value20)
                                                                                                                                                                                                    end
                                                                                                                                                                                                end
                                                                                                                                                                                            end
                                                                                                                                                                                        end

                                                                                                                                                                                        if p10.Character then
                                                                                                                                                                                                for index20, value21 in ipairs(p10.Character:GetChildren()) do
                                                                                                                                                                                                        if value21:IsA("Tool") then
                                                                                                                                                                                                                table.insert(v15, value21)
                                                                                                                                                                                                            end
                                                                                                                                                                                                        end
                                                                                                                                                                                                    end

                                                                                                                                                                                                    local v16 = {
                                                                                                                                                                                                    Common = 1,
                                                                                                                                                                                                    Uncommon = 2,
                                                                                                                                                                                                    Rare = 3,
                                                                                                                                                                                                    Epic = 4,
                                                                                                                                                                                                    Legendary = 5,
                                                                                                                                                                                                    Omega = 6,
                                                                                                                                                                                                    }

                                                                                                                                                                                                    local rarity2 = "Common"

                                                                                                                                                                                                    for index21, value22 in ipairs(v15) do
                                                                                                                                                                                                            local v17 = f3(value22)

                                                                                                                                                                                                            if v16[v17.Rarity] and v16[v17.Rarity] > v16[rarity2] then
                                                                                                                                                                                                                    rarity2 = v17.Rarity
                                                                                                                                                                                                                end
                                                                                                                                                                                                            end

                                                                                                                                                                                                            if v16[rarity2] and v16[rarity2] >= v16.Uncommon then
                                                                                                                                                                                                                    if not v14[p10] or v14[p10] ~= rarity2 then
                                                                                                                                                                                                                            v14[p10] = rarity2
                                                                                                                                                                                                                            f9(p10.Name, rarity2)
                                                                                                                                                                                                                        end
                                                                                                                                                                                                                    else
                                                                                                                                                                                                                        v14[p10] = nil
                                                                                                                                                                                                                    end
                                                                                                                                                                                end

                                                                                                                                                                                spawn(function()
                                                                                                                                                                                while true do
                                                                                                                                                                                        if v10 then
                                                                                                                                                                                                f8() -- อัปเดตรายชื่อผู้เล่นและไอเทมแบบเรียลไทม์
                                                                                                                                                                                        end
                                                                                                                                                                                        for index22, value23 in ipairs(players:GetPlayers()) do
                                                                                                                                                                                                if value23 ~= localPlayer then
                                                                                                                                                                                                        f10(value23)
                                                                                                                                                                                                    end
                                                                                                                                                                                                end

                                                                                                                                                                                                task.wait(0.1) -- ปรับเป็นทำงานทุกๆ 0.1 วินาที
                                                                                                                                                                                    end
                                                                                                                                                                                end)

                                                                                                                                                                                v10 = true
                                                                                                                                                                                instance4.Text = "<<"
                                                                                                                                                                                instance2.Visible = true
                                                                                                                                                                                f8()
