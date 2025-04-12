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

	local leftPanel = Instance.new("ScrollingFrame")
	leftPanel.Size = UDim2.new(0, 180, 1, 0)
	leftPanel.Position = UDim2.new(0, 0, 0, 0)
	leftPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	leftPanel.ScrollBarThickness = 4
	leftPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
	leftPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
	leftPanel.ScrollingDirection = Enum.ScrollingDirection.Y
	leftPanel.Parent = contentFrame

	local uiList = Instance.new("UIListLayout")
	uiList.Padding = UDim.new(0, 5)
	uiList.SortOrder = Enum.SortOrder.LayoutOrder
	uiList.Parent = leftPanel

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

	local window = {}
	local Tabs = {}

	-- Função MakeTab (Criação da Aba)
function window:MakeTab(tabData)
    local tabName = tabData.Name or "Aba"
    local tabIcon = tabData.Icon or ""

    local tab = {}
    tab.Sections = {}

    -- Botão de aba
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.Text = ""
    button.AutoButtonColor = true
    button.LayoutOrder = #Tabs + 1
    button.Parent = leftPanel

    -- Ícone da aba
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 24, 0, 24)
    icon.Position = UDim2.new(0, 10, 0.5, -12)
    icon.BackgroundTransparency = 1
    icon.Image = tabIcon
    icon.Parent = button

    -- Nome da aba
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

    -- Adicionando bordas arredondadas e contorno ao botão
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(170, 0, 255)
    btnStroke.Thickness = 1
    btnStroke.Parent = button

    -- Função de clique na aba
    button.MouseButton1Click:Connect(function()
        -- Esconde os conteúdos de outras abas
        for _, t in pairs(Tabs) do
            if t.Container then
                t.Container.Visible = false
            end
        end

        -- Cria o conteúdo da aba, caso ainda não tenha sido criado
        if not tab.Container then
            local tabContent = Instance.new("ScrollingFrame")
            tabContent.Size = UDim2.new(1, 0, 1, 0)
            tabContent.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
            tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
            tabContent.ScrollBarThickness = 4
            tabContent.ScrollingDirection = Enum.ScrollingDirection.Y
            tabContent.Parent = rightPanel
            tab.Container = tabContent

            -- Layout e estética da aba
            local layout = Instance.new("UIListLayout")
            layout.Padding = UDim.new(0, 6)
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Parent = tabContent

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
            title.LayoutOrder = 0
            title.Parent = tabContent
        end

        -- Torna a aba visível
        tab.Container.Visible = true
    end)

    -- Agora você pode adicionar o toggle à aba
    window:AddToggle({
        Name = "Habilidade",
        Default = false,
        Callback = function(value)
            print("Habilidade ativada:", value)
        end
    }, tab)  -- Passando a aba para a função AddToggle

    -- Adiciona a aba à lista
    table.insert(Tabs, tab)
    return tab
end

-- Função AddToggle (Criação do Toggle dentro da Aba)
function window:AddToggle(toggleData, tab)
    local toggleName = toggleData.Name or "Toggle"  -- Nome do Toggle
    local default = toggleData.Default or false     -- Valor padrão
    local callback = toggleData.Callback            -- Função de retorno (callback)
    
    -- Cria o botão invisível (usado só para clique)
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 50, 0, 24)
    toggleButton.Position = UDim2.new(0.5, -25, 0, 0) -- Ajuste a posição conforme necessário
    toggleButton.AnchorPoint = Vector2.new(0.5, 0.5)
    toggleButton.BackgroundTransparency = 1
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.Parent = tab.Container  -- Agora o toggle é adicionado dentro da aba

    -- Cria o fundo do botão (visual com degradê)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "VisualFrame"
    toggleFrame.Size = UDim2.new(1, 0, 1, 0)
    toggleFrame.Position = UDim2.new(0, 0, 0, 0)
    toggleFrame.BackgroundTransparency = 0
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = toggleButton

    Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(1, 0)

    local frameStroke = Instance.new("UIStroke")
    frameStroke.Thickness = 2
    frameStroke.Color = Color3.fromRGB(100, 100, 100)
    frameStroke.Parent = toggleFrame

    local frameGradient = Instance.new("UIGradient")
    frameGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 130, 130))
    }
    frameGradient.Rotation = 0
    frameGradient.Parent = toggleFrame

    -- Cria a bolinha
    local ball = Instance.new("Frame")
    ball.Name = "Ball"
    ball.Size = UDim2.new(0, 20, 1, -4)
    ball.Position = UDim2.new(0, 2, 0, 2)
    ball.BackgroundTransparency = 1
    ball.BorderSizePixel = 0
    ball.Parent = toggleFrame

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
    ballGradient.Rotation = 0
    ballGradient.Parent = ball

    -- Variáveis
    local toggled = default
    local ballPadding = 2

    -- Cores
    local colorOffStroke = Color3.fromRGB(100, 100, 100)
    local strokeOn = Color3.fromRGB(255, 0, 255) -- Roxo neon

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

    -- Função de toggle
    toggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled

        local newPos = toggled and UDim2.new(1, -ball.Size.X.Offset - ballPadding, 0, ballPadding)
            or UDim2.new(0, ballPadding, 0, ballPadding)

        local strokeColor = toggled and strokeOn or colorOffStroke

        -- Animações
        TweenService:Create(ball, tweenInfo, { Position = newPos }):Play()
        TweenService:Create(ballStroke, tweenInfo, { Color = strokeColor }):Play()
        TweenService:Create(frameStroke, tweenInfo, { Color = strokeColor }):Play()

        -- Troca os degradês
        frameGradient.Color = toggled and gradientOn or gradientOff
        ballGradient.Color = toggled and ballGradientOn or ballGradientOff

        -- Chama o callback
        if callback then
            callback(toggled)
        end
    end)
end


	
	return window
end

return ElixirLib
