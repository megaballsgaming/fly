local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 50
local bodyGyro = nil
local bodyVelocity = nil

-- keybinds
local flyKey = Enum.KeyCode.F -- Toggle fly mode
local upKey = Enum.KeyCode.E -- Ascend
local downKey = Enum.KeyCode.Q -- Descend

-- togglefly function
local function toggleFly()
    flying = not flying

    if flying then
        bodyGyro = Instance.new("BodyGyro")
        bodyVelocity = Instance.new("BodyVelocity")

        bodyGyro.Parent = humanoidRootPart
        bodyVelocity.Parent = humanoidRootPart
        bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
        bodyGyro.CFrame = humanoidRootPart.CFrame
        bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
    else
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
        bodyGyro = nil
        bodyVelocity = nil
    end
end

-- this is for updating fly movement
local function flyMovement(input)
    if not flying then return end

    local velocity = Vector3.new()

    if input.KeyCode == Enum.KeyCode.W then
        velocity = humanoidRootPart.CFrame.LookVector * speed
    elseif input.KeyCode == Enum.KeyCode.S then
        velocity = -humanoidRootPart.CFrame.LookVector * speed
    elseif input.KeyCode == Enum.KeyCode.A then
        velocity = -humanoidRootPart.CFrame.RightVector * speed
    elseif input.KeyCode == Enum.KeyCode.D then
        velocity = humanoidRootPart.CFrame.RightVector * speed
    elseif input.KeyCode == upKey then
        velocity = Vector3.new(0, speed, 0)
    elseif input.KeyCode == downKey then
        velocity = Vector3.new(0, -speed, 0)
    end

    bodyVelocity.Velocity = velocity
    bodyGyro.CFrame = workspace.CurrentCamera.CFrame
end

-- event listeners
local userInputService = game:GetService("UserInputService")

userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == flyKey then
        toggleFly()
    else
        flyMovement(input)
    end
end)

userInputService.InputEnded:Connect(function(input)
    if not flying then return end

    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
end)
