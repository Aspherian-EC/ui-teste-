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

    -- Criando o novo LeftPanel com estilo aprimorado
    local oldLeftPanel = mainFrame:FindFirstChild("LeftPanel")
    if oldLeftPanel then
        oldLeftPanel:Destroy()
    end

    local newLeftPanel = Instance.new("ScrollingFrame")
    newLeftPanel.Name = "LeftPanel"
    newLeftPanel.Size = UDim2.new(0, 180, 1, 0)  -- Largura 180px e altura cheia
    newLeftPanel.Position = UDim2.new(0, 0, 0, 0)  -- No canto esquerdo
    newLeftPanel.BackgroundColor3 = Color3.fromRGB(33, 33, 33)  -- Tom de cinza escuro
    newLeftPanel.BorderSizePixel = 0  -- Sem borda visível
    newLeftPanel.ScrollBarThickness = 8  -- ScrollBar mais grosso
    newLeftPanel.ScrollingDirection = Enum.ScrollingDirection.Y  -- Rolagem vertical
    newLeftPanel.CanvasSize = UDim2.new(0, 0, 0, 0)  -- Canvas ajustável
    newLeftPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y  -- Ajuste automático da altura com o conteúdo
    newLeftPanel.Parent = contentFrame  -- Adicionando ao contentFrame

    -- Adicionando um fundo suave com bordas arredondadas
    local leftPanelCorner = Instance.new("UICorner")
    leftPanelCorner.CornerRadius = UDim.new(0, 12)  -- Bordas arredondadas
    leftPanelCorner.Parent = newLeftPanel

    -- Adicionando um efeito de borda com sombra
    local leftPanelStroke = Instance.new("UIStroke")
    leftPanelStroke.Color = Color3.fromRGB(170, 0, 255)  -- Cor da borda em roxo
    leftPanelStroke.Thickness = 3  -- Borda mais grossa
    leftPanelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border  -- Borda aplicada
    leftPanelStroke.Parent = newLeftPanel

    -- Adicionando um efeito de sombra (componente separado)
    local leftPanelShadow = Instance.new("Frame")
    leftPanelShadow.Name = "Shadow"
    leftPanelShadow.Size = UDim2.new(1, 0, 1, 0)  -- O mesmo tamanho que o painel
    leftPanelShadow.Position = UDim2.new(0, 5, 0, 5)  -- Deslocando para dar o efeito de sombra
    leftPanelShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Cor da sombra
    leftPanelShadow.BackgroundTransparency = 0.5  -- Tornar a sombra semi-transparente
    leftPanelShadow.ZIndex = -1  -- Colocando atrás do painel
    leftPanelShadow.Parent = newLeftPanel

    -- Adicionando layout para organizar os itens de forma vertical
    local newUIListLayout = Instance.new("UIListLayout")
    newUIListLayout.Padding = UDim.new(0, 10)  -- Espaçamento de 10 pixels entre os itens
    newUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    newUIListLayout.Parent = newLeftPanel

    -- Função de minimizar a UI
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
    floatButton.Image = "rbxassetid://10738425363"
    floatButton.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = floatButton

    floatButton.MouseButton1Click:Connect(toggleUI)
end

return ElixirLib
