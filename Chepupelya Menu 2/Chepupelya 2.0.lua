-- ==========================================================
-- CHEPUPELYA MENU (100% GLOBAL BRING - ANTI-COLLISION GRID)
-- ==========================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")
local guiName = "ChepupelyaMenu_DeltaFix"

if guiParent:FindFirstChild(guiName) then
	guiParent[guiName]:Destroy()
end

-- ===== СТВОРЕННЯ UI =====
local purple = Color3.fromRGB(157, 0, 255)
local green = Color3.fromRGB(0, 255, 127)
local black = Color3.new(0, 0, 0)
local font = Font.fromEnum(Enum.Font.SourceSansBold)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999999999
screenGui.Enabled = true
screenGui.Parent = guiParent

local closeOpen = Instance.new("TextButton")
closeOpen.Name = "Close/Open"
closeOpen.AnchorPoint = Vector2.new(0.5, 0.5)
closeOpen.Size = UDim2.new(0.247, 0, 0.063, 0)
closeOpen.Position = UDim2.new(0.149, 0, 0.105, 0)
closeOpen.BackgroundColor3 = black
closeOpen.BorderColor3 = purple
closeOpen.BorderSizePixel = 2
closeOpen.Text = "Chepupelya Menu"
closeOpen.TextColor3 = purple
closeOpen.TextScaled = true
closeOpen.FontFace = font
closeOpen.Parent = screenGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Size = UDim2.new(0.249, 0, 0.744, 0)
mainFrame.Position = UDim2.new(0.149, 0, 0.509, 0)
mainFrame.BackgroundColor3 = black
mainFrame.BorderColor3 = purple
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Parent = screenGui

-- ===== DRAGGING =====
local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true; dragStart = input.Position; startPos = mainFrame.Position
		input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
	end
end)
mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- ===== КНОПКИ =====
local function createMenuButton(name, text, position, size, textScaled, textSize)
	local btn = Instance.new("TextButton")
	btn.Name = name; btn.AnchorPoint = Vector2.new(0.5, 0.5); btn.Size = size; btn.Position = position
	btn.BackgroundColor3 = black; btn.BorderColor3 = purple; btn.BorderSizePixel = 2
	btn.Text = text; btn.TextColor3 = purple; btn.TextScaled = textScaled; btn.TextSize = textSize; btn.FontFace = font; btn.Parent = mainFrame
	return btn
end

local function updateButtonVisual(btn, isOn, baseText)
	if isOn then
		btn.Text = baseText .. " [ON]"; btn.TextColor3 = green; btn.BorderColor3 = green
	else
		btn.Text = baseText; btn.TextColor3 = purple; btn.BorderColor3 = purple
	end
end

local speedButton = createMenuButton("SpeedButton", "UltraSpeed", UDim2.new(0.5, 0, 0.046, 0), UDim2.new(0.74, 0, 0.05, 0), true, 14)
local jumpButton = createMenuButton("JumpButton", "Ultra Jump", UDim2.new(0.5, 0, 0.124, 0), UDim2.new(0.74, 0, 0.05, 0), true, 14)
local flyButton = createMenuButton("FlyButton", "FLY", UDim2.new(0.5, 0, 0.207, 0), UDim2.new(0.74, 0, 0.05, 0), true, 14)
local pushButton = createMenuButton("PushButton", "Push Mode", UDim2.new(0.5, 0, 0.286, 0), UDim2.new(0.74, 0, 0.05, 0), true, 14)
local superRingButton = createMenuButton("SuperRingButton", "Super Ring", UDim2.new(0.5, 0, 0.375, 0), UDim2.new(0.74, 0, 0.05, 0), true, 14)

local partText = Instance.new("TextLabel")
partText.AnchorPoint = Vector2.new(0.5, 0.5); partText.Size = UDim2.new(0.728, 0, 0.084, 0); partText.Position = UDim2.new(0.5, 0, 0.517, 0)
partText.BackgroundColor3 = black; partText.BorderColor3 = purple; partText.BorderSizePixel = 2
partText.Text = "Shoot Part Menu"; partText.TextColor3 = purple; partText.TextScaled = true; partText.FontFace = font; partText.Parent = mainFrame

local bringButton = createMenuButton("BringButton", "Bring Part", UDim2.new(0.255, 0, 0.695, 0), UDim2.new(0.246, 0, 0.169, 0), false, 24)
local shootButton = createMenuButton("ShootButton", "Push", UDim2.new(0.739, 0, 0.693, 0), UDim2.new(0.246, 0, 0.169, 0), false, 24)
local bringAllButton = createMenuButton("BringAllButton", "Bring All", UDim2.new(0.5, 0, 0.863, 0), UDim2.new(0.73, 0, 0.079, 0), false, 24)

