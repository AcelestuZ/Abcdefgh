local A = {}
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

A.Enabled = false
A.Speed = 1
A.Rot = Vector2.new(0, 0)
A.StartPos = nil
A.CurrentMovePos = nil
A.CurrentMoveVec = Vector2.new(0, 0)

function A.TeleportToGround(targetPos)
	local char = LP.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if hrp then
		local rayParams = RaycastParams.new()
		rayParams.FilterDescendantsInstances = {char, Cam}
		rayParams.FilterType = Enum.RaycastFilterType.Exclude
		local res = workspace:Raycast(targetPos, Vector3.new(0, -500, 0), rayParams)
		hrp.CFrame = CFrame.new(res and (res.Position + Vector3.new(0, 3.5, 0)) or targetPos)
	end
end

function A.Reset(toggleBtn)
	A.Enabled = false
	toggleBtn.Text = "Status: OFF"
	toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	Cam.CameraType = Enum.CameraType.Custom
	if LP.Character then
		local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
		if hrp then hrp.Anchored = false end
	end
end

function A.UpdateCamera(dt)
	if not A.Enabled then return end
	Cam.CameraType = Enum.CameraType.Scriptable
	if A.StartPos and A.CurrentMovePos then
		local diff = A.CurrentMovePos - A.StartPos
		if diff.Magnitude > 2 then
			A.CurrentMoveVec = diff.Unit * (math.min(diff.Magnitude, 60) / 60)
		end
	end
	local cf = Cam.CFrame
	local dir = (cf.LookVector * -A.CurrentMoveVec.Y) + (cf.RightVector * A.CurrentMoveVec.X)
	Cam.CFrame = CFrame.new(cf.Position + (dir * (A.Speed * dt * 60))) * CFrame.fromEulerAnglesYXZ(A.Rot.X, A.Rot.Y, 0)
end

return A
