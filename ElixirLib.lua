local ElixirLib = {}

-- === CORES DEFINIDAS AQUI PARA FÁCIL MANUTENÇÃO ===
local Colors = {
    MainBackgroundStart = Color3.fromRGB(0, 255, 0),      -- Neon verde (início degrade)
    MainBackgroundEnd = Color3.fromRGB(25, 25, 25),       -- Escuro (fim degrade)
    Border = Color3.fromRGB(0, 255, 0),                   -- Verde neon da borda
    TopBarStart = Color3.fromRGB(0, 255, 0),              -- Neon verde topbar (início degrade)
    TopBarEnd = Color3.fromRGB(30, 30, 30),                -- Escuro topbar (fim degrade)
    TitleText = Color3.fromRGB(200, 200, 255),             -- Cor do texto do título
    LeftPanelBackground = Color3.fromRGB(28, 28, 28),      -- Fundo painel esquerdo (cor base)
    FloatButtonBackground = Color3.fromRGB(20, 20, 20),    -- Fundo botão flutuante
}

function ElixirLib:MakeWindow(config)
    local Window = {}

    -- Serviços
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

    -- Detecta se é mobile para ajustar tamanho inicial
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

    -- Tamanhos padrão e mobile
    local defaultSize = UDim2.new(0, 700, 0, 400)
    local mobileSize = UDim2.new(0, 600, 0, 300)

    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainUIFrame"
    mainFrame.Size = isMobile and mobileSize or defaultSize
    mainFrame.Position = UDim2.new(0.5, -mainFrame.Size.X.Offset/2, 0.2, 0)
    mainFrame.BackgroundColor3 = Colors.MainBackgroundEnd -- fallback degrade
    mainFrame.Parent = screenGui
    mainFrame.ClipsDescendants = true
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = Colors.Border

    -- Degrade fundo principal
    local mainGradient = Instance.new("UIGradient")
    mainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Colors.MainBackgroundStart),
        ColorSequenceKeypoint.new(1, Colors.MainBackgroundEnd)
    })
    mainGradient.Parent = mainFrame

    -- TopBar
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = Colors.TopBarEnd -- fallback degrade
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12)

    -- Degrade topBar
    local topGradient = Instance.new("UIGradient")
    topGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Colors.TopBarStart),
        ColorSequenceKeypoint.new(1, Colors.TopBarEnd)
    })
    topGradient.Parent = topBar

    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -60, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = config.Name or "Elixir Client"
    titleLabel.TextColor3 = Colors.TitleText
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 20
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar

    -- Botão minimizar
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
    divider.BackgroundColor3 = Colors.Border
    divider.BorderSizePixel = 0
    divider.Parent = mainFrame
    Instance.new("UICorner", divider).CornerRadius = UDim.new(1, 0)

    -- Conteúdo principal
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -42)
    contentFrame.Position = UDim2.new(0, 0, 0, 42)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    -- Painel esquerdo com degrade neon -> escuro
    local leftPanel = Instance.new("Frame")
    leftPanel.Size = UDim2.new(0, 180, 1, 0)
    leftPanel.BackgroundColor3 = Colors.LeftPanelBackground -- cor base
    leftPanel.Parent = contentFrame
    Instance.new("UICorner", leftPanel).CornerRadius = UDim.new(0, 10)
    local leftStroke = Instance.new("UIStroke", leftPanel)
    leftStroke.Color = Colors.Border

    local leftGradient = Instance.new("UIGradient")
    leftGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Colors.MainBackgroundStart),
        ColorSequenceKeypoint.new(1, Colors.MainBackgroundEnd)
    })
    leftGradient.Parent = leftPanel

    -- Painel direito (transparente)
    local rightPanel = Instance.new("Frame")
    rightPanel.Size = UDim2.new(1, -180, 1, 0)
    rightPanel.Position = UDim2.new(0, 180, 0, 0)
    rightPanel.BackgroundTransparency = 1
    rightPanel.Parent = contentFrame


    -- Notificação personalizada (via módulo externo)
    local function showNotification(message)
        local notification = loadstring(game:HttpGet('https://raw.githubusercontent.com/9menta/tests/refs/heads/main/notification.lua'))()
        notification({
            Title = 'Minimized',
            Text = message,
            Image = 'rbxassetid://72671288986713',
            Duration = 10
        })
    end

    -- Controle de minimização e notificação só 1 vez
    local isMinimized = false
    local notificationShown = false

    local function toggleUI()
        isMinimized = not isMinimized
        mainFrame.Visible = not isMinimized
        if isMinimized and not notificationShown then
            showNotification("Pressione RightShift ou use o botão flutuante para abrir.")
            notificationShown = true
        end
    end

    -- Hotkey para minimizar (RightShift)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
            toggleUI()
        end
    end)

    minimizeButton.MouseButton1Click:Connect(toggleUI)

    -- Drag do frame principal
    local draggingMain = false
    local dragInputMain, mousePosMain, framePosMain

    local function updateMain(input)
        local delta = input.Position - mousePosMain
        mainFrame.Position = UDim2.new(framePosMain.X.Scale, framePosMain.X.Offset + delta.X,
            framePosMain.Y.Scale, framePosMain.Y.Offset + delta.Y)
    end

    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingMain = true
            mousePosMain = input.Position
            framePosMain = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    draggingMain = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInputMain and draggingMain then
            updateMain(input)
        end
    end)

    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInputMain = input
        end
    end)

    -- Botão flutuante minimizar
    local floatButton = Instance.new("ImageButton")
    floatButton.Name = "FloatingMinimizeButton"
    floatButton.Size = UDim2.new(0, 40, 0, 40)
    floatButton.Position = UDim2.new(0, 20, 0.5, -20)
    floatButton.BackgroundColor3 = Colors.FloatButtonBackground
    floatButton.Image = "rbxassetid://72671288986713"
    floatButton.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 100)
    corner.Parent = floatButton

    local stroke = Instance.new("UIStroke")
    stroke.Color = Colors.Border
    stroke.Thickness = 2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = floatButton

    -- Drag do botão flutuante
    local draggingFloat = false
    local dragInputFloat, dragStartFloat, startPosFloat

    local function updateFloat(input)
        local delta = input.Position - dragStartFloat
        floatButton.Position = UDim2.new(startPosFloat.X.Scale, startPosFloat.X.Offset + delta.X,
            startPosFloat.Y.Scale, startPosFloat.Y.Offset + delta.Y)
    end

    floatButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingFloat = true
            dragStartFloat = input.Position
            startPosFloat = floatButton.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    draggingFloat = false
                end
            end)
        end
    end)

    floatButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInputFloat = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInputFloat and draggingFloat then
            updateFloat(input)
        end
    end)

    floatButton.MouseButton1Click:Connect(toggleUI)
    local Window = {}
    local Tabs = {}
    local tabContents = {}
    
    local tabButtons = {}
    
    -- Cria ScrollingFrame para os botões das abas
    local tabScroll = Instance.new("ScrollingFrame")
    tabScroll.Size = UDim2.new(1, 0, 1, 0)
    tabScroll.Position = UDim2.new(0, 0, 0, 0)
    tabScroll.BackgroundTransparency = 1
    tabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabScroll.ScrollBarThickness = 4
    tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabScroll.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    tabScroll.Parent = leftPanel
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Padding = UDim.new(0, 5)
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Parent = tabScroll
    
    function Window:MakeTab(tabData)
        local tabName = tabData.Name or "Aba"
        local tabIcon = tabData.Icon or ""
        local tab = {}
        tab.Sections = {}
    
        -- Botão da tab
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -20, 0, 40)
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        button.Text = ""
        button.AutoButtonColor = true
        button.Parent = tabScroll  -- agora dentro do scroll
    
        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 24, 0, 24)
        icon.Position = UDim2.new(0, 10, 0.5, -12)
        icon.BackgroundTransparency = 1
        icon.Image = tabIcon
        icon.Parent = button
    
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -44, 1, 0)
        label.Position = UDim2.new(0, 40, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = tabName
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 18
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = button
    
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = button
    
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = Color3.fromRGB(0, 255, 0)
        btnStroke.Thickness = 1
        btnStroke.Parent = button
    
        table.insert(tabButtons, button)
    
        -- Frame da aba
        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = rightPanel
    
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = tabContent
    
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -20, 0, 50)
        title.Position = UDim2.new(0, 10, 0, 10)
        title.BackgroundTransparency = 1
        title.Text = tabName
        title.TextColor3 = Color3.fromRGB(200, 200, 255)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 24
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = tabContent
    
        local scrollContainer = Instance.new("ScrollingFrame")
        scrollContainer.Size = UDim2.new(1, -20, 1, -70)
        scrollContainer.Position = UDim2.new(0, 10, 0, 60)
        scrollContainer.BackgroundTransparency = 1
        scrollContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
        scrollContainer.ScrollBarThickness = 4
        scrollContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scrollContainer.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
        scrollContainer.Parent = tabContent
    
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 10)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = scrollContainer
    
        tab.Container = scrollContainer
    
        button.MouseButton1Click:Connect(function()
            for _, content in pairs(tabContents) do
                content.Visible = false
            end
            tabContent.Visible = true
        end)
    
        table.insert(tabContents, tabContent)
       

	--Seções🟢
   function tab:AddSection(sectionData)
    local name = sectionData.Name or "Section"

    local sectionFrame = Instance.new("Frame")
    sectionFrame.Size = UDim2.new(1, 0, 0, 30)
    sectionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    sectionFrame.LayoutOrder = #self.Container:GetChildren() + 1
    sectionFrame.Parent = self.Container

    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 6)
    sectionCorner.Parent = sectionFrame

    local sectionStroke = Instance.new("UIStroke")
    sectionStroke.Color = Color3.fromRGB(40, 40, 40)
    sectionStroke.Thickness = 1
    sectionStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    sectionStroke.Parent = sectionFrame

    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size = UDim2.new(1, -10, 1, 0)
    sectionLabel.Position = UDim2.new(0, 5, 0, 0)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = name
    sectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sectionLabel.Font = Enum.Font.GothamSemibold
    sectionLabel.TextSize = 16
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Parent = sectionFrame

    -- Permitir usar Section:AddLabel
    local section = {}
    section.Tab = self -- armazena a tab original

    function section:AddLabel(text)
        return self.Tab:AddLabel(text)
    end

    return section
