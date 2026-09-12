--[=[
	Painel Compacto Estilo Hub Clássico com Ícone Flutuante (Taça Dourada)
	CONVERTIDO PARA DELTA EXECUTOR
	Preservando todas as funções, identidade [Use sparingly.] e Brookhaven.
]=]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Conexão automática ao respawnar
player.CharacterAdded:Connect(function(char)
	character = char
end)

-- Evita duplicatas
local playerGui = player:WaitForChild("PlayerGui")
local existingGui = playerGui:FindFirstChild("FloatingHubGui")
if existingGui then
	existingGui:Destroy()
end

-- ScreenGui Principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FloatingHubGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

--------------------------------------------------------------------------------
-- 1 & 3. ÍCONE FLUTUANTE (TAÇA DOURADA) COM ARRASTO LIVRE
--------------------------------------------------------------------------------
local iconButton = Instance.new("ImageButton")
iconButton.Name = "FloatingIcon"
iconButton.Size = UDim2.new(0, 55, 0, 55)
iconButton.Position = UDim2.new(0, 30, 0.4, 0)
iconButton.BackgroundTransparency = 1
-- IMPORTANTE: Substitua abaixo pelo ID da imagem da taça dourada
iconButton.Image = "rbxassetid://14731149436" -- ID de taça genérica
iconButton.Active = true
iconButton.Parent = screenGui

-- Efeito visual ao passar o mouse
iconButton.MouseEnter:Connect(function()
	TweenService:Create(iconButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 62, 0, 62)}):Play()
end)
iconButton.MouseLeave:Connect(function()
	TweenService:Create(iconButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 55, 0, 55)}):Play()
end)

-- Lógica de Arrastar o Ícone
local draggingIcon = false
local iconDragInput, iconStartPos, iconStartMousePos

iconButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingIcon = true
		iconStartMousePos = input.Position
		iconStartPos = iconButton.AbsolutePosition
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				draggingIcon = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if draggingIcon and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - iconStartMousePos
		iconButton.Position = UDim2.new(
			0, iconStartPos.X + delta.X,
			0, iconStartPos.Y + delta.Y
		)
	end
end)

--------------------------------------------------------------------------------
-- JANELA PRINCIPAL DO HUB (REDIMENSIONÁVEL E COM ARRASTO)
--------------------------------------------------------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 520, 0, 310)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -155)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 4)
mainCorner.Parent = mainFrame

-- Abrir e Fechar com Animação
local isOpen = false
local isAnimating = false

iconButton.MouseButton1Click:Connect(function()
	if isAnimating then return end
	isAnimating = true
	
	if not isOpen then
		isOpen = true
		mainFrame.Visible = true
		mainFrame.Size = UDim2.new(0, 100, 0, 50)
		mainFrame.BackgroundTransparency = 1
		
		local tween = TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 520, 0, 310),
			BackgroundTransparency = 0
		})
		tween:Play()
		tween.Completed:Wait()
	else
		local tween = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 100, 0, 50),
			BackgroundTransparency = 1
		})
		tween:Play()
		tween.Completed:Wait()
		isOpen = false
		mainFrame.Visible = false
	end
	isAnimating = false
end)

--------------------------------------------------------------------------------
-- BARRA SUPERIOR
--------------------------------------------------------------------------------
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 24)
topBar.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 4)
topCorner.Parent = topBar

local topFix = Instance.new("Frame")
topFix.Size = UDim2.new(1, 0, 0, 4)
topFix.Position = UDim2.new(0, 0, 1, -4)
topFix.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
topFix.BorderSizePixel = 0
topFix.Parent = topBar

-- Arrastar o Painel
local draggingPanel = false
local panelStartMousePos, panelStartPos

topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingPanel = true
		panelStartMousePos = input.Position
		panelStartPos = mainFrame.AbsolutePosition
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				draggingPanel = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if draggingPanel and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - panelStartMousePos
		mainFrame.Position = UDim2.new(
			0, panelStartPos.X + delta.X,
			0, panelStartPos.Y + delta.Y
		)
	end
end)

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 350, 1, 0)
titleLabel.Position = UDim2.new(0, 8, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "[USE SPARINGLY.] - BROOKHAVEN"
titleLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 10
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- Botão Fechar
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 24, 1, 0)
closeButton.Position = UDim2.new(1, -24, 0, 0)
closeButton.BackgroundTransparency = 1
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(140, 140, 150)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 11
closeButton.Parent = topBar

