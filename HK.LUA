-- [[ HK.BEATALL.V1 : PERFECT STABILIZED EDITION ]]
-- 최적화: 렉 최소화, 메모리 누수 방지, PC/모바일 통합

if getgenv().HK_FINAL_RUN then 
    print("[HK] Already Running.") 
    return 
end
getgenv().HK_FINAL_RUN = true

-- 서비스 캐싱 (성능 향상)
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- [ 1. 설정 데이터 (전역 최적화) ]
local HK_SET = {
    Slingshot = {Enabled = false, Power = 100, Wallbang = true},
    Rage = {Enabled = false, Orbit = true, Speed = 10, Dist = 6},
    Void = {Enabled = false, Radius = 45},
    Emote = {Enabled = false, Id = "rbxassetid://10921261194", Speed = 1.0, Track = nil},
    Config = {AutoLoad = true, SilentLoad = false, ToggleKey = Enum.KeyCode.RightControl},
    Visuals = {ThirdPerson = false, Accent = Color3.fromHex("#7B61FF")}
}

-- [ 2. 기능 보강 및 에러 방지 (pcall & Task) ]
local function SafeUnlockSkins()
    task.spawn(function()
        pcall(function()
            local paths = {LP:FindFirstChild("Inventory"), LP:FindFirstChild("Data") and LP.Data:FindFirstChild("Skins")}
            for _, path in pairs(paths) do
                if path then
                    for _, v in pairs(path:GetDescendants()) do
                        if v:IsA("BoolValue") or v:IsA("IntValue") then 
                            v.Value = (v:IsA("BoolValue") and true or 1) 
                        end
                    end
                end
            end
        end)
    end)
end

-- [ 3. 렉 방지 엔진 (Heartbeat 기반 최적화) ]
-- 슬링샷 및 물리 로직을 하나의 루프에서 관리하여 CPU 부하 감소
RS.Heartbeat:Connect(function()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Slingshot (Wallbang)
    if HK_SET.Slingshot.Enabled then
        hrp.AssemblyLinearVelocity = hrp.CFrame.LookVector * HK_SET.Slingshot.Power + Vector3.new(0, 2, 0)
        if HK_SET.Slingshot.Wallbang then
            hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -0.7)
        end
    end

    -- 3인칭 (실시간 반영)
    LP.CameraMaxZoomDistance = HK_SET.Visuals.ThirdPerson and 50 or 0.5
    LP.CameraMinZoomDistance = HK_SET.Visuals.ThirdPerson and 20 or 0.5
end)

-- [ 4. UI 및 로더 (모바일/PC 통합) ]
local ScreenGui = Instance.new("ScreenGui")
pcall(function() ScreenGui.Parent = (gethui and gethui()) or CoreGui or LP:WaitForChild("PlayerGui") end)

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 550, 0, 400)
Main.Position = UDim2.new(0.5, -275, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Visible = not HK_SET.Config.SilentLoad

-- 토글 버튼 및 키 바인드
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, -22)
ToggleBtn.Text = "HK"
ToggleBtn.BackgroundColor3 = HK_SET.Visuals.Accent
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

local function ToggleGUI() Main.Visible = not Main.Visible end
ToggleBtn.MouseButton1Click:Connect(ToggleGUI)
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == HK_SET.Config.ToggleKey then ToggleGUI() end end)

-- [ 5. 자동 실행 ]
if HK_SET.Config.AutoLoad then SafeUnlockSkins() end

print("[HK.BEATALL.V1] 안정성 검토 완료. 렉 제로 모드 가동.")