end
	
	--label🟢
	
	function tab:AddLabel(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.LayoutOrder = #self.Container:GetChildren() + 1
    label.Parent = self.Container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = label

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(40, 40, 40)
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = label

    return label
end
    
	--Toggle 🟢
	function tab:AddToggle(toggleData)
        local toggleName = toggleData.Name or "Toggle"
        local defaultValue = toggleData.Default or false
        local callback = toggleData.Callback or function() end
    
        local TweenService = game:GetService("TweenService")
    
        local toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(1, 0, 0, 40)
        toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        toggleButton.Text = ""
        toggleButton.AutoButtonColor = false
        toggleButton.LayoutOrder = #self.Container:GetChildren() + 1
        toggleButton.Parent = self.Container
    
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = toggleButton
    
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 255, 0)
        stroke.Thickness = 1
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = toggleButton
    
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -60, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = toggleName
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.Gotham
        label.TextSize = 16
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleButton
    
        local switch = Instance.new("TextButton")
        switch.Size = UDim2.new(0, 50, 0, 24)
        switch.Position = UDim2.new(1, -60, 0.5, -12)
        switch.AnchorPoint = Vector2.new(0, 0)
        switch.BackgroundTransparency = 1
        switch.BorderSizePixel = 0
        switch.Text = ""
        switch.Parent = toggleButton
    
        local switchFrame = Instance.new("Frame")
        switchFrame.Size = UDim2.new(1, 0, 1, 0)
        switchFrame.Position = UDim2.new(0, 0, 0, 0)
        switchFrame.BorderSizePixel = 0
        switchFrame.Parent = switch
    
        Instance.new("UICorner", switchFrame).CornerRadius = UDim.new(1, 0)
    
        local frameStroke = Instance.new("UIStroke")
        frameStroke.Thickness = 2
        frameStroke.Color = Color3.fromRGB(100, 100, 100)
        frameStroke.Parent = switchFrame
    
        local frameGradient = Instance.new("UIGradient")
        frameGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 130, 130))
        }
        frameGradient.Parent = switchFrame
    
        local ball = Instance.new("Frame")
        ball.Size = UDim2.new(0, 20, 1, -4)
        ball.Position = defaultValue and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)
        ball.BackgroundTransparency = 1
        ball.BorderSizePixel = 0
        ball.Parent = switchFrame
    
        Instance.new("UICorner", ball).CornerRadius = UDim.new(1, 0)
    
        local ballStroke = Instance.new("UIStroke")
        ballStroke.Thickness = 2
        ballStroke.Color = Color3.fromRGB(100, 100, 100)
        ballStroke.Parent = ball
    
        local ballGradient = Instance.new("UIGradient")
        ballGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 80))
        }
        ballGradient.Parent = ball
    
        -- Cores de estado
        local colorOff = Color3.fromRGB(100, 100, 100)
        local colorOn = Color3.fromRGB(0, 255, 0) -- verde neon
    
        local gradientOff = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 130, 130))
        }
    
        local gradientOn = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 180, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 100))
        }
    
        local ballGradientOff = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 80))
        }
    
        local ballGradientOn = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 255, 150))
        }
    
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
        local toggled = defaultValue
    
        local function toggleSwitch()
            toggled = not toggled
    
            local newPos = toggled and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)
            TweenService:Create(ball, tweenInfo, { Position = newPos }):Play()
    
            local strokeColor = toggled and colorOn or colorOff
            TweenService:Create(ballStroke, tweenInfo, { Color = strokeColor }):Play()
            TweenService:Create(frameStroke, tweenInfo, { Color = strokeColor }):Play()
    
            frameGradient.Color = toggled and gradientOn or gradientOff
            ballGradient.Color = toggled and ballGradientOn or ballGradientOff
    
            callback(toggled)
        end
    
        toggleButton.MouseButton1Click:Connect(toggleSwitch)
        switch.MouseButton1Click:Connect(toggleSwitch)
    
        return toggleButton
    end
    
    
    --- aqui eo botao🟢

    function tab:AddButton(buttonData)
        local name = buttonData.Name or "Button"
        local callback = buttonData.Callback or function() end
    
        -- Container do botão
        local buttonFrame = Instance.new("Frame")
        buttonFrame.Size = UDim2.new(1, 0, 0, 30)
        buttonFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        buttonFrame.LayoutOrder = #self.Container:GetChildren() + 1
        buttonFrame.Parent = self.Container
    
        -- Estilo do botão
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = buttonFrame
    
        local buttonStroke = Instance.new("UIStroke")
        buttonStroke.Color = Color3.fromRGB(0, 255, 0)
        buttonStroke.Thickness = 1
        buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        buttonStroke.Parent = buttonFrame
    
        -- Nome do botão
        local buttonLabel = Instance.new("TextButton")
        buttonLabel.Size = UDim2.new(1, -10, 1, 0)
        buttonLabel.Position = UDim2.new(0, 5, 0, 0)
        buttonLabel.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        buttonLabel.BackgroundTransparency = 0.2
        buttonLabel.Text = name
        buttonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        buttonLabel.Font = Enum.Font.GothamSemibold
        buttonLabel.TextSize = 16
        buttonLabel.TextXAlignment = Enum.TextXAlignment.Center
        buttonLabel.Parent = buttonFrame
    
        -- Ação do botão
        buttonLabel.MouseButton1Click:Connect(function()
            callback()  -- Executa a função callback quando o botão é pressionado
        end)
    
        return buttonFrame
    end
    
    --Keybind🟢

    function tab:AddBind(bindData)
        local name = bindData.Name or "Bind"
        local defaultKey = bindData.Default or Enum.KeyCode.E
        local hold = bindData.Hold or false
        local callback = bindData.Callback or function() end
    
        local UserInputService = game:GetService("UserInputService")
    
        -- Container principal
        local bindContainer = Instance.new("TextButton")
        bindContainer.Size = UDim2.new(1, 0, 0, 40)
        bindContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        bindContainer.Text = ""
        bindContainer.AutoButtonColor = false
        bindContainer.LayoutOrder = #self.Container:GetChildren() + 1
        bindContainer.Parent = self.Container
    
        Instance.new("UICorner", bindContainer).CornerRadius = UDim.new(0, 8)
    
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 255, 0)
        stroke.Thickness = 1
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = bindContainer
    
        -- Label
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -80, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.Gotham
        label.TextSize = 16
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = bindContainer
    
        -- Texto da tecla
        local keyLabel = Instance.new("TextLabel")
        keyLabel.Size = UDim2.new(0, 60, 0, 24)
        keyLabel.Position = UDim2.new(1, -70, 0.5, -12)
        keyLabel.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        keyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        keyLabel.Text = defaultKey.Name
        keyLabel.Font = Enum.Font.Gotham
        keyLabel.TextSize = 14
        keyLabel.Parent = bindContainer
    
        Instance.new("UICorner", keyLabel).CornerRadius = UDim.new(0, 6)
    
        local keyStroke = Instance.new("UIStroke")
        keyStroke.Color = Color3.fromRGB(0, 255, 0)
        keyStroke.Thickness = 1
        keyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        keyStroke.Parent = keyLabel
    
        local binding = false
        local currentKey = defaultKey
    
        -- Ativar modo de bind ao clicar no botÃ£o
        bindContainer.MouseButton1Click:Connect(function()
            keyLabel.Text = "..."
            binding = true
        end)
    
        -- Captura nova tecla
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if binding and not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = input.KeyCode
                keyLabel.Text = currentKey.Name
                binding = false
            end
        end)
    
        -- Chama o callback se tecla for pressionada
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == currentKey then
                if not hold then
                    callback()
                end
            end
        end)
    
        -- Suporte a "Hold"
        if hold then
            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentKey then
                    callback(true)
                end
            end)
    
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentKey then
                    callback(false)
                end
            end)
        end
    
        return bindContainer
    end
    
	--Dropdown🟢
	
    function tab:AddDropdown(dropdownData)
        local name = dropdownData.Name or "Dropdown"
        local default = dropdownData.Default or ""
        local options = dropdownData.Options or {}
        local callback = dropdownData.Callback or function() end
    
        local open = false
        local selectedValue = default
    
        -- Container principal
        local dropdownContainer = Instance.new("Frame")
        dropdownContainer.Size = UDim2.new(1, 0, 0, 40)
        dropdownContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        dropdownContainer.LayoutOrder = #self.Container:GetChildren() + 1
        dropdownContainer.Parent = self.Container
        dropdownContainer.ZIndex = 2
    
        Instance.new("UICorner", dropdownContainer).CornerRadius = UDim.new(0, 8)
    
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 255, 0)
        stroke.Thickness = 1
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = dropdownContainer
    
        -- Label
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -80, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.Gotham
        label.TextSize = 16
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 2
        label.Parent = dropdownContainer
    
        -- Botão principal do dropdown
        local dropButton = Instance.new("TextButton")
        dropButton.Size = UDim2.new(0, 100, 0, 24)
        dropButton.Position = UDim2.new(1, -110, 0.5, -12)
        dropButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        dropButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        dropButton.Font = Enum.Font.Gotham
        dropButton.TextSize = 14
        dropButton.Text = default
        dropButton.ZIndex = 2
        dropButton.Parent = dropdownContainer
    
        Instance.new("UICorner", dropButton).CornerRadius = UDim.new(0, 6)
    
        local dropStroke = Instance.new("UIStroke")
        dropStroke.Color = Color3.fromRGB(0, 255, 0)
        dropStroke.Thickness = 1
        dropStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        dropStroke.Parent = dropButton
    
        -- Lista de opções scrollável
        local optionFrame = Instance.new("ScrollingFrame")
        optionFrame.Visible = false
        optionFrame.Size = UDim2.new(0, 100, 0, 100)
        optionFrame.Position = UDim2.new(1, -110, 1, 5)
        optionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        optionFrame.BorderSizePixel = 0
        optionFrame.ScrollBarThickness = 2
        optionFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 0)
        optionFrame.ClipsDescendants = true
        optionFrame.CanvasSize = UDim2.new(0, 0, 0, #options * 26)
        optionFrame.ZIndex = 5
        optionFrame.Parent = dropdownContainer
    
        Instance.new("UICorner", optionFrame).CornerRadius = UDim.new(0, 6)
    
        local uiList = Instance.new("UIListLayout")
        uiList.SortOrder = Enum.SortOrder.LayoutOrder
        uiList.Padding = UDim.new(0, 2)
        uiList.Parent = optionFrame
    
        local function setOption(value)
            selectedValue = value
            dropButton.Text = value
            callback(value)
            optionFrame.Visible = false
            open = false
        end
    
        for _, option in ipairs(options) do
            local optionBtn = Instance.new("TextButton")
            optionBtn.Size = UDim2.new(1, -4, 0, 24)
            optionBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            optionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            optionBtn.Text = option
            optionBtn.Font = Enum.Font.Gotham
            optionBtn.TextSize = 14
            optionBtn.ZIndex = 6
            optionBtn.Parent = optionFrame
    
            Instance.new("UICorner", optionBtn).CornerRadius = UDim.new(0, 4)
    
            optionBtn.MouseButton1Click:Connect(function()
                setOption(option)
            end)
        end
    
        dropButton.MouseButton1Click:Connect(function()
            open = not open
            optionFrame.Visible = open
        end)
    
        return dropdownContainer
    end
    
    
-- Slider 🟢 (estilo neon degradê)
function tab:AddSlider(sliderData)
    local name = sliderData.Name or "Slider"
    local min = sliderData.Min or 0
    local max = sliderData.Max or 100
    local default = sliderData.Default or 50
    local color = sliderData.Color or Color3.fromRGB(0, 255, 0)
    local increment = sliderData.Increment or 1
    local valueName = sliderData.ValueName or "Valor"
    local callback = sliderData.Callback or function() end

    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")

    local sliderContainer = Instance.new("Frame")
    sliderContainer.Size = UDim2.new(1, 0, 0, 60)
    sliderContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    sliderContainer.BackgroundTransparency = 0.1
    sliderContainer.BorderSizePixel = 0
    sliderContainer.Parent = self.Container
    sliderContainer.LayoutOrder = #self.Container:GetChildren() + 1

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = sliderContainer

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderContainer

    -- Slider Background
    local sliderBG = Instance.new("Frame")
    sliderBG.Size = UDim2.new(1, -80, 0, 20)
    sliderBG.Position = UDim2.new(0, 10, 0, 30)
    sliderBG.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    sliderBG.BorderSizePixel = 0
    sliderBG.Parent = sliderContainer

    local bgCorner = Instance.new("UICorner", sliderBG)
    bgCorner.CornerRadius = UDim.new(0, 10)

    -- Preenchimento com degradê
    local fillBar = Instance.new("Frame")
    fillBar.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fillBar.BackgroundColor3 = color
    fillBar.BorderSizePixel = 0
    fillBar.Parent = sliderBG

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color),
        ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
    }
    gradient.Rotation = 0
    gradient.Parent = fillBar

    local fillCorner = Instance.new("UICorner", fillBar)
    fillCorner.CornerRadius = UDim.new(0, 10)

    -- Valor
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 60, 0, 20)
    valueLabel.Position = UDim2.new(1, -65, 0, 30)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextColor3 = color
    valueLabel.Text = tostring(default)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Center
    valueLabel.Parent = sliderContainer

    -- Atualização de valor
    local function updateSlider(inputX)
        local relX = math.clamp(inputX - sliderBG.AbsolutePosition.X, 0, sliderBG.AbsoluteSize.X)
        local percent = relX / sliderBG.AbsoluteSize.X
        local scaledValue = min + percent * (max - min)
        local rounded = math.floor(scaledValue / increment + 0.5) * increment
        percent = (rounded - min) / (max - min)

        fillBar.Size = UDim2.new(percent, 0, 1, 0)
        valueLabel.Text = tostring(rounded)
        callback(rounded)
    end

    local dragging = false

    sliderBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return sliderContainer
