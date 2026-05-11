-- [[ HK.BEATALL.V1 : ALL-IN-ONE HYBRID (MANUAL CONTROL) ]]
if getgenv().HK_EXECUTED then return end
getgenv().HK_EXECUTED = true

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- [ 1. 통합 설정 테이블 (기본값 모두 false) ]
local HK_SET = {
    Slingshot = {Enabled = false, Power = 100, Wallbang = true},
    Rage = {Enabled = false, Orbit = false, OrbitSpeed = 12, OrbitDist = 7},
    AA = {Enabled = false, Pitch = "None", Yaw = 0, Underground = false}, 
    Emote = {Enabled = false, Id = "rbxassetid://10921261194", Speed = 1.0, Track = nil},
    Visuals = {ThirdPerson = false, Accent = Color3.fromHex("#7B61FF"), GUI_Visible = true}
}

-- [ 2. 기능 모듈 : 스킨 언락 (버튼 전용) ]
local function UnlockSkins()
    pcall(function()
        local paths = {LP:FindFirstChild("Inventory"), LP:FindFirstChild("Data") and LP.Data:FindFirstChild("Skins")}
        for _, path in pairs(paths) do if path then for _, v in pairs(path:GetDescendants()) do if v:IsA("BoolValue") or v:IsA("IntValue") then v.Value = (v:IsA("BoolValue") and true or 1) end end end end
    end)
end

-- [ 3. 핵심 엔진 : 통합 루프 (버튼 상태 체크) ]
RS.Heartbeat:Connect(function()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- A. 슬링샷 & 월뱅 (켜졌을 때만)
    if HK_SET.Slingshot.Enabled then
        hrp.AssemblyLinearVelocity = hrp.CFrame.LookVector * HK_SET.Slingshot.Power + Vector3.new(0, 2, 0)
        if HK_SET.Slingshot.Wallbang then hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -0.7) end
    end

    -- B. 오비트 (Rage & Orbit 켜졌을 때만)
    if HK_SET.Rage.Enabled and HK_SET.Rage.Orbit then
        local target = nil
        local dist = 500
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local d = (v.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if d < dist then dist = d target = v end
            end
        end
        if target then
            local t_hrp = target.Character.HumanoidRootPart
            local angle = tick() * HK_SET.Rage.OrbitSpeed
            local pos = t_hrp.Position + Vector3.new(math.cos(angle) * HK_SET.Rage.OrbitDist, 3, math.sin(angle) * HK_SET.Rage.OrbitDist)
            hrp.CFrame = CFrame.new(pos, t_hrp.Position)
        end
    end

    -- C. 안티 에임 & 언더그라운드 (켜졌을 때만)
    if HK_SET.AA.Enabled then
        if HK_SET.AA.Underground then hrp.CFrame = hrp.CFrame * CFrame.new(0, -8, 0) end
        
        local rootJoint = hrp:FindFirstChild("RootJoint") or (char:FindFirstChild("LowerTorso") and char.LowerTorso:FindFirstChild("RootJoint"))
        if rootJoint then
            local p_val = (HK_SET.AA.Pitch == "Jitter" and math.random(-89, 89) or (HK_SET.AA.Pitch == "Down" and -89 or 0))
            rootJoint.C0 = CFrame.new(rootJoint.C0.Position) * CFrame.Angles(math.rad(p_val), math.rad(HK_SET.AA.Yaw), 0)
        end
    end

    -- D. 3인칭 (실시간 체크)
    LP.CameraMaxZoomDistance = HK_SET.Visuals.ThirdPerson and 50 or 0.5
    LP.CameraMinZoomDistance = HK_SET.Visuals.ThirdPerson and 20 or 0.5
end)

-- [ 4. UI 및 실행 시스템 ]
local ScreenGui = Instance.new("ScreenGui")
pcall(function() ScreenGui.Parent = (gethui and gethui()) or CoreGui or LP:WaitForChild("PlayerGui") end)

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 550, 0, 420)
Main.Position = UDim2.new(0.5, -275, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 2
Main.BorderColor3 = HK_SET.Visuals.Accent
Main.Visible = true

-- (모바일 버튼 & PC 단축키)
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, -22)
ToggleBtn.Text = "HK"
ToggleBtn.BackgroundColor3 = HK_SET.Visuals.Accent
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.RightControl then Main.Visible = not Main.Visible end end)

print("[HK.BEATALL.V1] Manual Control Ready. All features are OFF by default.")