-- ===== АНІМАЦІЯ =====
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local function getFadableInstances(root)
	local objects = {{instance = root, prop = "BackgroundTransparency", original = root.BackgroundTransparency}}
	for _, obj in ipairs(root:GetDescendants()) do
		if obj:IsA("GuiObject") then table.insert(objects, {instance = obj, prop = "BackgroundTransparency", original = obj.BackgroundTransparency}) end
		if obj:IsA("TextLabel") or obj:IsA("TextButton") then table.insert(objects, {instance = obj, prop = "TextTransparency", original = obj.TextTransparency}) end
	end
	return objects
end

local fadableObjects = getFadableInstances(mainFrame)
local menuOpen, isAnimating = true, false

closeOpen.MouseButton1Click:Connect(function()
	if isAnimating then return end
	isAnimating = true
	menuOpen = not menuOpen
	for _, data in ipairs(fadableObjects) do
		TweenService:Create(data.instance, tweenInfo, {[data.prop] = menuOpen and data.original or 1}):Play()
	end
	task.delay(0.3, function() mainFrame.Visible = menuOpen; isAnimating = false end)
end)

-- ===== ШВИДКІСТЬ / СТРИБОК =====
local NORMAL_SPEED, BOOST_SPEED = 16, 60
local NORMAL_JUMP, BOOST_JUMP = 50, 120
local speedOn, jumpOn = false, false

local function updateCharacterSettings(character)
	local humanoid = character:WaitForChild("Humanoid", 3)
	if humanoid then
		humanoid.WalkSpeed = speedOn and BOOST_SPEED or NORMAL_SPEED
		humanoid.UseJumpPower = true
		humanoid.JumpPower = jumpOn and BOOST_JUMP or NORMAL_JUMP
	end
end

speedButton.MouseButton1Click:Connect(function()
	speedOn = not speedOn; updateButtonVisual(speedButton, speedOn, "UltraSpeed")
	if player.Character then updateCharacterSettings(player.Character) end
end)
jumpButton.MouseButton1Click:Connect(function()
	jumpOn = not jumpOn; updateButtonVisual(jumpButton, jumpOn, "Ultra Jump")
	if player.Character then updateCharacterSettings(player.Character) end
end)
player.CharacterAdded:Connect(updateCharacterSettings)

-- ===== FLY (Скорочено) =====
local flying, flyConnection, bodyVelocity, bodyGyro = false, nil, nil, nil
local keysPressed = {}
UserInputService.InputBegan:Connect(function(input, gp) if not gp then keysPressed[input.KeyCode] = true end end)
UserInputService.InputEnded:Connect(function(input) keysPressed[input.KeyCode] = nil end)

local function startFly()
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	char.Humanoid.PlatformStand = true
	bodyVelocity = Instance.new("BodyVelocity", char.HumanoidRootPart)
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bodyGyro = Instance.new("BodyGyro", char.HumanoidRootPart)
	bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); bodyGyro.P = 3000

	flyConnection = RunService.RenderStepped:Connect(function()
		local cam = workspace.CurrentCamera
		local move = Vector3.zero
		if keysPressed[Enum.KeyCode.W] then move += cam.CFrame.LookVector end
		if keysPressed[Enum.KeyCode.S] then move -= cam.CFrame.LookVector end
		if keysPressed[Enum.KeyCode.A] then move -= cam.CFrame.RightVector end
		if keysPressed[Enum.KeyCode.D] then move += cam.CFrame.RightVector end
		if keysPressed[Enum.KeyCode.Space] then move += Vector3.new(0, 1, 0) end
		if keysPressed[Enum.KeyCode.LeftShift] then move -= Vector3.new(0, 1, 0) end
		if move.Magnitude > 0 then move = move.Unit * 50 end
		bodyVelocity.Velocity = move
		bodyGyro.CFrame = CFrame.new(char.HumanoidRootPart.Position, char.HumanoidRootPart.Position + cam.CFrame.LookVector)
	end)
end

flyButton.MouseButton1Click:Connect(function()
	flying = not flying; updateButtonVisual(flyButton, flying, "FLY")
	if flying then startFly() else
		if flyConnection then flyConnection:Disconnect() end
		if bodyVelocity then bodyVelocity:Destroy() end
		if bodyGyro then bodyGyro:Destroy() end
		if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.PlatformStand = false end
	end
end)

