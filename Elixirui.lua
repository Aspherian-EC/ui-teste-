local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local ElixirLib = {}
ElixirLib.Configs = {}
ElixirLib.Folder = "ElixirClient" -- padrão

-- Função para carregar configuração
local function loadConfig(folder)
	local success, result = pcall(function()
		return isfile(folder..".json") and HttpService:JSONDecode(readfile(folder..".json")) or {}
	end)
	return success and result or {}
end

-- Função para salvar configuração
local function saveConfig(folder, data)
	if writefile then
		writefile(folder..".json", HttpService:JSONEncode(data))
	end
end

-- Criar Window
function ElixirLib:MakeWindow(options)
	local window = {}
	local name = options.Name or "Elixir UI"
	local hidePremium = options.HidePremium or false
	local saveConfig = options.SaveConfig or false
	local configFolder = options.ConfigFolder or "ElixirClient"

	ElixirLib.Folder = configFolder
	if saveConfig then
		ElixirLib.Configs = loadConfig(configFolder)
	end

	-- Frame principal
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

-- TopBar
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 12)
topBarCorner.Parent = topBar

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Elixir Client"
titleLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- Botão de minimizar na TopBar
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

-- Divisor neon
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

-- Área de conteúdo
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, 0, 1, -42)
contentFrame.Position = UDim2.new(0, 0, 0, 42)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Painel lateral esquerdo onde os botoes de tab vao ficar 
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

-- Painel da  direita onde botoes toggles dropdowns deve ficar 
local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(1, -180, 1, 0)
rightPanel.Position = UDim2.new(0, 180, 0, 0)
rightPanel.BackgroundTransparency = 1
rightPanel.Parent = contentFrame

-- Função unificada para minimizar/restaurar
local function toggleUI()
	isMinimized = not isMinimized
	mainFrame.Visible = not isMinimized
	if isMinimized then
		showNotification("Pressione RightShift ou use o botão flutuante para abrir.")
	end
end

-- Tecla RightShift
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
		toggleUI()
	end
end)

-- Clique no botão da TopBar
minimizeButton.MouseButton1Click:Connect(toggleUI)

-- Drag da MainFrame (TopBar)
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


-- Botão flutuante (mobile-friendly) vminimizavel
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

-- Drag do botão flutuante (FloatButton)
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


-- Botão flutuante funcional
floatButton.MouseButton1Click:Connect(toggleUI)

local Window = {}
local Tabs = {}

function Window:MakeTab(tabData)
	local tabName = tabData.Name or "Aba"
	local tabIcon = tabData.Icon or ""
	local premiumOnly = tabData.PremiumOnly or false

	local tab = {}
	tab.Sections = {}

	-- Criar botão no painel esquerdo
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

	-- Função ao clicar na aba
	button.MouseButton1Click:Connect(function()
		rightPanel:ClearAllChildren()

		local tabContent = Instance.new("Frame")
		tabContent.Size = UDim2.new(1, 0, 1, 0)
		tabContent.BackgroundTransparency = 0
		tabContent.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		tabContent.Parent = rightPanel

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 12)
		corner.Parent = tabContent

		local title = Instance.new("TextLabel")
		title.Size = UDim2.new(1, -20, 0, 50)
		title.Position = UDim2.new(0, 10, 0, 10)
		title.BackgroundTransparency = 1
		title.Text = "" .. tabName
		title.TextColor3 = Color3.fromRGB(200, 200, 255)
		title.Font = Enum.Font.GothamBold
		title.TextSize = 24
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = tabContent

		-- Guardar o conteúdo do painel pro tab (se quiser adicionar futuramente elementos dentro dele)
		tab.Container = tabContent
	end)

	-- Registrar a aba
	table.insert(Tabs, tab)
	return tab
end

	return window
end

return ElixirLib
