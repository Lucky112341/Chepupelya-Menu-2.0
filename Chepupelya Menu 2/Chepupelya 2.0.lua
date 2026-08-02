-- ==========================================================
-- CHEPUPELYA MENU (KINETIC CHARGE EDITION + 100% GLOBAL BRING)
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
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
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
	btn.Name = name
	btn.AnchorPoint = Vector2.new(0.5, 0.5)
	btn.Size = size
	btn.Position = position
	btn.BackgroundColor3 = black
	btn.BorderColor3 = purple
	btn.BorderSizePixel = 2
	btn.Text = text
	btn.TextColor3 = purple
	btn.TextScaled = textScaled
	btn.TextSize = textSize
	btn.FontFace = font
	btn.Parent = mainFrame
	return btn
end

local function updateButtonVisual(btn, isOn, baseText)
	if isOn then
		btn.Text = baseText .. " [ON]"
		btn.TextColor3 = green
		btn.BorderColor3 = green
	else
		btn.Text = baseText
		btn.TextColor3 = purple
		btn.BorderColor3 = purple
	end
end

local speedButton = createMenuButton("SpeedButton", "UltraSpeed", UDim2.new(0.5, 0, 0.046, 0), UDim2.new(0.74, 0, 0.05, 0), true, 14)
local jumpButton = createMenuButton("JumpButton", "Ultra Jump", UDim2.new(0.5, 0, 0.124, 0), UDim2.new(0.74, 0, 0.05, 0), true, 14)
local flyButton = createMenuButton("FlyButton", "FLY", UDim2.new(0.5, 0, 0.207, 0), UDim2.new(0.74, 0, 0.05, 0), true, 14)
local pushButton = createMenuButton("PushButton", "Push Mode", UDim2.new(0.5, 0, 0.286, 0), UDim2.new(0.74, 0, 0.05, 0), true, 14)
local superRingButton = createMenuButton("SuperRingButton", "Super Ring", UDim2.new(0.5, 0, 0.375, 0), UDim2.new(0.74, 0, 0.05, 0), true, 14)

local partText = Instance.new("TextLabel")
partText.AnchorPoint = Vector2.new(0.5, 0.5)
partText.Size = UDim2.new(0.728, 0, 0.084, 0)
partText.Position = UDim2.new(0.5, 0, 0.517, 0)
partText.BackgroundColor3 = black
partText.BorderColor3 = purple
partText.BorderSizePixel = 2
partText.Text = "Shoot Part Menu"
partText.TextColor3 = purple
partText.TextScaled = true
partText.FontFace = font
partText.Parent = mainFrame

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
	speedOn = not speedOn
	updateButtonVisual(speedButton, speedOn, "UltraSpeed")
	if player.Character then updateCharacterSettings(player.Character) end
end)

jumpButton.MouseButton1Click:Connect(function()
	jumpOn = not jumpOn
	updateButtonVisual(jumpButton, jumpOn, "Ultra Jump")
	if player.Character then updateCharacterSettings(player.Character) end
end)

player.CharacterAdded:Connect(updateCharacterSettings)

-- ===== FLY =====
local flying, flyConnection, bodyVelocity, bodyGyro = false, nil, nil, nil
local flySpeed = 50
local keysPressed = {}

UserInputService.InputBegan:Connect(function(input, gp) if not gp then keysPressed[input.KeyCode] = true end end)
UserInputService.InputEnded:Connect(function(input) keysPressed[input.KeyCode] = nil end)

local function startFly()
	local char = player.Character
	if not char then return end
	local rootPart = char:FindFirstChild("HumanoidRootPart")
	local humanoid = char:FindFirstChild("Humanoid")
	if not rootPart or not humanoid then return end

	humanoid.PlatformStand = true
	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bodyVelocity.Parent = rootPart

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	bodyGyro.P = 3000
	bodyGyro.Parent = rootPart

	flyConnection = RunService.RenderStepped:Connect(function()
		pcall(function()
			local camera = workspace.CurrentCamera
			local moveVector = Vector3.new(0, 0, 0)
			if keysPressed[Enum.KeyCode.W] then moveVector += camera.CFrame.LookVector end
			if keysPressed[Enum.KeyCode.S] then moveVector -= camera.CFrame.LookVector end
			if keysPressed[Enum.KeyCode.A] then moveVector -= camera.CFrame.RightVector end
			if keysPressed[Enum.KeyCode.D] then moveVector += camera.CFrame.RightVector end
			if keysPressed[Enum.KeyCode.Space] then moveVector += Vector3.new(0, 1, 0) end
			if keysPressed[Enum.KeyCode.LeftShift] then moveVector -= Vector3.new(0, 1, 0) end
			
			if moveVector.Magnitude > 0 then moveVector = moveVector.Unit * flySpeed end
			bodyVelocity.Velocity = moveVector
			bodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + camera.CFrame.LookVector)
		end)
	end)
end

