local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
print(".")
print("loaded succ")
local keys = {
    "NIGGER",
    "xDTkErqYYf2XuaQMbzj6jm", --ömer
    "qT81680yv7GBFhdZGJbBug", --özer
    "Sikici-ozer", --özer 2
    "Ejf2YZdhauGY1NMGDSZB7P", --garland
    "Dogebest",
    "Z1dnNh5NBqgT2E44eZG61u",
    -- Add more keys here if needed
}

local privatekeys = {
    "HVAQBEnnaduryyHQVatgMM",
    "bnaaAMUTDPeTwbbKbfAgjb", --ömer
    "NoqCKzJQddXfaXjaZVeeq",
    "cfhhcLqiKqUrNbucCRnXey", --özer
    "NkyxmApanWQgYCytpoYrvH",
    "wxAsMnmtZAFXDxnnrddnaa", --özer 2
    "aXUVRuWAxAobVsCz88nPnZ", --garland
    "Dogebestpriv",
    "fRtWKVPvRaqLeLnPeLjjad",
    -- Add more keys here if needed
}

-- Function to check if the provided key is valid
local function isValidKey(inputKey)
    for _, key in ipairs(keys) do
        if key == inputKey then
            return "Normal"
        end
    end
    for _, key in ipairs(privatekeys) do
        if key == inputKey then
            return "priv"
        end
    end
    return false
end

-- Create the GUI elements
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeyGui"
ScreenGui.Parent = game.CoreGui

-- Create a background image
local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.Position = UDim2.new(0, 0, 0, 0)
BackgroundImage.Image = "rbxassetid://5995253095"
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.Parent = ScreenGui

-- Create a background frame for better aesthetics
local BackgroundFrame = Instance.new("Frame")
BackgroundFrame.Size = UDim2.new(0, 300, 0, 200)
BackgroundFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
BackgroundFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
BackgroundFrame.BorderSizePixel = 0
BackgroundFrame.Parent = BackgroundImage

-- Create a UI corner for rounded edges
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.1, 0) -- Rounded corners
UICorner.Parent = BackgroundFrame

-- Create the TextBox for key input
local TextBox = Instance.new("TextBox")
TextBox.Name = "KeyTextBox"
TextBox.Size = UDim2.new(0, 250, 0, 50)
TextBox.Position = UDim2.new(0.5, -125, 0.5, -30)
TextBox.PlaceholderText = "Enter your key"
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextBox.BorderSizePixel = 0
TextBox.Font = Enum.Font.SourceSans
TextBox.TextSize = 18
TextBox.Parent = BackgroundFrame

-- Create a UI corner for the TextBox
local TextBoxCorner = Instance.new("UICorner")
TextBoxCorner.CornerRadius = UDim.new(5, 0)
TextBoxCorner.Parent = TextBox

-- Create the TextButton for submission
local TextButton = Instance.new("TextButton")
TextButton.Name = "SubmitButton"
TextButton.Size = UDim2.new(0, 100, 0, 50)
TextButton.Position = UDim2.new(0.5, -50, 0.5, 40)
TextButton.Text = "Submit"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0) -- Green background
TextButton.BorderSizePixel = 0
TextButton.Font = Enum.Font.SourceSans
TextButton.TextSize = 18
TextButton.Parent = BackgroundFrame

-- Create a UI corner for the TextButton
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0.1, 0)
ButtonCorner.Parent = TextButton

-- Variable to track if the script should execute
local shouldExecute = false

-- Auto-destroy GUI if no input is detected for 10 seconds
delay(10, function()
    if not shouldExecute then
        ScreenGui:Destroy()
    end
end)

-- Handle key submission
TextButton.MouseButton1Click:Connect(function()
    local userKey = TextBox.Text
    local keyType = isValidKey(userKey)

    if keyType then
        print("Valid key. The script will execute.")
        shouldExecute = true
        ScreenGui:Destroy() -- Hide and remove the GUI

        -- Place your script's main code here
        if keyType == "Normal" then
            loadstring(game:HttpGet('https://raw.githubusercontent.com/scripterboy32/dora/main/script.lua))()
        elseif keyType == "priv" then
            loadstring(game:HttpGet('https://raw.githubusercontent.com/scripterboy32/dora/main/script.lua))()
        end
    else
        print("Invalid key. The script will not execute.")
        TextButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0) -- Turn red
        TextButton.Text = "Invalid Key"
        wait(5)
        TextButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0) -- Revert to green
        TextButton.Text = "Submit"
        TextBox.Text = "" -- Clear the TextBox for new input
    end
end)

-- Main script code that should not run until the key is validated
while not shouldExecute do
    wait(1) -- Wait until the key is validated and shouldExecute is true
end
