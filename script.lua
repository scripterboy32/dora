local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local aimbotEnabled = false
local espEnabled = false
local predictionEnabled = false
local predictionAmount = 1 -- Default prediction amount
local maxPredictionAmount = 5 -- Maximum prediction amount
local defaultWalkspeed = LocalPlayer.Character.Humanoid.WalkSpeed

-- Assume the projectile speed is known. Adjust as necessary.
local projectileSpeed = 1000 -- Example speed, adjust this value as needed

local function getClosestPlayerHead()
    local closestPlayer = nil
    local closestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local screenPoint = Camera:WorldToScreenPoint(head.Position)
            local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude

            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = player
            end
        end
    end

    return closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") or nil
end

local function predictHeadPosition(head)
    if head and head.Parent and head.Parent:FindFirstChild("HumanoidRootPart") then
        local hrp = head.Parent.HumanoidRootPart
        local headPosition = head.Position
        local hrpVelocity = hrp.Velocity
        local distance = (headPosition - Camera.CFrame.Position).Magnitude
        local travelTime = (distance / projectileSpeed) * predictionAmount

        return headPosition + (hrpVelocity * travelTime)
    end
    return head.Position
end

local function lockCameraToHead()
    local head = getClosestPlayerHead()
    if head then
        local targetPosition = predictionEnabled and predictHeadPosition(head) or head.Position
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPosition)
    end
end

local holdingRightClick = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton2 then
        holdingRightClick = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        holdingRightClick = false
    end
end)

RunService.RenderStepped:Connect(function()
    if aimbotEnabled and holdingRightClick then
        lockCameraToHead()
    end
end)

local function createESP(player)
    local highlight = Instance.new("BoxHandleAdornment")
    highlight.Name = "ESPHighlight"
    highlight.AlwaysOnTop = true
    highlight.Size = Vector3.new(4, 8, 4)
    highlight.Adornee = player.Character:WaitForChild("HumanoidRootPart")
    highlight.Color3 = Color3.fromRGB(255, 0, 0) -- Red color
    highlight.Transparency = 0.5
    highlight.ZIndex = 5
    highlight.Parent = player.Character
end

local function removeESP(player)
    if player.Character then
        local highlight = player.Character:FindFirstChild("ESPHighlight")
        if highlight then
            highlight:Destroy()
        end
    end
end

local function onCharacterAdded(character)
    local player = Players:GetPlayerFromCharacter(character)
    if player and espEnabled then
        createESP(player)
    end
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character and espEnabled then
        createESP(player)
    end
end

