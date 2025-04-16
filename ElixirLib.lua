local ElixirLib = {}

function ElixirLib:MakeWindow(data)
	local Players = game:GetService("Players")
	local UserInputService = game:GetService("UserInputService")
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local screenGui = playerGui:FindFirstChild("CustomUI") or Instance.new("ScreenGui")
	screenGui.Name = "CustomUI"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.Parent = playerGui

	local isMinimized = false

	local function showNotification(message)
		local notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/9menta/tests/refs/heads/main/notification.lua"))()
		notification({
			Title = 'UI Minimized - Press "RightShift"',
			Text = message,
			Image = 'rbxassetid://72671288986713',
			Duration = 10
		})
	end

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainUIFrame"
	mainFrame.Size = UDim2.new(0, 700, 0, 400)
	mainFrame.Position = UDim2.new(0.5, -350, 0.2, 0)
	mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	mainFrame.Parent = screenGui

	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 12)
	uiCorner.Parent = mainFrame

	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = Color3.fromRGB(170, 0, 255)
	uiStroke.Thickness = 2
	uiStroke.Parent = mainFrame

	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0, 40)
	topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	topBar.BorderSizePixel = 0
	topBar.Parent = mainFrame

	local topBarCorner = Instance.new("UICorner")
	topBarCorner.CornerRadius = UDim.new(0, 12)
	topBarCorner.Parent = topBar

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -60, 1, 0)
	titleLabel.Position = UDim2.new(0, 10, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = data.Name or "Elixir Client"
	titleLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 20
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = topBar

	local minimizeButton = Instance.new("ImageButton")
	minimizeButton.Name = "MinimizeButton"
	minimizeButton.Size = UDim2.new(0, 30, 0, 30)
	minimizeButton.Position = UDim2.new(1, -40, 0, 5)
	minimizeButton.BackgroundTransparency = 1
	minimizeButton.Image = "rbxassetid://10738425363"
	minimizeButton.Parent = topBar

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(1, 0)
	buttonCorner.Parent = minimizeButton

	local divider = Instance.new("Frame")
	divider.Name = "Divider"
	divider.Size = UDim2.new(1, -20, 0, 2)
	divider.Position = UDim2.new(0, 10, 0, 40)
	divider.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
	divider.BorderSizePixel = 0
	divider.Parent = mainFrame

	local dividerCorner = Instance.new("UICorner")
	dividerCorner.CornerRadius = UDim.new(1, 0)
	dividerCorner.Parent = divider

	local contentFrame = Instance.new("Frame")
	contentFrame.Name = "Content"
	contentFrame.Size = UDim2.new(1, 0, 1, -42)
	contentFrame.Position = UDim2.new(0, 0, 0, 42)
	contentFrame.BackgroundTransparency = 1
	contentFrame.Parent = mainFrame

	local leftPanel = Instance.new("Frame")
	leftPanel.Size = UDim2.new(0, 180, 1, 0)
	leftPanel.Position = UDim2.new(0, 0, 0, 0)
	leftPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	leftPanel.Parent = contentFrame

	local leftPanelCorner = Instance.new("UICorner")
	leftPanelCorner.CornerRadius = UDim.new(0, 10)
	leftPanelCorner.Parent = leftPanel

	local leftPanelStroke = Instance.new("UIStroke")
	leftPanelStroke.Color = Color3.fromRGB(170, 0, 255)
	leftPanelStroke.Thickness = 1
	leftPanelStroke.Parent = leftPanel

	local rightPanel = Instance.new("Frame")
	rightPanel.Size = UDim2.new(1, -180, 1, 0)
	rightPanel.Position = UDim2.new(0, 180, 0, 0)
	rightPanel.BackgroundTransparency = 1
	rightPanel.Parent = contentFrame

	local function toggleUI()
		isMinimized = not isMinimized
		mainFrame.Visible = not isMinimized
		if isMinimized then
			showNotification("Pressione RightShift ou use o botão flutuante para abrir.")
		end
	end

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
			toggleUI()
		end
	end)

	minimizeButton.MouseButton1Click:Connect(toggleUI)

	local draggingMain = false
	local dragInputMain, mousePosMain, framePosMain

	local function updateMain(input)
		local delta = input.Position - mousePosMain
		mainFrame.Position = UDim2.new(framePosMain.X.Scale, framePosMain.X.Offset + delta.X, framePosMain.Y.Scale, framePosMain.Y.Offset + delta.Y)
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

	topBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInputMain = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInputMain and draggingMain then
			updateMain(input)
		end
	end)

	local floatButton = Instance.new("ImageButton")
	floatButton.Name = "FloatingMinimizeButton"
	floatButton.Size = UDim2.new(0, 40, 0, 40)
	floatButton.Position = UDim2.new(0, 20, 0.5, -20)
	floatButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	floatButton.Image = "rbxassetid://72671288986713"
	floatButton.AutoButtonColor = true
	floatButton.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 100)
	corner.Parent = floatButton

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(170, 0, 255)
	stroke.Thickness = 2
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = floatButton

	local draggingFloat = false
	local dragInputFloat, dragStartFloat, startPosFloat

	local function updateFloat(input)
		local delta = input.Position - dragStartFloat
		floatButton.Position = UDim2.new(startPosFloat.X.Scale, startPosFloat.X.Offset + delta.X, startPosFloat.Y.Scale, startPosFloat.Y.Offset + delta.Y)
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

