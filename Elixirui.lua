local ElixirLib = {}

function ElixirLib:MakeWindow(windowData)
	local window = {}
	local Tabs = {}

	local ScreenGui = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
	ScreenGui.Name = "ElixirUI"

	local mainFrame = Instance.new("Frame", ScreenGui)
	mainFrame.Size = UDim2.new(0, 600, 0, 400)
	mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
	mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

	local uiCorner = Instance.new("UICorner", mainFrame)
	uiCorner.CornerRadius = UDim.new(0, 12)

	local leftPanel = Instance.new("Frame", mainFrame)
	leftPanel.Size = UDim2.new(0, 150, 1, 0)
	leftPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

	local rightPanel = Instance.new("Frame", mainFrame)
	rightPanel.Size = UDim2.new(1, -160, 1, -20)
	rightPanel.Position = UDim2.new(0, 160, 0, 10)
	rightPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

	local listLayout = Instance.new("UIListLayout", leftPanel)
	listLayout.Padding = UDim.new(0, 6)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder

	function window:MakeTab(tabData)
		local tabName = tabData.Name or "Aba"
		local tabIcon = tabData.Icon or ""

		local tab = {}
		tab.Sections = {}

		local button = Instance.new("TextButton")
		button.Size = UDim2.new(1, -20, 0, 40)
		button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		button.Text = ""
		button.AutoButtonColor = true
		button.LayoutOrder = #Tabs + 1
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

		local btnCorner = Instance.new("UICorner", button)
		btnCorner.CornerRadius = UDim.new(0, 8)

		local btnStroke = Instance.new("UIStroke", button)
		btnStroke.Color = Color3.fromRGB(170, 0, 255)
		btnStroke.Thickness = 1

		-- CRIA O CONTAINER DA ABA JÁ AQUI
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

		local layout = Instance.new("UIListLayout", tabContent)
		layout.Padding = UDim.new(0, 6)
		layout.SortOrder = Enum.SortOrder.LayoutOrder

		local corner = Instance.new("UICorner", tabContent)
		corner.CornerRadius = UDim.new(0, 12)

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

		function tab:AddToggle(toggleData)
			local toggleName = toggleData.Name or "Toggle"
			local default = toggleData.Default or false
			local callback = toggleData.Callback or function() end

			local toggleButton = Instance.new("TextButton")
			toggleButton.Size = UDim2.new(1, 0, 0, 40)
			toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			toggleButton.Text = ""
			toggleButton.AutoButtonColor = true
			toggleButton.Parent = tab.Container

			local toggleLabel = Instance.new("TextLabel")
			toggleLabel.Size = UDim2.new(1, -30, 1, 0)
			toggleLabel.Position = UDim2.new(0, 10, 0, 0)
			toggleLabel.BackgroundTransparency = 1
			toggleLabel.Text = toggleName
			toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			toggleLabel.Font = Enum.Font.Gotham
			toggleLabel.TextSize = 16
			toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
			toggleLabel.Parent = toggleButton

			local toggleSwitch = Instance.new("TextButton")
			toggleSwitch.Size = UDim2.new(0, 40, 0, 20)
			toggleSwitch.Position = UDim2.new(1, -50, 0.5, -10)
			toggleSwitch.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
			toggleSwitch.Text = ""
			toggleSwitch.Parent = toggleButton

			local switchCorner = Instance.new("UICorner", toggleSwitch)
			switchCorner.CornerRadius = UDim.new(0, 10)

			toggleButton.MouseButton1Click:Connect(function()
				default = not default
				toggleSwitch.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
				callback(default)
			end)
		end

		Tabs[tabName] = tab
		return tab
	end

	return window
end

return ElixirLib