end

    
	function tab:AddTextbox(textboxData)
    local name = textboxData.Name or "Textbox"
    local default = textboxData.Default or ""
    local textDisappear = textboxData.TextDisappear or false
    local callback = textboxData.Callback or function() end

    -- Container principal
    local textboxContainer = Instance.new("Frame")
    textboxContainer.Size = UDim2.new(1, 0, 0, 40)
    textboxContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    textboxContainer.LayoutOrder = #self.Container:GetChildren() + 1
    textboxContainer.Parent = self.Container

    Instance.new("UICorner", textboxContainer).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 255, 0) -- Verde
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = textboxContainer

    -- Label do Textbox
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -120, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = textboxContainer

    -- Caixa de texto
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 100, 0, 24)
    textBox.Position = UDim2.new(1, -110, 0.5, -12)
    textBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 14
    textBox.Text = default
    textBox.PlaceholderText = default
    textBox.ClearTextOnFocus = textDisappear
    textBox.Parent = textboxContainer

    Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 6)

    local textBoxStroke = Instance.new("UIStroke")
    textBoxStroke.Color = Color3.fromRGB(0, 255, 0) -- Verde
    textBoxStroke.Thickness = 1
    textBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    textBoxStroke.Parent = textBox

    -- Quando o jogador digitar e sair do foco
    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(textBox.Text)
        end
    end)

    return textboxContainer
end

    
    return tab
end




local UserInputService = game:GetService("UserInputService")

local resizeButton = Instance.new("ImageButton")
resizeButton.Size = UDim2.new(0, 20, 0, 20)
resizeButton.Position = UDim2.new(1, -20, 1, -20)
resizeButton.AnchorPoint = Vector2.new(1, 1)
resizeButton.BackgroundTransparency = 1
resizeButton.Image = "rbxassetid://6031097226" -- Ícone de redimensionar (setas diagonais)
resizeButton.ZIndex = 10
resizeButton.Parent = mainFrame
resizeButton.Active = true

local resizing = false
local dragStartPos = nil
local startSize = nil
local currentInput = nil

resizeButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        dragStartPos = input.Position
        startSize = mainFrame.Size
        currentInput = input

        -- Detecta quando o input termina para parar o redimensionamento
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                resizing = false
                currentInput = nil
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizing and input == currentInput then
        local delta = input.Position - dragStartPos
        local newWidth = math.clamp(startSize.X.Offset + delta.X, 300, 1200)
        local newHeight = math.clamp(startSize.Y.Offset + delta.Y, 200, 800)
        mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input == currentInput then
        resizing = false
        currentInput = nil
    end
end)


    return Window
end

return ElixirLib
