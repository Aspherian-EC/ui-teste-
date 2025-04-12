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

	function window:MakeTab(tabData)
		local tabName = tabData.Name or "Aba"
		local tabIcon = tabData.Icon or ""
		local tab = {}
		tab.Sections = {}
	
		local button = Instance.new("TextButton")
		-- ... estilo do botão da aba ...
		button.Parent = leftPanel
	
		-- Criar container da aba **imediatamente**
		local tabContent = Instance.new("ScrollingFrame")
		tabContent.Size = UDim2.new(1, 0, 1, 0)
		tabContent.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
		tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
		tabContent.ScrollBarThickness = 4
		tabContent.ScrollingDirection = Enum.ScrollingDirection.Y
		tabContent.Visible = false
		tabContent.Parent = rightPanel
		tab.Container = tabContent
	
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
	
		button.MouseButton1Click:Connect(function()
			for _, t in pairs(Tabs) do
				if t.Container then
					t.Container.Visible = false
				end
			end
			tab.Container.Visible = true
		end)
	
		table.insert(Tabs, tab)
		return tab
	end
	
	function tab:AddToggle(data)
		local template = game.ReplicatedStorage:WaitForChild("ToggleTemplate")
		local toggleClone = template:Clone()
		toggleClone.Parent = tab.Container
	
		local toggled = data.Default or false
		local callback = data.Callback or function() end
		local button = toggleClone -- já é um TextButton
		local frame = toggleClone:WaitForChild("VisualFrame")
		local ball = frame:WaitForChild("Ball")
	
		local frameStroke = frame:FindFirstChildOfClass("UIStroke")
		local frameGradient = frame:FindFirstChildOfClass("UIGradient")
		local ballStroke = ball:FindFirstChildOfClass("UIStroke")
		local ballGradient = ball:FindFirstChildOfClass("UIGradient")
	
		local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local ballPadding = 2
	
		-- Define valores iniciais
		local function updateVisual()
			local pos = toggled and UDim2.new(1, -ball.Size.X.Offset - ballPadding, 0, ballPadding)
				or UDim2.new(0, ballPadding, 0, ballPadding)
	
			local strokeColor = toggled and Color3.fromRGB(255, 0, 255) or Color3.fromRGB(100, 100, 100)
	
			TweenService:Create(ball, tweenInfo, { Position = pos }):Play()
			TweenService:Create(ballStroke, tweenInfo, { Color = strokeColor }):Play()
			TweenService:Create(frameStroke, tweenInfo, { Color = strokeColor }):Play()
	
			frameGradient.Color = toggled and ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 0, 120)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 80, 255))
			} or ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 130, 130))
			}
	
			ballGradient.Color = toggled and ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 0, 130)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 100, 255))
			} or ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 80))
			}
		end
	
		updateVisual()
	
		-- Evento de clique
		button.MouseButton1Click:Connect(function()
			toggled = not toggled
			updateVisual()
			callback(toggled)
		end)
	end
	
	return window
end

return ElixirLib