-- ===== GLOBAL NETWORK OWNERSHIP LOOP =====
local heldItems = {}
local autoBringOn = false
local superRingOn = false
local ringItems = {}
local pushModeOn = false

RunService.Heartbeat:Connect(function()
	if superRingOn or autoBringOn or #heldItems > 0 or pushModeOn then
		pcall(function()
			settings().Physics.AllowSleep = false
			local set_sim = sethiddenproperty or set_hidden_property or set_hidden_prop
			if set_sim then
				set_sim(player, "SimulationRadius", math.huge)
				set_sim(player, "MaxSimulationRadius", math.huge)
			end
			if setsimulationradius then
				setsimulationradius(math.huge, math.huge)
			end
		end)
	end
end)

-- ===== PUSH MODE =====
local energyCharge, pushAnchorPart, currentPushTarget = 0, nil, nil
local function cleanPushPhysics()
	energyCharge = 0
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.Humanoid.AutoRotate = true
		char.HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
		char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
		char.HumanoidRootPart.CustomPhysicalProperties = nil
	end
	if pushAnchorPart then pushAnchorPart:Destroy(); pushAnchorPart = nil end
	currentPushTarget = nil
end

pushButton.MouseButton1Click:Connect(function()
	pushModeOn = not pushModeOn; updateButtonVisual(pushButton, pushModeOn, "Push Mode")
	if not pushModeOn then cleanPushPhysics() end
end)

RunService.Heartbeat:Connect(function(dt)
	if not pushModeOn then return end
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	if currentPushTarget then
		local tRoot = currentPushTarget.Character and currentPushTarget.Character:FindFirstChild("HumanoidRootPart")
		if tRoot and (tRoot.Position - root.Position).Magnitude <= 25 then
			player.Character.Humanoid.AutoRotate = false
			energyCharge = math.min(energyCharge + dt * 4, 1)
			root.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5, 1, 1)
			root.AssemblyAngularVelocity = Vector3.new(0, 90000 * energyCharge, 0)
			if energyCharge >= 0.8 then root.CFrame = root.CFrame:Lerp(tRoot.CFrame, 0.2) end
		else
			if pushAnchorPart then root.CFrame = pushAnchorPart.CFrame end
			cleanPushPhysics()
		end
		return
	end

	for _, other in ipairs(Players:GetPlayers()) do
		if other ~= player and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
			if (other.Character.HumanoidRootPart.Position - root.Position).Magnitude < 7 then
				pushAnchorPart = Instance.new("Part")
				pushAnchorPart.Anchored = true; pushAnchorPart.CanCollide = false; pushAnchorPart.Transparency = 1
				pushAnchorPart.CFrame = root.CFrame; pushAnchorPart.Parent = workspace
				currentPushTarget = other; break
			end
		end
	end
end)