local function stopFly()
	if flyConnection then flyConnection:Disconnect() flyConnection = nil end
	if bodyVelocity then bodyVelocity:Destroy() end
	if bodyGyro then bodyGyro:Destroy() end
	local char = player.Character
	if char and char:FindFirstChild("Humanoid") then char.Humanoid.PlatformStand = false end
end

flyButton.MouseButton1Click:Connect(function()
	flying = not flying
	updateButtonVisual(flyButton, flying, "FLY")
	if flying then startFly() else stopFly() end
end)

-- ===== PUSH MODE =====
local pushModeOn = false
local energyCharge = 0
local pushAnchorPart = nil
local currentPushTarget = nil

local function cleanPushPhysics()
	energyCharge = 0
	local char = player.Character
	if char then
		local hum = char:FindFirstChild("Humanoid")
		local root = char:FindFirstChild("HumanoidRootPart")
		if hum then hum.AutoRotate = true end
		if root then
			root.AssemblyAngularVelocity = Vector3.zero
			root.AssemblyLinearVelocity = Vector3.zero
		end
		for _, p in ipairs(char:GetDescendants()) do
			if p:IsA("BasePart") then
				p.CustomPhysicalProperties = nil
			end
		end
	end
	
	if pushAnchorPart then
		pushAnchorPart:Destroy()
		pushAnchorPart = nil
	end
	currentPushTarget = nil
end

pushButton.MouseButton1Click:Connect(function()
	pushModeOn = not pushModeOn
	updateButtonVisual(pushButton, pushModeOn, "Push Mode")

	if not pushModeOn then
		cleanPushPhysics()
	end
end)

RunService.Heartbeat:Connect(function(dt)
	if not pushModeOn then return end

	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChild("Humanoid")
	if not root or not hum then return end

	if currentPushTarget then
		local isValid = false
		local tRoot = nil
		
		if currentPushTarget.Parent and currentPushTarget.Character then
			tRoot = currentPushTarget.Character:FindFirstChild("HumanoidRootPart")
			local tHum = currentPushTarget.Character:FindFirstChild("Humanoid")
			if tRoot and tHum and tHum.Health > 0 then
				isValid = true
			end
		end

		if isValid then
			local dist = (tRoot.Position - root.Position).Magnitude
			if dist > 25 then
				isValid = false
			end
		end

		if not isValid then
			if pushAnchorPart then
				root.CFrame = pushAnchorPart.CFrame
			end
			cleanPushPhysics()
			return
		else
			root.AssemblyLinearVelocity = Vector3.zero
			hum.AutoRotate = false
			energyCharge = math.min(energyCharge + dt * 4, 1)
			root.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5, 1, 1)

			local maxSpin = 90000
			local currentSpin = maxSpin * energyCharge
			root.AssemblyAngularVelocity = Vector3.new(0, currentSpin, 0)

			if energyCharge >= 0.8 and tRoot then
				root.CFrame = root.CFrame:Lerp(tRoot.CFrame, 0.2)
			end
			
			return 
		end
	end

	local targetPlayer = nil
	local minDistance = 7

	for _, otherPlayer in ipairs(Players:GetPlayers()) do
		if otherPlayer ~= player and otherPlayer.Character then
			local oRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
			local oHum = otherPlayer.Character:FindFirstChild("Humanoid")
			if oRoot and oHum and oHum.Health > 0 then
				local dist = (oRoot.Position - root.Position).Magnitude
				if dist < minDistance then
					targetPlayer = otherPlayer
					break
				end
			end
		end
	end

	if targetPlayer then
		pushAnchorPart = Instance.new("Part")
		pushAnchorPart.Name = "PushReturnAnchor"
		pushAnchorPart.Anchored = true
		pushAnchorPart.CanCollide = false
		pushAnchorPart.Transparency = 1
		pushAnchorPart.Size = Vector3.new(1, 1, 1)
		pushAnchorPart.CFrame = root.CFrame
		pushAnchorPart.Parent = workspace
		
		currentPushTarget = targetPlayer
	else
		if energyCharge > 0 or pushAnchorPart then
			cleanPushPhysics()
		end
	end
end)


-- =========================================================================
-- ГЛОБАЛЬНИЙ ВПЛИВ НА ФІЗИКУ ТА ПРАВА (Network Ownership)
-- =========================================================================
local heldItems = {}
local autoBringOn = false
local superRingOn = false
local ringItems = {}

-- Виконуємо взлом Network Ownership постійно в фоні, якщо активована хоч одна функція
RunService.Heartbeat:Connect(function()
	if superRingOn or autoBringOn or #heldItems > 0 or pushModeOn then
		pcall(function()
			if sethiddenproperty then
				sethiddenproperty(player, "SimulationRadius", 100000)
				sethiddenproperty(player, "MaxSimulationRadius", 100000)
				sethiddenproperty(player, "MaximumSimulationRadius", 100000)
			end
			if setsimulationradius then
				setsimulationradius(100000, 100000)
			end
			if settings().Physics then
				settings().Physics.AllowSleep = false
			end
		end)
	end
end)


-- ===== SUPER RING =====
local ringConnection = nil
local ringScanTask = nil