closeButton.MouseButton1Click:Connect(function()
	isOpen = false
	mainFrame.Visible = false
end)

--------------------------------------------------------------------------------
-- REDIMENSIONAR PAINEL
--------------------------------------------------------------------------------
local resizeHandle = Instance.new("TextButton")
resizeHandle.Size = UDim2.new(0, 15, 0, 15)
resizeHandle.Position = UDim2.new(1, -15, 1, -15)
resizeHandle.BackgroundTransparency = 1
resizeHandle.Text = "◢"
resizeHandle.TextColor3 = Color3.fromRGB(100, 100, 110)
resizeHandle.TextSize = 10
resizeHandle.Parent = mainFrame

local resizing = false
local resizeStartMouse, resizeStartSize

resizeHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		resizing = true
		resizeStartMouse = input.Position
		resizeStartSize = mainFrame.AbsoluteSize
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				resizing = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - resizeStartMouse
		local newWidth = math.clamp(resizeStartSize.X + delta.X, 420, 900)
		local newHeight = math.clamp(resizeStartSize.Y + delta.Y, 240, 600)
		mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
	end
end)

--------------------------------------------------------------------------------
-- SIDEBAR E CONTEÚDO
--------------------------------------------------------------------------------
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 120, 1, -24)
sidebar.Position = UDim2.new(0, 0, 0, 24)
sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sideDivider = Instance.new("Frame")
sideDivider.Size = UDim2.new(0, 1, 1, 0)
sideDivider.Position = UDim2.new(1, 0, 0, 0)
sideDivider.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
sideDivider.BorderSizePixel = 0
sideDivider.Parent = sidebar

local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -121, 1, -24)
contentArea.Position = UDim2.new(0, 121, 0, 24)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

local pages = {}
local function createPage(name)
	local scrolling = Instance.new("ScrollingFrame")
	scrolling.Name = name .. "Page"
	scrolling.Size = UDim2.new(1, 0, 1, 0)
	scrolling.BackgroundTransparency = 1
	scrolling.Visible = false
	scrolling.CanvasSize = UDim2.new(0, 0, 2.2, 0)
	scrolling.ScrollBarThickness = 2
	scrolling.ScrollBarImageColor3 = Color3.fromRGB(40, 40, 50)
	scrolling.Parent = contentArea
	
	pages[name] = scrolling
	return scrolling
end

local pageConfig = createPage("Config")
local pageFun = createPage("Fun")
pageConfig.Visible = true

-- Botões da Sidebar
local categoryButtons = {}
local function createSidebarButton(name, iconText, targetPage, posY)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -8, 0, 22)
	btn.Position = UDim2.new(0, 4, 0, posY)
	btn.BackgroundTransparency = 1
	btn.Text = "  " .. iconText .. "  " .. name
	btn.TextColor3 = Color3.fromRGB(130, 130, 140)
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 10
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Parent = sidebar
	
	table.insert(categoryButtons, {Button = btn, Page = targetPage})
	
	btn.MouseButton1Click:Connect(function()
		for _, cat in ipairs(categoryButtons) do
			cat.Button.TextColor3 = Color3.fromRGB(130, 130, 140)
			cat.Button.BackgroundTransparency = 1
			cat.Page.Visible = false
		end
		btn.TextColor3 = Color3.fromRGB(240, 240, 240)
		btn.BackgroundTransparency = 0.85
		btn.BackgroundColor3 = Color3.fromRGB(35, 120, 70)
		targetPage.Visible = true
	end)
end

createSidebarButton("Configurações", "⚙", pageConfig, 8)
createSidebarButton("Funções", "⚡", pageFun, 33)

categoryButtons[1].Button.TextColor3 = Color3.fromRGB(240, 240, 240)
categoryButtons[1].Button.BackgroundTransparency = 0.85
categoryButtons[1].Button.BackgroundColor3 = Color3.fromRGB(35, 120, 70)

-- Helpers
local function addSectionTitle(text, parent, posY)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -16, 0, 16)
	label.Position = UDim2.new(0, 8, 0, posY)
	label.BackgroundTransparency = 1
	label.Text = string.upper(text)
	label.TextColor3 = Color3.fromRGB(90, 90, 100)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 9
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = parent
end