-- ===== SUPER RING =====
local ringConnection, ringScanTask
superRingButton.MouseButton1Click:Connect(function()
	superRingOn = not superRingOn; updateButtonVisual(superRingButton, superRingOn, "Super Ring")
	if not superRingOn then
		if ringConnection then ringConnection:Disconnect() end
		if ringScanTask then task.cancel(ringScanTask) end
		for _, item in ipairs(ringItems) do
			if item.part and item.part.Parent then item.part.CanCollide = item.origCollide end
		end
		ringItems = {}
		return
	end

	ringScanTask = task.spawn(function()
		while superRingOn do
			local char = player.Character
			if char then
				local newItems = {}
				for _, obj in ipairs(workspace:GetDescendants()) do
					if obj:IsA("BasePart") and not obj.Anchored and not obj:IsDescendantOf(char) then
						local pModel = obj:FindFirstAncestorOfClass("Model")
						if not (pModel and pModel:FindFirstChild("Humanoid")) and obj.Name ~= "Baseplate" and obj.Name ~= "Terrain" then
							local found = false
							for _, existing in ipairs(ringItems) do if existing.part == obj then found = true; table.insert(newItems, existing); break end end
							if not found then table.insert(newItems, {part = obj, origCollide = obj.CanCollide}); obj.CanCollide = false end
						end
					end
				end
				ringItems = newItems
			end
			task.wait(1)
		end
	end)

	local angle = 0
	ringConnection = RunService.Heartbeat:Connect(function(dt)
		local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if not root or #ringItems == 0 then return end
		angle += dt * 4
		local radius = math.clamp(#ringItems * 0.5 + 10, 12, 80)
		for i, item in ipairs(ringItems) do
			if item.part and item.part.Parent then
				local a = angle + ((i / #ringItems) * math.pi * 2)
				local target = root.Position + Vector3.new(math.cos(a) * radius, math.sin(os.clock() * 4 + i) * 3, math.sin(a) * radius)
				item.part.AssemblyLinearVelocity = (target - item.part.Position) * 6
			end
		end
	end)
end)


-- ===== ГЛОБАЛЬНИЙ BRING & SHOOT (СІТКА БЕЗ КОЛІЗІЙ) =====
local bringScanTask = nil

RunService.Heartbeat:Connect(function()
	if #heldItems == 0 then return end

	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local totalItems = #heldItems

	for i, item in ipairs(heldItems) do
		pcall(function()
			local part = item.part
			if part and part.Parent and not part.Anchored then
				
				-- ФОРМУЄМО МАТРИЦЮ (СІТКУ) ПРЕДМЕТІВ ПЕРЕД ГРАВЦЕМ
				-- Це вирішує проблему локальності! Предмети більше не стикаються на сервері.
				local maxCols = 5 -- Максимум 5 предметів у ряд
				local row = math.floor((i - 1) / maxCols)
				local itemsInThisRow = math.min(totalItems - (row * maxCols), maxCols)
				local col = (i - 1) % maxCols
				
				local spacing = 4.5 -- Відстань між предметами (запобігає колізіям)
				local offsetX = (col - (itemsInThisRow - 1) / 2) * spacing
				local offsetY = (row * spacing) + 1.5 -- Чим більше предметів, тим вище будується стіна
				local offsetZ = -8 -- 8 студів перед обличчям
				
				-- Обчислюємо точну точку для ЦЬОГО конкретного предмета у просторі
				local targetPos = root.CFrame:PointToWorldSpace(Vector3.new(offsetX, offsetY, offsetZ))
				
				local diff = targetPos - part.Position
				
				-- Сила тяжіння без лімітів, як у Super Ring
				part.AssemblyLinearVelocity = diff * 7
				part.AssemblyAngularVelocity = item.spin
			end
		end)
	end
end)

local function grabPart(part)
	pcall(function()
		if part.Anchored then return end
		local origCollide = part.CanCollide
		part.CanCollide = false
		table.insert(heldItems, {
			part = part,
			origCollide = origCollide,
			spin = Vector3.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10))
		})
	end)
end

bringButton.MouseButton1Click:Connect(function()
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and not obj.Anchored and not obj:IsDescendantOf(player.Character or {}) then
			local pModel = obj:FindFirstAncestorOfClass("Model")
			if not (pModel and pModel:FindFirstChild("Humanoid")) and obj.Name ~= "Baseplate" and obj.Name ~= "Terrain" then
				local held = false
				for _, h in ipairs(heldItems) do if h.part == obj then held = true break end end
				if not held then 
					grabPart(obj) 
					break -- Беремо тільки один найближчий доступний предмет
				end
			end
		end
	end
end)

bringAllButton.MouseButton1Click:Connect(function()
	autoBringOn = not autoBringOn
	updateButtonVisual(bringAllButton, autoBringOn, "Bring All")
	
	if autoBringOn then
		bringScanTask = task.spawn(function()
			while autoBringOn do
				local added = 0
				for _, obj in ipairs(workspace:GetDescendants()) do
					if obj:IsA("BasePart") and not obj.Anchored and not obj:IsDescendantOf(player.Character or {}) then
						local pModel = obj:FindFirstAncestorOfClass("Model")
						if not (pModel and pModel:FindFirstChild("Humanoid")) and obj.Name ~= "Baseplate" and obj.Name ~= "Terrain" then
							local held = false
							for _, h in ipairs(heldItems) do if h.part == obj then held = true break end end
							if not held then
								grabPart(obj)
								added += 1
								if added >= 25 then break end 
							end
						end
					end
				end
				task.wait(0.5)
			end
		end)
	else
		if bringScanTask then task.cancel(bringScanTask); bringScanTask = nil end
	end
end)

shootButton.MouseButton1Click:Connect(function()
	local cam = workspace.CurrentCamera
	if not cam or #heldItems == 0 then return end
	
	local dir = cam.CFrame.LookVector
	for _, item in ipairs(heldItems) do
		pcall(function()
			if item.part and item.part.Parent and not item.part.Anchored then
				item.part.CanCollide = item.origCollide
				-- Запускаємо предмети вперед і трохи вгору
				item.part.AssemblyLinearVelocity = (dir * 400) + Vector3.new(0, 30, 0)
			end
		end)
	end
	heldItems = {}
end)
