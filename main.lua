local function GetA()
    local url = "https://raw.githubusercontent.com/AcelestuZ/Abcdefgh/main/a.lua"
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if success then return result else warn("Errore caricamento Logica A: " .. tostring(result)) return nil end
end

local A = GetA()
if not A then return end -- Ferma lo script se A non viene caricato

local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = game:GetService("Players").LocalPlayer
local Cam = workspace.CurrentCamera
local Parent = game:GetService("CoreGui"):FindFirstChild("RobloxGui") or LP:WaitForChild("PlayerGui")

local function CleanUp()
	local old = Parent:FindFirstChild("Freecam_AcelestuZ_V12")
	if old then old:Destroy() end
end
CleanUp()

local ScreenGui = Instance.new("ScreenGui", Parent)
ScreenGui.Name = "Freecam_AcelestuZ_V12"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

local MovePad = Instance.new("Frame", ScreenGui)
MovePad.Size = UDim2.new(0.45, 0, 1, 0)
MovePad.BackgroundTransparency = 1
MovePad.Visible = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 150, 0, 30)
MainFrame.Position = UDim2.new(0.5, -75, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.new(0, 0, 0)
MainFrame.ClipsDescendants = true
MainFrame.Active = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -60, 0, 30)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Freecam"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", MainFrame)
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -55, 0, 2)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinBtn.Text = "▼"
MinBtn.TextColor3 = Color3.new(1, 1, 1)

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -27, 0, 2)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)

local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, 0, 0, 160)
Content.Position = UDim2.new(0, 0, 0, 35)
Content.BackgroundTransparency = 1
Content.Visible = false

local UIList = Instance.new("UIListLayout", Content)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 5)

local function CreateBtn(name)
	local b = Instance.new("TextButton", Content)
	b.Size = UDim2.new(0.9, 0, 0, 35)
	b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.SourceSans
	b.Text = name
	return b
end

local ToggleBtn = CreateBtn("Status: OFF")
local SpeedBtn = CreateBtn("Fast: 1x")
local TPBtn = CreateBtn("TP to Cam")

local Credit = Instance.new("TextLabel", Content)
Credit.Size = UDim2.new(1, 0, 0, 20)
Credit.BackgroundTransparency = 1
Credit.Text = "By AcelestuZ"
Credit.TextColor3 = Color3.new(0.7, 0.7, 0.7)
Credit.Font = Enum.Font.SourceSansItalic
Credit.TextSize = 11

local IsOpen = false

MinBtn.MouseButton1Click:Connect(function()
	IsOpen = not IsOpen
	MinBtn.Text = IsOpen and "▲" or "▼"
	MainFrame:TweenSize(IsOpen and UDim2.new(0, 150, 0, 200) or UDim2.new(0, 150, 0, 30), "Out", "Quad", 0.2, true)
	Content.Visible = IsOpen
end)

CloseBtn.MouseButton1Click:Connect(function() 
	A.Reset(ToggleBtn)
	ScreenGui:Destroy() 
end)

ToggleBtn.MouseButton1Click:Connect(function()
	A.Enabled = not A.Enabled
	ToggleBtn.Text = A.Enabled and "Status: ON" or "Status: OFF"
	ToggleBtn.BackgroundColor3 = A.Enabled and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(50, 50, 50)
	MovePad.Visible = A.Enabled
	MovePad.Active = A.Enabled
	if A.Enabled then
		A.Rot = Vector2.new(Cam.CFrame:ToEulerAnglesYXZ())
		if LP.Character then 
			local hum = LP.Character:FindFirstChild("Humanoid")
			if hum then for _, t in pairs(hum:GetPlayingAnimationTracks()) do t:Stop(0.1) end end
			A.TeleportToGround(LP.Character.HumanoidRootPart.Position)
			task.wait(0.1)
			LP.Character.HumanoidRootPart.Anchored = true 
		end
	else
		A.Reset(ToggleBtn)
	end
end)

SpeedBtn.MouseButton1Click:Connect(function()
	local speeds = {0.5, 1, 2, 5, 10, 20}
	local cur = table.find(speeds, A.Speed) or 2
	A.Speed = speeds[cur % #speeds + 1]
	SpeedBtn.Text = "Fast: " .. A.Speed .. "x"
end)

TPBtn.MouseButton1Click:Connect(function()
	if LP.Character then A.TeleportToGround(Cam.CFrame.Position) end
end)

MovePad.InputBegan:Connect(function(io)
	if io.UserInputType == Enum.UserInputType.Touch then
		A.StartPos = Vector2.new(io.Position.X, io.Position.Y)
		A.CurrentMovePos = A.StartPos
	end
end)

MovePad.InputChanged:Connect(function(io)
	if A.StartPos and io.UserInputType == Enum.UserInputType.Touch then
		A.CurrentMovePos = Vector2.new(io.Position.X, io.Position.Y)
	end
end)

UIS.InputChanged:Connect(function(io, gpe)
	if not A.Enabled or gpe then return end
	if io.UserInputType == Enum.UserInputType.Touch and io.Position.X >= Cam.ViewportSize.X / 2 then
		A.Rot = A.Rot + Vector2.new(-io.Delta.Y * 0.005, -io.Delta.X * 0.005)
	end
end)

local function StopMove()
	A.StartPos, A.CurrentMovePos, A.CurrentMoveVec = nil, nil, Vector2.new(0,0)
end
MovePad.InputEnded:Connect(StopMove)
UIS.InputEnded:Connect(function(io) if io.UserInputType == Enum.UserInputType.Touch and not A.StartPos then StopMove() end end)

RS.RenderStepped:Connect(A.UpdateCamera)

local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not A.Enabled then
		dragging, dragStart, startPos = true, input.Position, MainFrame.Position
	end
end)
UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
UIS.InputEnded:Connect(function() dragging = false end)