local function addSeparator(parent, posY)
	local sep = Instance.new("Frame")
	sep.Size = UDim2.new(1, -16, 0, 1)
	sep.Position = UDim2.new(0, 8, 0, posY)
	sep.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
	sep.BorderSizePixel = 0
	sep.Parent = parent
end

--------------------------------------------------------------------------------
-- ABA 1: CONFIGURAÇÕES
--------------------------------------------------------------------------------
addSectionTitle("PERFIL DO JOGADOR", pageConfig, 8)

local profilePic = Instance.new("ImageLabel")
profilePic.Size = UDim2.new(0, 42, 0, 42)
profilePic.Position = UDim2.new(0, 8, 0, 28)
profilePic.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
local content, isReady = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
profilePic.Image = content
profilePic.Parent = pageConfig

local picCorner = Instance.new("UICorner")
picCorner.CornerRadius = UDim.new(1, 0)
picCorner.Parent = profilePic

local mainNameLabel = Instance.new("TextLabel")
mainNameLabel.Size = UDim2.new(0, 250, 0, 18)
mainNameLabel.Position = UDim2.new(0, 58, 0, 30)
mainNameLabel.BackgroundTransparency = 1
mainNameLabel.Text = "Nome: " .. player.Name
mainNameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
mainNameLabel.Font = Enum.Font.GothamBold
mainNameLabel.TextSize = 11
mainNameLabel.TextXAlignment = Enum.TextXAlignment.Left
mainNameLabel.Parent = pageConfig

local subNameLabel = Instance.new("TextLabel")
subNameLabel.Size = UDim2.new(0, 250, 0, 18)
subNameLabel.Position = UDim2.new(0, 58, 0, 48)
subNameLabel.BackgroundTransparency = 1
subNameLabel.Text = "ID / Doc: " .. player.UserId
subNameLabel.TextColor3 = Color3.fromRGB(140, 140, 150)
subNameLabel.Font = Enum.Font.Gotham
subNameLabel.TextSize = 10
subNameLabel.TextXAlignment = Enum.TextXAlignment.Left
subNameLabel.Parent = pageConfig

addSeparator(pageConfig, 78)
addSectionTitle("CRÉDITOS", pageConfig, 86)

local ibLabel = Instance.new("TextLabel")
ibLabel.Size = UDim2.new(0, 250, 0, 18)
ibLabel.Position = UDim2.new(0, 8, 0, 104)
ibLabel.BackgroundTransparency = 1
ibLabel.Text = "Ib: Conradescr"
ibLabel.TextColor3 = Color3.fromRGB(110, 110, 120)
ibLabel.Font = Enum.Font.Gotham
ibLabel.TextSize = 10
ibLabel.TextXAlignment = Enum.TextXAlignment.Left
ibLabel.Parent = pageConfig

--------------------------------------------------------------------------------
-- ABA 2: FUNÇÕES (12 Funções Principais)
--------------------------------------------------------------------------------
addSectionTitle("PAINEL DE FUNÇÕES", pageFun, 8)

local function createFunButton(name, posY, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -16, 0, 26)
	btn.Position = UDim2.new(0, 8, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(35, 120, 70)
	btn.BorderSizePixel = 0
	btn.Text = "  " .. name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 10
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Parent = pageFun
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 3)
	corner.Parent = btn
	
	btn.MouseButton1Click:Connect(callback)
end

local yOffset = 28
local spacing = 30

-- Função 1: Reduzir Tamanho
createFunButton("Character Size", yOffset, function()
	if character then
		local hum = character:FindFirstChildOfClass("Humanoid")
		if hum then
			for _, part in ipairs(character:GetDescendants()) do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
					part.Size = part.Size * 0.8
				end
			end
		end
	end
end)
yOffset = yOffset + spacing

-- Função 2: Fake Lag
local fakeLagEnabled = false
createFunButton("Fake Lag", yOffset, function()
	fakeLagEnabled = not fakeLagEnabled
	print("[HUB] Fake Lag: " .. (fakeLagEnabled and "ATIVADO" or "DESATIVADO"))
end)
RunService.RenderStepped:Connect(function()
	if fakeLagEnabled and character and character:FindFirstChild("HumanoidRootPart") then
		character.HumanoidRootPart.Anchored = math.random() > 0.5
	elseif not fakeLagEnabled and character and character:FindFirstChild("HumanoidRootPart") then
		character.HumanoidRootPart.Anchored = false
	end
end)
yOffset = yOffset + spacing