local function onPlayerRemoving(player)
    removeESP(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

for _, player in pairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

-- UI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PersistentUI"
ScreenGui.ResetOnSpawn = false -- Ensure UI persists after death

local AimbotDropdownButton = Instance.new("TextButton")
local AimbotDropdownFrame = Instance.new("Frame")  -- Frame for aimbot options
local MiscDropdownButton = Instance.new("TextButton")
local MiscDropdownFrame = Instance.new("Frame")  -- Frame for misc options
local ESPButton = Instance.new("TextButton")
local PredictionButton = Instance.new("TextButton")
local PredictionAmountTextBox = Instance.new("TextBox")
local PredictionAmountLabel = Instance.new("TextLabel")
local MaxPredictionLabel = Instance.new("TextLabel")
local NotificationLabel = Instance.new("TextLabel")
local WalkspeedSlider = Instance.new("TextBox")
local FlyButton = Instance.new("TextButton")
local NoclipButton = Instance.new("TextButton")
local AimbotToggle = Instance.new("TextButton")
local DefaultWalkspeedLabel = Instance.new("TextLabel")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Styling
local darkGrey = Color3.fromRGB(50, 50, 50)
local lighterGrey = Color3.fromRGB(80, 80, 80)
local red = Color3.fromRGB(255, 0, 0)
local white = Color3.fromRGB(255, 255, 255)

ScreenGui.Enabled = true

AimbotDropdownButton.Size = UDim2.new(0, 225, 0, 50)
AimbotDropdownButton.Position = UDim2.new(0, 10, 0, 10)
AimbotDropdownButton.Text = "Aimbot â–¼"
AimbotDropdownButton.TextColor3 = white
AimbotDropdownButton.BackgroundColor3 = darkGrey
AimbotDropdownButton.BorderSizePixel = 0
AimbotDropdownButton.Font = Enum.Font.SourceSans
AimbotDropdownButton.TextSize = 18
AimbotDropdownButton.Parent = ScreenGui

AimbotDropdownFrame.Size = UDim2.new(0, 221, 0, 350)  -- Increased height to 300
AimbotDropdownFrame.Position = UDim2.new(0, 10, 0, 70)
AimbotDropdownFrame.Visible = false
AimbotDropdownFrame.BackgroundColor3 = lighterGrey
AimbotDropdownFrame.BorderSizePixel = 0
AimbotDropdownFrame.Parent = ScreenGui

MiscDropdownButton.Size = UDim2.new(0, 225, 0, 50)
MiscDropdownButton.Position = UDim2.new(0, 245, 0, 10)
MiscDropdownButton.Text = "Misc â–¼"
MiscDropdownButton.TextColor3 = white
MiscDropdownButton.BackgroundColor3 = darkGrey
MiscDropdownButton.BorderSizePixel = 0
MiscDropdownButton.Font = Enum.Font.SourceSans
MiscDropdownButton.TextSize = 18
MiscDropdownButton.Parent = ScreenGui

MiscDropdownFrame.Size = UDim2.new(0, 221, 0, 350)  -- Adjusted height for misc options
MiscDropdownFrame.Position = UDim2.new(0, 245, 0, 70)
MiscDropdownFrame.Visible = false
MiscDropdownFrame.BackgroundColor3 = lighterGrey
MiscDropdownFrame.BorderSizePixel = 0
MiscDropdownFrame.Parent = ScreenGui

AimbotToggle.Size = UDim2.new(0, 200, 0, 50)
AimbotToggle.Position = UDim2.new(0, 10, 0, 10)
AimbotToggle.Text = "Toggle Aimbot"
AimbotToggle.TextColor3 = white
AimbotToggle.BackgroundColor3 = darkGrey
AimbotToggle.BorderSizePixel = 0
AimbotToggle.Font = Enum.Font.SourceSans
AimbotToggle.TextSize = 16
AimbotToggle.Parent = AimbotDropdownFrame

ESPButton.Size = UDim2.new(0, 200, 0, 50)
ESPButton.Position = UDim2.new(0, 10, 0, 70)
ESPButton.Text = "Toggle ESP"
ESPButton.TextColor3 = white
ESPButton.BackgroundColor3 = darkGrey
ESPButton.BorderSizePixel = 0
ESPButton.Font = Enum.Font.SourceSans
ESPButton.TextSize = 16
ESPButton.Parent = AimbotDropdownFrame

PredictionButton.Size = UDim2.new(0, 200, 0, 50)
PredictionButton.Position = UDim2.new(0, 10, 0, 130)
PredictionButton.Text = "Toggle Prediction"
PredictionButton.TextColor3 = white
PredictionButton.BackgroundColor3 = darkGrey
PredictionButton.BorderSizePixel = 0
PredictionButton.Font = Enum.Font.SourceSans
PredictionButton.TextSize = 16
PredictionButton.Parent = AimbotDropdownFrame

PredictionAmountLabel.Size = UDim2.new(0, 200, 0, 50)
PredictionAmountLabel.Position = UDim2.new(0, 10, 0, 190)
PredictionAmountLabel.Text = "Prediction Amount"
PredictionAmountLabel.TextColor3 = white
PredictionAmountLabel.BackgroundColor3 = darkGrey
PredictionAmountLabel.BorderSizePixel = 0
PredictionAmountLabel.Font = Enum.Font.SourceSans
PredictionAmountLabel.TextSize = 16
PredictionAmountLabel.Parent = AimbotDropdownFrame

PredictionAmountTextBox.Size = UDim2.new(0, 200, 0, 30)
PredictionAmountTextBox.Position = UDim2.new(0, 10, 0, 240)
PredictionAmountTextBox.Text = tostring(predictionAmount)
PredictionAmountTextBox.TextColor3 = white
PredictionAmountTextBox.BackgroundColor3 = darkGrey
PredictionAmountTextBox.BorderSizePixel = 0
PredictionAmountTextBox.Font = Enum.Font.SourceSans
PredictionAmountTextBox.TextSize = 14
PredictionAmountTextBox.Parent = AimbotDropdownFrame

MaxPredictionLabel.Size = UDim2.new(0, 200, 0, 20)
MaxPredictionLabel.Position = UDim2.new(0, 10, 0, 270)
MaxPredictionLabel.Text = "(Max: " .. maxPredictionAmount .. ")"
MaxPredictionLabel.TextColor3 = white
MaxPredictionLabel.BackgroundColor3 = darkGrey
MaxPredictionLabel.BorderSizePixel = 0
MaxPredictionLabel.Font = Enum.Font.SourceSans
MaxPredictionLabel.TextSize = 12
MaxPredictionLabel.Parent = AimbotDropdownFrame

DefaultWalkspeedLabel.Size = UDim2.new(0, 200, 0, 20)
DefaultWalkspeedLabel.Position = UDim2.new(0, 10, 0, 270)
DefaultWalkspeedLabel.Text = "(Default: " .. defaultWalkspeed .. ")"
DefaultWalkspeedLabel.TextColor3 = white
DefaultWalkspeedLabel.BackgroundColor3 = darkGrey
DefaultWalkspeedLabel.BorderSizePixel = 0
DefaultWalkspeedLabel.Font = Enum.Font.SourceSans
DefaultWalkspeedLabel.TextSize = 12
DefaultWalkspeedLabel.Parent = MiscDropdownFrame

WalkspeedSlider.Size = UDim2.new(0, 200, 0, 30)
WalkspeedSlider.Position = UDim2.new(0, 10, 0, 10)
WalkspeedSlider.Text = tostring(defaultWalkspeed)
WalkspeedSlider.TextColor3 = white
WalkspeedSlider.BackgroundColor3 = darkGrey
WalkspeedSlider.BorderSizePixel = 0
WalkspeedSlider.Font = Enum.Font.SourceSans
WalkspeedSlider.TextSize = 14
WalkspeedSlider.Parent = MiscDropdownFrame

FlyButton.Size = UDim2.new(0, 200, 0, 50)
FlyButton.Position = UDim2.new(0, 10, 0, 50)
FlyButton.Text = "Toggle Fly"
FlyButton.TextColor3 = white
FlyButton.BackgroundColor3 = darkGrey
FlyButton.BorderSizePixel = 0
FlyButton.Font = Enum.Font.SourceSans
FlyButton.TextSize = 16
FlyButton.Parent = MiscDropdownFrame

-- Create a TextButton for Godmode
local GodmodeButton = Instance.new("TextButton")
GodmodeButton.Size = UDim2.new(0, 200, 0, 50)
GodmodeButton.Position = UDim2.new(0, 10, 0, 170)  -- Adjust position as needed
GodmodeButton.Text = "Toggle Godmode"
GodmodeButton.TextColor3 = white
GodmodeButton.BackgroundColor3 = darkGrey
GodmodeButton.BorderSizePixel = 0
GodmodeButton.Font = Enum.Font.SourceSans
GodmodeButton.TextSize = 16
GodmodeButton.Parent = MiscDropdownFrame

NoclipButton.Size = UDim2.new(0, 200, 0, 50)
NoclipButton.Position = UDim2.new(0, 10, 0, 110)
NoclipButton.Text = "Toggle Noclip"
NoclipButton.TextColor3 = white
NoclipButton.BackgroundColor3 = darkGrey
NoclipButton.BorderSizePixel = 0
NoclipButton.Font = Enum.Font.SourceSans
NoclipButton.TextSize = 16
NoclipButton.Parent = MiscDropdownFrame

NotificationLabel.Size = UDim2.new(0, 400, 0, 50)
NotificationLabel.Position = UDim2.new(0.5, -200, 0.5, -25) -- Center of the screen
NotificationLabel.Text = "Press Right Ctrl to toggle the menu"
NotificationLabel.TextColor3 = white
NotificationLabel.BackgroundColor3 = darkGrey
NotificationLabel.BackgroundTransparency = 0.5 -- Semi-transparent
NotificationLabel.Font = Enum.Font.SourceSans
NotificationLabel.TextSize = 20
NotificationLabel.Parent = ScreenGui

-- Hide the notification after a few seconds
spawn(function()
    wait(5)
    NotificationLabel:Destroy()
end)

local aimbotDropdownOpen = false
local miscDropdownOpen = false

AimbotDropdownButton.MouseButton1Click:Connect(function()
    aimbotDropdownOpen = not aimbotDropdownOpen
    AimbotDropdownButton.Text = aimbotDropdownOpen and "Aimbot â–²" or "Aimbot â–¼"
    AimbotDropdownFrame.Visible = aimbotDropdownOpen
end)

MiscDropdownButton.MouseButton1Click:Connect(function()
    miscDropdownOpen = not miscDropdownOpen
    MiscDropdownButton.Text = miscDropdownOpen and "Misc â–²" or "Misc â–¼"
    MiscDropdownFrame.Visible = miscDropdownOpen
end)

AimbotToggle.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    AimbotToggle.Text = aimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
end)

ESPButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ESPButton.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    
    if espEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createESP(player)
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                removeESP(player)
            end
        end
    end
end)

PredictionButton.MouseButton1Click:Connect(function()
    predictionEnabled = not predictionEnabled
    PredictionButton.Text = predictionEnabled and "Prediction: ON" or "Prediction: OFF"
end)

PredictionAmountTextBox.FocusLost:Connect(function()
    local newAmount = tonumber(PredictionAmountTextBox.Text)
    if newAmount then
        predictionAmount = math.clamp(newAmount, 0.1, maxPredictionAmount)
        PredictionAmountTextBox.Text = tostring(predictionAmount)
    else
        PredictionAmountTextBox.Text = tostring(predictionAmount)
    end
end)

WalkspeedSlider.FocusLost:Connect(function()
    local newWalkspeed = tonumber(WalkspeedSlider.Text)
    if newWalkspeed then
        LocalPlayer.Character.Humanoid.WalkSpeed = newWalkspeed
    else
        WalkspeedSlider.Text = tostring(LocalPlayer.Character.Humanoid.WalkSpeed)
    end
end)

FlyButton.MouseButton1Click:Connect(function()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.PlatformStand = not humanoid.PlatformStand
    end
    FlyButton.Text = humanoid.PlatformStand and "Fly: ON" or "Fly: OFF"
end)

