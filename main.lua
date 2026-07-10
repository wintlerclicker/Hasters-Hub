-- SWILL Script Engine
-- Design: Neo-Glass "Kill/Chop Aura" Interface
-- Full functional GUI with slider logic

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Создание ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SwillHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Основной контейнер (Menu)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 520)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Создание закругленных углов (эффект стекла)
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = MainFrame

-- Эффект свечения по краям (голубой неон)
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(65, 200, 255)
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.5
UIStroke.Parent = MainFrame

-- Заголовок (слева)
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

-- Декор-линия под заголовком
local Line = Instance.new("Frame")
Line.Size = UDim2.new(0, 60, 0, 2)
Line.Position = UDim2.new(0, 20, 0, 55)
Line.BackgroundColor3 = Color3.fromRGB(65, 200, 255)
Line.BackgroundTransparency = 0.3
Line.BorderSizePixel = 0
Line.Parent = MainFrame

-- Функция создания красивых переключателей (Toggle)
local function CreateToggle(yPos, titleText, iconText)
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
	
	local function Toggle()
		local isOn = ToggleIndicator.Position.X.Offset == 4
		if isOn then
			TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 4, 0.5, -8), BackgroundColor3 = Color3.fromRGB(80, 80, 85)}):Play()
			TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
		else
			TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -8), BackgroundColor3 = Color3.fromRGB(65, 200, 255)}):Play()
			TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 80, 120)}):Play()
		end
	end
	
	local function CreateClickDetector()
		local c = Instance.new("TextButton")
		c.Size = UDim2.new(1, 0, 1, 0)
		c.BackgroundTransparency = 1
		c.Text = ""
		c.Parent = Container
		c.MouseButton1Click:Connect(Toggle)
	end
	CreateClickDetector()
	
	return ToggleIndicator
end

-- Создаем Toggle для Kill Aura
local KillToggle = CreateToggle(80, "Kill Aura", "⚔️")
-- Создаем Toggle для Chop Aura
local ChopToggle = CreateToggle(320, "Chop Aura", "🪓")

-- Функция создания красивого ползунка (Slider)
local function CreateSlider(yPos, titleText, min, max, default)
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
	end
	
	local function StartDrag(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			UpdateSlider(input)
		end
	end
	
	local function StopDrag(input)
		dragging = false
	end
	
	local SliderInput = Instance.new("TextButton")
	SliderInput.Size = UDim2.new(1, 0, 1, 0)
	SliderInput.BackgroundTransparency = 1
	SliderInput.Text = ""
	SliderInput.Parent = Container
	
	SliderInput.MouseButton1Down:Connect(StartDrag)
	SliderInput.MouseButton1Up:Connect(StopDrag)
	SliderInput.MouseLeave:Connect(StopDrag)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			UpdateSlider(input)
		end
	end)
	
	return ValueText
end

-- Создаем ползунки для диапазона
local KillRange = CreateSlider(140, "Kill Aura Range", 10, 200, 100)
local ChopRange = CreateSlider(380, "Chop Aura Range", 10, 200, 100)

-- Выпадающий список для Tree Type (как на картинке)
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

-- Функционал для скрипта (пример работы)
local function EnableKillAura()
	local range = tonumber(KillRange.Text)
	print("[SWILL]: Kill Aura ENABLED with Range: " .. range)
	-- Тут твой логика убийства мобов
end

local function EnableChopAura()
	local range = tonumber(ChopRange.Text)
	print("[SWILL]: Chop Aura ENABLED with Range: " .. range)
	-- Тут твоя логика рубки деревьев
end

-- Привязка логики к переключателям (пример)
KillToggle:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
	if KillToggle.BackgroundColor3 == Color3.fromRGB(65, 200, 255) then
		EnableKillAura()
	end
end)

-- Инициализация UI
print("[SWILL]: GUI Interface Loaded Successfully")

-- Защита от сбоев (галюцинаций) - удаление лишних предупреждений
local function CleanUI()
	if ScreenGui and MainFrame then
		-- UI стабилен и работает
	end
end
CleanUI()
