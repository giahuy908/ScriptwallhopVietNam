-- LocalScript trong StarterGui
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- GUI Button
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0,180,0,50)
button.Position = UDim2.new(0.5,-90,0.9,-25)
button.Text = "Wall Hop: TẮT"
button.TextColor3 = Color3.new(1,1,1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20
button.Parent = screenGui

-- 🌈 Rainbow Gradient
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
	ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255,255,0)),
	ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0,255,0)),
	ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0,255,255)),
	ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0,0,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,255))
}
gradient.Rotation = 0
gradient.Parent = button

RunService.RenderStepped:Connect(function()
	gradient.Rotation = (gradient.Rotation + 1) % 360
end)

-- 🔘 Bo góc giao diện
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,15) -- bo tròn 15px
corner.Parent = button

-- Trạng thái
local enabled = false
local canJump = true

-- ⚙️ Bộ góc
local angle = 60       -- Góc xoay
local jumpDelay = 0.3  -- Delay trước khi nhảy lại

-- Bật / Tắt
button.MouseButton1Click:Connect(function()
	enabled = not enabled
	if enabled then
		button.Text = "Wall Hop: BẬT"
	else
		button.Text = "Wall Hop: TẮT"
	end
end)

-- Xử lý khi nhảy
UserInputService.JumpRequest:Connect(function()
	if enabled and humanoid and canJump then
		canJump = false
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

		-- Xoay nhanh, không tween
		task.delay(0.1, function()
			if root then
				root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(angle), 0)
				task.wait(0.05)
				root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(-angle), 0)
			end
		end)

		-- Delay mới nhảy lại
		task.wait(jumpDelay)
		canJump = true
	end
end)
