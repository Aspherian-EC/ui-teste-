local ElixirLib = {}

function ElixirLib:MakeWindow(config)
    local Window = {}
    
    -- Referências de serviços
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    -- Criar ou obter ScreenGui
    local screenGui = playerGui:FindFirstChild("CustomUI") or Instance.new("ScreenGui")
    screenGui.Name = "CustomUI"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = playerGui

    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainUIFrame"
    mainFrame.Size = UDim2.new(0, 700, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -350, 0.2, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.Parent = screenGui

    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(170, 0, 255)

    -- TopBar
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -60, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = config.Name or "Elixir Client"
    titleLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 20
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar

    local minimizeButton = Instance.new("ImageButton")
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -40, 0, 5)
    minimizeButton.BackgroundTransparency = 1
    minimizeButton.Image = "rbxassetid://10738425363"
    minimizeButton.Parent = topBar
    Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(1, 0)

    -- Divider
    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, -20, 0, 2)
    divider.Position = UDim2.new(0, 10, 0, 40)
    divider.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
    divider.BorderSizePixel = 0
    divider.Parent = mainFrame
    Instance.new("UICorner", divider).CornerRadius = UDim.new(1, 0)

    -- Conteúdo principal
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -42)
    contentFrame.Position = UDim2.new(0, 0, 0, 42)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    local leftPanel = Instance.new("Frame")
    leftPanel.Size = UDim2.new(0, 180, 1, 0)
    leftPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    leftPanel.Parent = contentFrame
    Instance.new("UICorner", leftPanel).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", leftPanel).Color = Color3.fromRGB(170, 0, 255)

    local rightPanel = Instance.new("Frame")
    rightPanel.Size = UDim2.new(1, -180, 1, 0)
    rightPanel.Position = UDim2.new(0, 180, 0, 0)
    rightPanel.BackgroundTransparency = 1
    rightPanel.Parent = contentFrame

    -- TABS
    function Window:MakeTab(tabData)
        local Tab = {}
        
        -- Criar botão lateral (leftPanel)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, -20, 0, 40)
        tabButton.Position = UDim2.new(0, 10, 0, #leftPanel:GetChildren() * 45)
        tabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        tabButton.Text = tabData.Name or "Tab"
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 16
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.Parent = leftPanel

        Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 8)

        -- Criar conteúdo da aba
        local tabFrame = Instance.new("ScrollingFrame")
        tabFrame.Size = UDim2.new(1, -20, 1, -20)
        tabFrame.Position = UDim2.new(0, 10, 0, 10)
        tabFrame.BackgroundTransparency = 1
        tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabFrame.Visible = false
        tabFrame.Parent = rightPanel

        -- Mostrar quando clica
        tabButton.MouseButton1Click:Connect(function()
            for _, frame in pairs(rightPanel:GetChildren()) do
                if frame:IsA("ScrollingFrame") then
                    frame.Visible = false
                end
            end
            tabFrame.Visible = true
        end)

        function Tab:AddToggle(data)
            local toggle = Instance.new("TextButton")
            toggle.Size = UDim2.new(1, -10, 0, 30)
            toggle.Text = "[ OFF ] " .. data.Name
            toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggle.Font = Enum.Font.Gotham
            toggle.TextSize = 14
            toggle.Parent = tabFrame

            local enabled = data.Default or false

            toggle.MouseButton1Click:Connect(function()
                enabled = not enabled
                toggle.Text = (enabled and "[ ON ] " or "[ OFF ] ") .. data.Name
                if data.Callback then
                    data.Callback(enabled)
                end
            end)
        end

        function Tab:AddTextbox(data)
            local textBox = Instance.new("TextBox")
            textBox.Size = UDim2.new(1, -10, 0, 30)
            textBox.PlaceholderText = data.Name or "Textbox"
            textBox.Text = data.Default or ""
            textBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            textBox.Font = Enum.Font.Gotham
            textBox.TextSize = 14
            textBox.Parent = tabFrame

            textBox.FocusLost:Connect(function()
                if data.Callback then
                    data.Callback(textBox.Text)
                end
                if data.TextDisappear then
                    textBox.Text = ""
                end
            end)
        end

        function Tab:AddSlider(data)
            -- Se quiser posso montar o slider depois com estilo custom
        end

        function Tab:AddSection(data)
            -- Se quiser posso adicionar também um estilo de section
        end

        return Tab
    end

    return Window
end

return ElixirLib
