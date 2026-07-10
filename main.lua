-- SWILL Script Engine v2.0
-- Full Functional Neo-Glass UI + Working Logic
-- Design: Kill / Chop Aura with Sliders, Toggles & Dropdowns

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ==========================================
-- ПЕРЕМЕННЫЕ СОСТОЯНИЯ (ЛОГИКА)
-- ==========================================
local KillAuraEnabled = false
local ChopAuraEnabled = false
local KillRangeValue = 100
local ChopRangeValue = 100
local SelectedTreeType = "Small Tree" -- Default

-- ==========================================
-- ИНТЕРФЕЙС (GUI) - Нео-стекло
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SwillHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 520)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(65, 200, 255)
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.5
UIStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 150, 0, 40)
Title.Position = UDim2.new(0, 20, 0, 15)
Title.BackgroundTransparency = 1
Title.Text = "SWILL AURA"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local Line = Instance.new("Frame")
Line.Size = UDim2.new(0, 60, 0, 2)
Line.Position = UDim2.new(0, 20, 0, 55)
Line.BackgroundColor3 = Color3.fromRGB(65, 200, 255)
Line.BackgroundTransparency = 0.3
Line.BorderSizePixel = 0
Line.Parent = MainFrame

-- ==========================================
-- ФУНКЦИЯ СОЗДАНИЯ ТОГГЛОВ
-- ==========================================
local function CreateToggle(yPos, titleText, iconText, callback)
	local Container = Instance.new("Frame")
	Container.Size = UDim2.new(1, -40, 0, 50)
	Container.Position = UDim2.new(0, 20, 0, yPos)
	Container.BackgroundTransparency = 1
	Container.Parent = MainFrame
	
	local Icon = Instance.new("TextLabel")
	Icon.Size = UDim2.new(0, 30, 0, 30)
	Icon.Position = UDim2.new(0, 0, 0.5, -15)
	Icon.BackgroundTransparency = 1
	Icon.Text = iconText
	Icon.TextColor3 = Color3.fromRGB(150, 200, 255)
	Icon.Font = Enum.Font.GothamBold
	Icon.TextSize = 20
	Icon.Parent = Container
	
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0, 150, 0, 30)
	Label.Position = UDim2.new(0, 40, 0.5, -15)
	Label.BackgroundTransparency = 1
	Label.Text = titleText
	Label.TextColor3 = Color3.fromRGB(220, 220, 220)
	Label.Font = Enum.Font.GothamMedium
	Label.TextSize = 16
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Container
	
	local ToggleBtn = Instance.new("Frame")
	ToggleBtn.Size = UDim2.new(0, 40, 0, 22)
	ToggleBtn.Position = UDim2.new(1, -40, 0.5, -11)
	ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
	ToggleBtn.BackgroundTransparency = 0.5
	ToggleBtn.Parent = Container
	
	local ToggleCorner = Instance.new("UICorner")
	ToggleCorner.CornerRadius = UDim.new(1, 0)
	ToggleCorner.Parent = ToggleBtn
	
	local ToggleIndicator = Instance.new("Frame")
	ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
	ToggleIndicator.Position = UDim2.new(0, 4, 0.5, -8)
	ToggleIndicator.BackgroundColor3 = Color3.fromRGB(80, 80, 85)
	ToggleIndicator.Parent = ToggleBtn
	
	local ToggleIndCorner = Instance.new("UICorner")
	ToggleIndCorner.CornerRadius = UDim.new(1, 0)
	ToggleIndCorner.Parent = ToggleIndicator
	
	local isOn = false
	local function Toggle()
		isOn = not isOn
		if isOn then
			TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -8), BackgroundColor3 = Color3.fromRGB(65, 200, 255)}):Play()
			TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 80, 120)}):Play()
		else
			TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 4, 0.5, -8), BackgroundColor3 = Color3.fromRGB(80, 80, 85)}):Play()
			TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
		end
		if callback then callback(isOn) end
	end
	
	local c = Instance.new("TextButton")
	c.Size = UDim2.new(1, 0, 1, 0)
	c.BackgroundTransparency = 1
	c.Text = ""
	c.Parent = Container
	c.MouseButton1Click:Connect(Toggle)
	
	return ToggleIndicator
