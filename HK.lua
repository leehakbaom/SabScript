-- [[ HK.BEATALL.V1 : PURE LUA VERSION ]]
-- NO KOREAN TEXT TO PREVENT ENCODING ERRORS

if getgenv().HK_FINAL_RUN then return end
getgenv().HK_FINAL_RUN = true

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local HK_SET = {
    Slingshot = {Enabled = false, Power = 100, Wallbang = true},
    Rage = {Enabled = false, Orbit = false, OrbitSpeed = 12, OrbitDist = 7},
    AA = {Enabled = false, Pitch = "None", Yaw = 0, Underground = false}, 
    Emote = {Enabled = false, Id = "rbxassetid://10921261194", Speed = 1.0, Track = nil},
    Visuals = {ThirdPerson = false, Accent = Color3.fromHex("#7B61FF"), GUI_Visible = true}
}

local function UnlockSkins()
    pcall(function()
        local p = {LP:FindFirstChild("Inventory"), LP:FindFirstChild("Data") and LP.Data:FindFirstChild("Skins")}
        for _, path in pairs(p) do if path then for _, v in pairs(path:GetDescendants()) do if v:IsA("BoolValue") or v:IsA("IntValue") then v.Value = (v:IsA("BoolValue") and true or 1) end end end end
    end)
end

RS.Heartbeat:Connect(function()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if HK_SET.Slingshot.Enabled then
        hrp.AssemblyLinearVelocity = hrp.CFrame.LookVector * HK_SET.Slingshot.Power + Vector3.new(0, 2, 0)
        if HK_SET.Slingshot.Wallbang then hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -0.7) end
    end

    if HK_SET.Rage.Enabled and HK_SET.Rage.Orbit then
        local t = nil
        local d = 500
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (v.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if dist < d then d = dist t = v end
            end
        end
        if t then
            local t_hrp = t.Character.HumanoidRootPart
            local a = tick() * HK_SET.Rage.OrbitSpeed
            local p = t_hrp.Position + Vector3.new(math.cos(a) * HK_SET.Rage.OrbitDist, 3, math.sin(a) * HK_SET.Rage.OrbitDist)
            hrp.CFrame = CFrame.new(p, t_hrp.Position)
        end
    end

    if HK_SET.AA.Enabled then
        if HK_SET.AA.Underground then hrp.CFrame = hrp.CFrame * CFrame.new(0, -8, 0) end
        local rj = hrp:FindFirstChild("RootJoint") or (char:FindFirstChild("LowerTorso") and char.LowerTorso:FindFirstChild("RootJoint"))
        if rj then
            local pv = (HK_SET.AA.Pitch == "Jitter" and math.random(-89, 89) or (HK_SET.AA.Pitch == "Down" and -89 or 0))
            rj.C0 = CFrame.new(rj.C0.Position) * CFrame.Angles(math.rad(pv), math.rad(HK_SET.AA.Yaw), 0)
        end
    end

    LP.CameraMaxZoomDistance = HK_SET.Visuals.ThirdPerson and 50 or 0.5
    LP.CameraMinZoomDistance = HK_SET.Visuals.ThirdPerson and 20 or 0.5
end)

local sg = Instance.new("ScreenGui")
pcall(function() sg.Parent = (gethui and gethui()) or CoreGui or LP:WaitForChild("PlayerGui") end)

local m = Instance.new("Frame", sg)
m.Size = UDim2.new(0, 550, 0, 420)
m.Position = UDim2.new(0.5, -275, 0.5, -210)
m.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
m.BorderSizePixel = 2
m.BorderColor3 = HK_SET.Visuals.Accent
m.Visible = true

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 45, 0, 45)
btn.Position = UDim2.new(0, 10, 0.5, -22)
btn.Text = "HK"
btn.BackgroundColor3 = HK_SET.Visuals.Accent
Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

btn.MouseButton1Click:Connect(function() m.Visible = not m.Visible end)
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == HK_SET.Config.ToggleKey then m.Visible = not m.Visible end end)

print("HK.BEATALL.V1 LOADED WITHOUT ERRORS")