local function stopSuperRing()
	superRingOn = false
	updateButtonVisual(superRingButton, false, "Super Ring")
	
	if ringConnection then ringConnection:Disconnect() ringConnection = nil end
	if ringScanTask then task.cancel(ringScanTask) ringScanTask = nil end

	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	for _, item in ipairs(ringItems) do
		pcall(function()
			if item.part and item.part.Parent then
				item.part.CanCollide = item.origCollide
				if root then
					local launchDir = (item.part.Position - root.Position).Unit
					if launchDir.Magnitude == 0 or launchDir ~= launchDir then launchDir = Vector3.new(0, 1, 0) end
					item.part.AssemblyLinearVelocity = launchDir * 250
				end
			end
		end)
	end
	ringItems = {}
end

superRingButton.MouseButton1Click:Connect(function()
	if superRingOn then
		stopSuperRing()
		return
	end
	
	superRingOn = true
	updateButtonVisual(superRingButton, true, "Super Ring")

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
							for _, existing in ipairs(ringItems) do
								if existing.part == obj then
									found = true
									table.insert(newItems, existing)
									break
								end
							end
							
							if not found then
								-- Змінюємо CanCollide лише ОДИН РАЗ (як і треба)
								table.insert(newItems, {part = obj, origCollide = obj.CanCollide})
								obj.CanCollide = false
							end
						end
					end
				end
				ringItems = newItems
			end
			task.wait(1)
		end
	end)

	local currentAngle = 0
	ringConnection = RunService.Heartbeat:Connect(function(dt)
		local char = player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if not root then return end

		currentAngle += (dt * 4)

		local total = #ringItems
		if total == 0 then return end

		local radius = math.clamp(total * 0.5 + 10, 12, 80)
		local now = os.clock()

		for i, item in ipairs(ringItems) do
			pcall(function()
				if item.part and item.part.Parent then
					local angle = currentAngle + ((i / total) * math.pi * 2)
					local height = math.sin(now * 4 + i) * 3
					local target = root.Position + Vector3.new(
						math.cos(angle) * radius,
						height,
						math.sin(angle) * radius
					)
					item.part.AssemblyLinearVelocity = (target - item.part.Position) * 6
				end
			end)
		end
	end)
end)


-- ===== BRING & SHOOT (ГЛОБАЛЬНИЙ ЯК SUPER RING) =====
local bringScanTask = nil

RunService.Heartbeat:Connect(function(dt)
	if #heldItems == 0 then return end

	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	-- Точка прямо перед гравцем
	local targetCenter = root.Position + (root.CFrame.LookVector * 8) + Vector3.new(0, 2, 0)

	for _, item in ipairs(heldItems) do
		pcall(function()
			local part = item.part
			if part and part.Parent and not part.Anchored then
				
				local diff = targetCenter - part.Position
				local force = diff * 8
				
				-- ВАЖЛИВО ДЛЯ ГЛОБАЛЬНОСТІ: 
				-- Сервер блокує зміни фізики, якщо швидкість завелика. 
				-- Обмежуємо силу магніту до 250 (безпечна зона для сервера), 
				-- щоб предмети летіли до тебе ГЛОБАЛЬНО, а не тільки на твоєму екрані.
				if force.Magnitude > 250 then
					force = force.Unit * 250
				end
				
				part.AssemblyLinearVelocity = force
				part.AssemblyAngularVelocity = item.spin
			end
		end)
	end
end)

local function grabPart(part)
	pcall(function()
		if part.Anchored then return end
		
		-- Змінюємо колізію ТІЛЬКИ ОДИН РАЗ при захваті.
		-- (Якщо це робити в циклі Heartbeat, сервер миттєво відбере Network Ownership).
		local origCollide = part.CanCollide
		part.CanCollide = false
		
		table.insert(heldItems, {
			part = part,
			origCollide = origCollide,
			spin = Vector3.new(math.random(-15, 15), math.random(-15, 15), math.random(-15, 15))
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
					return
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
								if added >= 15 then break end 
							end
						end
					end
				end
				task.wait(0.5)
			end
		end)
	else
		if bringScanTask then
			task.cancel(bringScanTask)
			bringScanTask = nil
		end
	end
end)

shootButton.MouseButton1Click:Connect(function()
	local cam = workspace.CurrentCamera
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not root or not cam or #heldItems == 0 then return end
	
	local dir = cam.CFrame.LookVector
	for _, item in ipairs(heldItems) do
		pcall(function()
			if item.part and item.part.Parent and not item.part.Anchored then
				item.part.CanCollide = item.origCollide
				
				-- Швидкість пострілу лімітовано до 250! 
				-- Більше значення анти-чіт сервера сприйме як збій і предмет полетить лише в тебе на екрані.
				item.part.AssemblyLinearVelocity = dir * 250
				item.part.AssemblyAngularVelocity = Vector3.new(math.random(-50,50), math.random(-50,50), math.random(-50,50))
			end
		end)
	end
	heldItems = {}
end)