-- Sistema de Tabs
local Window = {}
local Tabs = {}
local tabContents = {}

function Window:MakeTab(tabData)
    local tabName = tabData.Name or "Aba"
    local tabIcon = tabData.Icon or ""
    local tab = {}
    tab.Sections = {}

    -- BotÃ£o de tab
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = UDim2.new(0, 10, 0, 10 + (#leftPanel:GetChildren() - 2) * 45)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.Text = ""
    button.AutoButtonColor = true
    button.Parent = leftPanel

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
    btnStroke.Color = Color3.fromRGB(170, 0, 255)
    btnStroke.Thickness = 1
    btnStroke.Parent = button

    -- Frame base da aba
    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 0
    tabContent.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    tabContent.Visible = false
    tabContent.Parent = rightPanel

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = tabContent

    -- TÃ­tulo da aba
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

    -- Ãrea rolÃ¡vel para os elementos (toggles, etc)
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

    -- Armazenar o scroll container como lugar dos elementos
    tab.Container = scrollContainer

    -- Alternar entre as tabs
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
    sectionStroke.Color = Color3.fromRGB(170, 0, 255)
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
    stroke.Color = Color3.fromRGB(170, 0, 255)
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
    
        -- Criar botÃ£o-base do toggle
        local toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(1, 0, 0, 40)
        toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- fundo cinza escuro
        toggleButton.Text = ""
        toggleButton.AutoButtonColor = false
        toggleButton.LayoutOrder = #self.Container:GetChildren() + 1
        toggleButton.Parent = self.Container
    
        -- Canto arredondado
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = toggleButton
    
        -- Borda roxa
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(170, 0, 255)
        stroke.Thickness = 1
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = toggleButton
    
        -- Label do toggle (nome)
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
    
        -- Switch visual
        local switch = Instance.new("TextButton")
        switch.Size = UDim2.new(0, 50, 0, 24)
        switch.Position = UDim2.new(1, -60, 0.5, -12)
        switch.AnchorPoint = Vector2.new(0, 0)
        switch.BackgroundTransparency = 1
        switch.BorderSizePixel = 0
        switch.Text = ""
        switch.Parent = toggleButton
    
        -- Fundo do switch com degradÃª
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
    
        -- Bolinha do toggle
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
        local colorOn = Color3.fromRGB(255, 0, 255)
    
        local gradientOff = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 130, 130))
        }
    
        local gradientOn = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 0, 120)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 80, 255))
        }
    
        local ballGradientOff = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 80))
        }
    
        local ballGradientOn = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 0, 130)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 100, 255))
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
    
        -- Conecta clique no switch e no botÃ£o externo
        toggleButton.MouseButton1Click:Connect(toggleSwitch)
        switch.MouseButton1Click:Connect(toggleSwitch)
    
        return toggleButton
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
        stroke.Color = Color3.fromRGB(170, 0, 255)
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
        keyStroke.Color = Color3.fromRGB(170, 0, 255)
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
    
        Instance.new("UICorner", dropdownContainer).CornerRadius = UDim.new(0, 8)
    
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(170, 0, 255)
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
        label.Parent = dropdownContainer
    
        -- BotÃ£o principal do dropdown
        local dropButton = Instance.new("TextButton")
        dropButton.Size = UDim2.new(0, 100, 0, 24)
        dropButton.Position = UDim2.new(1, -110, 0.5, -12)
        dropButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        dropButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        dropButton.Font = Enum.Font.Gotham
        dropButton.TextSize = 14
        dropButton.Text = default
        dropButton.Parent = dropdownContainer
    
        Instance.new("UICorner", dropButton).CornerRadius = UDim.new(0, 6)
    
        local dropStroke = Instance.new("UIStroke")
        dropStroke.Color = Color3.fromRGB(170, 0, 255)
        dropStroke.Thickness = 1
        dropStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        dropStroke.Parent = dropButton
    
        -- Lista de opÃ§Ãµes scrollÃ¡vel
        local optionFrame = Instance.new("ScrollingFrame")
        optionFrame.Visible = false
        optionFrame.Size = UDim2.new(0, 100, 0, 100)
        optionFrame.Position = UDim2.new(1, -110, 1, 5)
        optionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        optionFrame.BorderSizePixel = 0
        optionFrame.ScrollBarThickness = 2
        optionFrame.ScrollBarImageColor3 = Color3.fromRGB(170, 0, 255)
        optionFrame.ClipsDescendants = true
        optionFrame.CanvasSize = UDim2.new(0, 0, 0, #options * 26)
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
    
	--Slider 🟢
    function tab:AddSlider(sliderData)
        local name = sliderData.Name or "Slider"
        local min = sliderData.Min or 0
        local max = sliderData.Max or 100
        local default = sliderData.Default or 50
        local color = sliderData.Color or Color3.fromRGB(170, 0, 255)
        local increment = sliderData.Increment or 1
        local valueName = sliderData.ValueName or "Value"
        local callback = sliderData.Callback or function() end
        
        local TweenService = game:GetService("TweenService")
        
        -- Container principal
        local sliderContainer = Instance.new("Frame")
        sliderContainer.Size = UDim2.new(1, 0, 0, 40)
        sliderContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        sliderContainer.LayoutOrder = #self.Container:GetChildren() + 1
        sliderContainer.Parent = self.Container
        
        -- Canto arredondado e borda roxa
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = sliderContainer
    
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(170, 0, 255)
        stroke.Thickness = 1
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = sliderContainer
        
        -- Label do slider
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -80, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.Gotham
        label.TextSize = 16
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = sliderContainer
        
        -- Caixa de valor
        local valueBox = Instance.new("TextLabel")
        valueBox.Size = UDim2.new(0, 60, 0, 24)
        valueBox.Position = UDim2.new(1, -70, 0.5, -12)
        valueBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        valueBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        valueBox.Text = tostring(default)
        valueBox.Font = Enum.Font.Gotham
        valueBox.TextSize = 14
        valueBox.TextXAlignment = Enum.TextXAlignment.Center
        valueBox.Parent = sliderContainer
        
        -- Definir borda da caixa de valor
        Instance.new("UICorner", valueBox).CornerRadius = UDim.new(0, 6)
        local valueStroke = Instance.new("UIStroke")
        valueStroke.Color = Color3.fromRGB(170, 0, 255)
        valueStroke.Thickness = 1
        valueStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        valueStroke.Parent = valueBox
        
        -- Barra do slider
        local sliderBar = Instance.new("Frame")
        sliderBar.Size = UDim2.new(1, -80, 0, 4)
        sliderBar.Position = UDim2.new(0, 10, 1, -10)
        sliderBar.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        sliderBar.Parent = sliderContainer
        
        -- Barra de preenchimento (com a cor)
        local fillBar = Instance.new("Frame")
        fillBar.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fillBar.BackgroundColor3 = color
        fillBar.Parent = sliderBar
        
        -- Bolinha do slider
        local ball = Instance.new("Frame")
        ball.Size = UDim2.new(0, 12, 0, 12)
        ball.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
        ball.BackgroundColor3 = color
        ball.BorderSizePixel = 0
        ball.AnchorPoint = Vector2.new(0.5, 0.5)
        ball.Parent = sliderBar
        
        Instance.new("UICorner", ball).CornerRadius = UDim.new(1, 0)
        
        -- FunÃ§Ã£o de atualizar o valor
        local function updateSlider(position)
            local newValue = math.clamp((position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            local newValueScaled = min + newValue * (max - min)
            local newValueRounded = math.floor(newValueScaled / increment + 0.5) * increment
            
            -- Atualizar bola, barra de preenchimento e caixa de valor
            ball.Position = UDim2.new(newValue, -6, 0.5, -6)
            fillBar.Size = UDim2.new(newValue, 0, 1, 0)
            valueBox.Text = tostring(newValueRounded)
            
            callback(newValueRounded)
        end
        
        -- Detectar arraste da bolinha
        local dragging = false
local UserInputService = game:GetService("UserInputService")

ball.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        local startPos = input.Position.X

        local conn
        conn = UserInputService.InputChanged:Connect(function(inputChanged)
            if dragging and (inputChanged.UserInputType == Enum.UserInputType.MouseMovement or inputChanged.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(inputChanged.Position)
            end
        end)

        -- Desconecta quando terminar o arraste
        local function stopDragging()
            dragging = false
            if conn then
                conn:Disconnect()
                conn = nil
            end
        end

        UserInputService.InputEnded:Connect(function(inputEnded)
            if inputEnded.UserInputType == Enum.UserInputType.MouseButton1 or inputEnded.UserInputType == Enum.UserInputType.Touch then
                stopDragging()
            end
        end)
    end
end)
        
        return sliderContainer
    end

		table.insert(Tabs, tab)
		return tab
	end

	return window
end

return ElixirLib