end

-- ==========================================
-- ФУНКЦИЯ СОЗДАНИЯ ПОЛЗУНКОВ
-- ==========================================
local function CreateSlider(yPos, titleText, min, max, default, callback)
	local Container = Instance.new("Frame")
	Container.Size = UDim2.new(1, -40, 0, 60)
	Container.Position = UDim2.new(0, 20, 0, yPos)
	Container.BackgroundTransparency = 1
	Container.Parent = MainFrame
	
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0, 150, 0, 20)
	Label.Position = UDim2.new(0, 0, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = titleText
	Label.TextColor3 = Color3.fromRGB(220, 220, 220)
	Label.Font = Enum.Font.GothamMedium
	Label.TextSize = 14
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Container
	
	local ValueText = Instance.new("TextLabel")
	ValueText.Size = UDim2.new(0, 40, 0, 20)
	ValueText.Position = UDim2.new(1, -40, 0, 0)
	ValueText.BackgroundTransparency = 1
	ValueText.Text = tostring(default)
	ValueText.TextColor3 = Color3.fromRGB(65, 200, 255)
	ValueText.Font = Enum.Font.GothamBold
	ValueText.TextSize = 14
	ValueText.TextXAlignment = Enum.TextXAlignment.Right
	ValueText.Parent = Container
	
	local SliderBg = Instance.new("Frame")
	SliderBg.Size = UDim2.new(1, 0, 0, 6)
	SliderBg.Position = UDim2.new(0, 0, 0, 30)
	SliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	SliderBg.BackgroundTransparency = 0.5
	SliderBg.Parent = Container
	
	local SliderCorner = Instance.new("UICorner")
	SliderCorner.CornerRadius = UDim.new(1, 0)
	SliderCorner.Parent = SliderBg
	
	local SliderFill = Instance.new("Frame")
	SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	SliderFill.BackgroundColor3 = Color3.fromRGB(65, 200, 255)
	SliderFill.BackgroundTransparency = 0.5
	SliderFill.Parent = SliderBg
	
	local FillCorner = Instance.new("UICorner")
	FillCorner.CornerRadius = UDim.new(1, 0)
	FillCorner.Parent = SliderFill
	
	local DragBtn = Instance.new("Frame")
	DragBtn.Size = UDim2.new(0, 14, 0, 14)
	DragBtn.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
	DragBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DragBtn.Parent = SliderBg
	
	local DragCorner = Instance.new("UICorner")
	DragCorner.CornerRadius = UDim.new(1, 0)
	DragCorner.Parent = DragBtn
	
	local dragging = false
	
	local function UpdateSlider(input)
		local posX = math.clamp(input.Position.X - SliderBg.AbsolutePosition.X, 0, SliderBg.AbsoluteSize.X)
		local percent = posX / SliderBg.AbsoluteSize.X
		local value = math.floor(min + (max - min) * percent)
		
		SliderFill:TweenSize(UDim2.new(percent, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
		DragBtn:TweenPosition(UDim2.new(percent, -7, 0.5, -7), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
		ValueText.Text = tostring(value)
		if callback then callback(value) end
	end
	
	local SliderInput = Instance.new("TextButton")
	SliderInput.Size = UDim2.new(1, 0, 1, 0)
	SliderInput.BackgroundTransparency = 1
	SliderInput.Text = ""
	SliderInput.Parent = Container
	
	SliderInput.MouseButton1Down:Connect(function(input)
		dragging = true
		UpdateSlider(input)
	end)
	SliderInput.MouseButton1Up:Connect(function() dragging = false end)
	SliderInput.MouseLeave:Connect(function() dragging = false end)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			UpdateSlider(input)
		end
	end)
	
	return ValueText
end

-- ==========================================
-- ВЫПАДАЮЩИЙ СПИСОК (Дропдаун)
-- ==========================================
local DropdownY = 440
local DropdownContainer = Instance.new("Frame")
DropdownContainer.Size = UDim2.new(1, -40, 0, 40)
DropdownContainer.Position = UDim2.new(0, 20, 0, DropdownY)
DropdownContainer.BackgroundTransparency = 1
DropdownContainer.Parent = MainFrame

local DropdownLabel = Instance.new("TextLabel")
DropdownLabel.Size = UDim2.new(0, 100, 0, 20)
DropdownLabel.Position = UDim2.new(0, 0, 0.5, -10)
DropdownLabel.BackgroundTransparency = 1
DropdownLabel.Text = "Tree Type"
DropdownLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
DropdownLabel.Font = Enum.Font.GothamMedium
DropdownLabel.TextSize = 14
DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
DropdownLabel.Parent = DropdownContainer

local DropdownBox = Instance.new("Frame")
DropdownBox.Size = UDim2.new(0, 160, 0, 30)
DropdownBox.Position = UDim2.new(1, -160, 0.5, -15)
DropdownBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
DropdownBox.BackgroundTransparency = 0.5
DropdownBox.Parent = DropdownContainer

local DropdownCorner = Instance.new("UICorner")
DropdownCorner.CornerRadius = UDim.new(0, 6)
DropdownCorner.Parent = DropdownBox

local DropdownText = Instance.new("TextLabel")
DropdownText.Size = UDim2.new(1, -40, 1, 0)
DropdownText.Position = UDim2.new(0, 10, 0, 0)
DropdownText.BackgroundTransparency = 1
DropdownText.Text = "Small Tree"
DropdownText.TextColor3 = Color3.fromRGB(255, 255, 255)
DropdownText.Font = Enum.Font.GothamMedium
DropdownText.TextSize = 14
DropdownText.TextXAlignment = Enum.TextXAlignment.Left
DropdownText.Parent = DropdownBox

local DropdownArrow = Instance.new("TextLabel")
DropdownArrow.Size = UDim2.new(0, 20, 0, 20)
DropdownArrow.Position = UDim2.new(1, -25, 0.5, -10)
DropdownArrow.BackgroundTransparency = 1
DropdownArrow.Text = "▾"
DropdownArrow.TextColor3 = Color3.fromRGB(150, 150, 150)
DropdownArrow.Font = Enum.Font.GothamBold
DropdownArrow.TextSize = 16
DropdownArrow.Parent = DropdownBox

-- Функционал дропдауна
local TreeOptions = {"Small Tree", "Big Tree", "Palm Tree", "Oak Tree"}
local DropdownBtn = Instance.new("TextButton")
DropdownBtn.Size = UDim2.new(1, 0, 1, 0)
DropdownBtn.BackgroundTransparency = 1
DropdownBtn.Text = ""
DropdownBtn.Parent = DropdownBox

local DropdownMenu = Instance.new("Frame")
DropdownMenu.Size = UDim2.new(1, 0, 0, #TreeOptions * 30)
DropdownMenu.Position = UDim2.new(0, 0, 1, 5)
DropdownMenu.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
DropdownMenu.BackgroundTransparency = 0.2
DropdownMenu.Visible = false
DropdownMenu.Parent = DropdownBox
local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 8)
MenuCorner.Parent = DropdownMenu

local menuOpen = false
DropdownBtn.MouseButton1Click:Connect(function()
	menuOpen = not menuOpen
	DropdownMenu.Visible = menuOpen
end)

for i, option in ipairs(TreeOptions) do
	local optBtn = Instance.new("TextButton")
	optBtn.Size = UDim2.new(1, 0, 0, 30)
	optBtn.Position = UDim2.new(0, 0, 0, (i-1)*30)
	optBtn.BackgroundTransparency = 1
	optBtn.Text = option
	optBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
	optBtn.Font = Enum.Font.GothamMedium
	optBtn.TextSize = 14
	optBtn.Parent = DropdownMenu
	
	optBtn.MouseButton1Click:Connect(function()
		DropdownText.Text = option
		SelectedTreeType = option
		DropdownMenu.Visible = false
		menuOpen = false
	end)
end

-- ==========================================
-- РЕАЛЬНАЯ ЛОГИКА (УБИЙСТВО И РУБКА)
-- ==========================================
local function FindClosestTarget(range, isTree)
	local closest = nil
	local closestDist = range
	local rootPos = RootPart.Position
	
	for _, obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
			local part = obj.HumanoidRootPart
			local dist = (rootPos - part.Position).Magnitude
			if dist < closestDist and obj ~= Character then
				if isTree then
					-- Логика поиска деревьев (по имени или наличию деревянной текстуры)
					if obj.Name:find(SelectedTreeType) or obj.Name:find("Tree") then
						closest = obj
						closestDist = dist
					end
				else
					-- Логика поиска врагов (не игрок, не дерево, имеет Humanoid)
					local hum = obj:FindFirstChild("Humanoid")
					if hum and hum.Health > 0 and obj.Name ~= "Tree" and not obj.Name:find("Tree") then
						closest = obj
						closestDist = dist
					end
				end
			end
		end
	end
	return closest
end

local function KillLogic()
	if not KillAuraEnabled then return end
	local target = FindClosestTarget(KillRangeValue, false)
	if target then
		local hum = target:FindFirstChild("Humanoid")
		if hum then
			hum.Health = 0 -- Мгновенное убийство
			-- Альтернатива для некоторых игр: target:BreakJoints()
		end
	end
end

local function ChopLogic()
	if not ChopAuraEnabled then return end
	local tree = FindClosestTarget(ChopRangeValue, true)
	if tree then
		-- Удаляем дерево (эмуляция рубки)
		local part = tree:FindFirstChild("HumanoidRootPart") or tree:FindFirstChildWhichIsA("BasePart")
		if part then
			part:Destroy() -- Или используй разбивку на части
		end
	end
end

-- ==========================================
-- ПРИВЯЗКА ИНТЕРФЕЙСА К ЛОГИКЕ
-- ==========================================
local function UpdateKillToggle(state)
	KillAuraEnabled = state
	print("[SWILL]: Kill Aura " .. (state and "ENABLED" or "DISABLED") .. " | Range: " .. KillRangeValue)
end

local function UpdateChopToggle(state)
	ChopAuraEnabled = state
	print("[SWILL]: Chop Aura " .. (state and "ENABLED" or "DISABLED") .. " | Range: " .. ChopRangeValue)
end

local function UpdateKillRange(val)
	KillRangeValue = val
end

local function UpdateChopRange(val)
	ChopRangeValue = val
end

-- Создание элементов с привязкой колбэков
CreateToggle(80, "Kill Aura", "⚔️", UpdateKillToggle)
CreateToggle(320, "Chop Aura", "🪓", UpdateChopToggle)
CreateSlider(140, "Kill Aura Range", 10, 200, 100, UpdateKillRange)
CreateSlider(380, "Chop Aura Range", 10, 200, 100, UpdateChopRange)

-- ==========================================
-- ГЛАВНЫЙ ЦИКЛ (ОБНОВЛЕНИЕ КАЖДЫЙ КАДР)
-- ==========================================
RunService.RenderStepped:Connect(function()
	-- Обновляем логику каждые 0.1 секунды для оптимизации
	task.wait(0.1)
	
	-- Проверка на смерть персонажа и перезагрузку
	if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		return
	end
	
	KillLogic()
	ChopLogic()
end)

print("[SWILL]: Enhanced GUI + Logic Loaded Successfully")