local godmodeEnabled = false

GodmodeButton.MouseButton1Click:Connect(function()
    godmodeEnabled = not godmodeEnabled
    GodmodeButton.Text = godmodeEnabled and "Godmode: ON" or "Godmode: OFF"

    -- Adjust player's health or invincibility state accordingly
    if godmodeEnabled then
        LocalPlayer.Character:WaitForChild("Humanoid").MaxHealth = math.huge
        LocalPlayer.Character:WaitForChild("Humanoid").Health = math.huge
    else
        LocalPlayer.Character:WaitForChild("Humanoid").MaxHealth = 100  -- Set default max health
        LocalPlayer.Character:WaitForChild("Humanoid").Health = 100      -- Set default health
    end
end)

NoclipButton.MouseButton1Click:Connect(function()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Seated)
    end
end)

local uiVisible = true

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightControl then
        uiVisible = not uiVisible
        ScreenGui.Enabled = uiVisible
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        if NotificationLabel then
            NotificationLabel.Text = "Menu toggled with Right Ctrl"
            wait(2)
            NotificationLabel.Text = "Press Right Ctrl to toggle the menu"
        end
    end
end)
 
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Load the external script
loadstring(game:HttpGet("https://pastefy.app/17VeKBb2/raw"))()

-- Function to apply the persistent states to the player's character
local function applyPersistentStates(character)
    -- Assuming the external script sets these global variables/functions
    if _G.godmode then
        _G.godmode(character)
    end
    if _G.setWalkSpeed then
        _G.setWalkSpeed(character)
    end
    if _G.noclip then
        _G.noclip(character)
    end
    if _G.fly then
        _G.fly(character)
    end
end

-- Bind the function to PlayerAdded and CharacterAdded events
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        applyPersistentStates(character)
    end)
end

-- Connect the PlayerAdded event
Players.PlayerAdded:Connect(onPlayerAdded)

-- Apply the persistent states to all existing players
local existingPlayers = Players:GetPlayers()
for i = 1, #existingPlayers do
    local player = existingPlayers[i]
    if player.Character then
        applyPersistentStates(player.Character)
    end
    player.CharacterAdded:Connect(function(character)
        applyPersistentStates(character)
    end)
end