-- Função 3: Chat Spam
createFunButton("Chat Spam", yOffset, function()
	local rs = game:GetService("ReplicatedStorage")
	local chatEvents = rs:FindFirstChild("DefaultChatSystemChatEvents")
	if chatEvents and chatEvents:FindFirstChild("SayMessageRequest") then
		chatEvents.SayMessageRequest:FireServer("Painel [Use sparingly.] ativo!", "All")
	end
end)
yOffset = yOffset + spacing

-- Função 4: Alterar Gravidade
createFunButton("Walk on Walls", yOffset, function()
	workspace.Gravity = workspace.Gravity == 196.2 and 20 or 196.2
	print("[HUB] Gravidade alterada!")
end)
yOffset = yOffset + spacing

-- Função 5: Fling
createFunButton("Fling", yOffset, function()
	if character then
		local hrp = character:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.Velocity = Vector3.new(0, 99999, 0) * 10
		end
	end
end)
yOffset = yOffset + spacing

-- Função 6: Teleport
createFunButton("Teleport (Frente)", yOffset, function()
	if character and character:FindFirstChild("HumanoidRootPart") then
		character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame + (character.HumanoidRootPart.CFrame.LookVector * 10)
	end
end)
yOffset = yOffset + spacing

-- Função 7: Noclip
local noclipEnabled = false
createFunButton("Noclip", yOffset, function()
	noclipEnabled = not noclipEnabled
	print("[HUB] Noclip: " .. (noclipEnabled and "ATIVADO" or "DESATIVADO"))
end)
RunService.Stepped:Connect(function()
	if noclipEnabled and character then
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)
yOffset = yOffset + spacing

-- Função 8: Invisibilidade
createFunButton("Invisible", yOffset, function()
	if character then
		local isInvisible = character:FindFirstChild("HumanoidRootPart").Transparency
		local newTransparency = isInvisible == 1 and 0 or 1
		
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") or part:IsA("Decal") then
				part.Transparency = newTransparency
			end
		end
		print("[HUB] Invisibilidade: " .. (newTransparency == 1 and "ATIVADA" or "DESATIVADA"))
	end
end)
yOffset = yOffset + spacing

-- Função 9: Sit Anywhere
createFunButton("Sit Anywhere", yOffset, function()
	if character then
		local hum = character:FindFirstChildOfClass("Humanoid")
		if hum then 
			hum.Sit = true
			print("[HUB] Sentado!")
		end
	end
end)
yOffset = yOffset + spacing

-- Função 10: Spin
local spinning = false
createFunButton("Spin", yOffset, function()
	spinning = not spinning
	print("[HUB] Spin: " .. (spinning and "ATIVADO" or "DESATIVADO"))
end)
RunService.RenderStepped:Connect(function()
	if spinning and character and character:FindFirstChild("HumanoidRootPart") then
		character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(20), 0)
	end
end)
yOffset = yOffset + spacing

-- Função 11: Rainbow Character
local rainbowActive = false
createFunButton("Rainbow Character", yOffset, function()
	rainbowActive = not rainbowActive
	print("[HUB] Rainbow: " .. (rainbowActive and "ATIVADO" or "DESATIVADO"))
end)
RunService.RenderStepped:Connect(function()
	if rainbowActive and character then
		local hue = tick() % 5 / 5
		local color = Color3.fromHSV(hue, 1, 1)
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
				part.Color = color
			end
		end
	end
end)
yOffset = yOffset + spacing

-- Função 12: Play Sound
createFunButton("Play Sound", yOffset, function()
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://9114221317"
	sound.Volume = 1
	sound.Parent = SoundService
	sound:Play()
	game.Debris:AddItem(sound, 3)
	print("[HUB] Som tocando!")
end)

print("======================================")
print("[DELTA] [Use sparingly.] Painel Carregado!")
print("[DELTA] Ícone flutuante pronto!")
print("[DELTA] Pressione o ícone para abrir/fechar")
print("======================================")
