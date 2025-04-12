local TweenService = game:GetService("TweenService")

-- Tabela de abas
local Tabs = {}

function window:MakeTab(tabData)
    local tabName = tabData.Name or "Aba"
    local tabIcon = tabData.Icon or ""
  
    local tab = {}
    tab.Sections = {}

    -- Criação do botão da aba
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = UDim2.new(0, 10, 0, 10 + (#leftPanel:GetChildren() - 2) * 45)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.Text = ""
    button.AutoButtonColor = true
    button.Parent = leftPanel

    -- Ícone da aba
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 24, 0, 24)
    icon.Position = UDim2.new(0, 10, 0.5, -12)
    icon.BackgroundTransparency = 1
    icon.Image = tabIcon
    icon.Parent = button

    -- Texto da aba
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

    -- Corner e stroke do botão
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(170, 0, 255)
    btnStroke.Thickness = 1
    btnStroke.Parent = button

    -- Lógica de mostrar/ocultar a aba sem recriar
    button.MouseButton1Click:Connect(function()
        -- Esconde todas as outras abas
        for _, otherTab in pairs(Tabs) do
            if otherTab.Container then
                otherTab.Container.Visible = false
            end
        end

        -- Cria a aba se ainda não existir
        if not tab.Container then
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
            title.Text = tabName
            title.TextColor3 = Color3.fromRGB(200, 200, 255)
            title.Font = Enum.Font.GothamBold
            title.TextSize = 24
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = tabContent

            tab.Container = tabContent
        end

        -- Mostra a aba atual
        tab.Container.Visible = true
    end)

    -- Função AddToggle dentro da aba
    function tab:AddToggle(data)
        local toggleName = data.Name or "Toggle"
        local defaultState = data.Default or false
        local callback = data.Callback or function() end

        local toggleButton = Instance.new("TextButton")
        toggleButton.Name = toggleName
        toggleButton.Size = UDim2.new(0, 50, 0, 24)
        toggleButton.BackgroundTransparency = 1
        toggleButton.BorderSizePixel = 0
        toggleButton.Text = ""
        toggleButton.Parent = tab.Container

        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = "VisualFrame"
        toggleFrame.Size = UDim2.new(1, 0, 1, 0)
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
        frameGradient.Parent = toggleFrame

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
        ballGradient.Parent = ball

        -- Cores e animações
        local toggled = defaultState
        local ballPadding = 2
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        local colorOffStroke = Color3.fromRGB(100, 100, 100)
        local strokeOn = Color3.fromRGB(255, 0, 255)

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

        -- Atualiza visual
        local function updateVisual()
            local newPos = toggled and UDim2.new(1, -ball.Size.X.Offset - ballPadding, 0, ballPadding)
                or UDim2.new(0, ballPadding, 0, ballPadding)

            local strokeColor = toggled and strokeOn or colorOffStroke

            TweenService:Create(ball, tweenInfo, { Position = newPos }):Play()
            TweenService:Create(ballStroke, tweenInfo, { Color = strokeColor }):Play()
            TweenService:Create(frameStroke, tweenInfo, { Color = strokeColor }):Play()

            frameGradient.Color = toggled and gradientOn or gradientOff
            ballGradient.Color = toggled and ballGradientOn or ballGradientOff
        end

        -- Aplica valor padrão
        updateVisual()
        callback(toggled)

        toggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            updateVisual()
            callback(toggled)
        end)
    end

    -- Adiciona a aba à lista de abas
    table.insert(Tabs, tab)
    return tab
end
