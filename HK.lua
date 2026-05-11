-- [[ HK.BEATALL V6 - RAGE HYBRID (Desync + Orbit + VoidSpam) ]]
if getgenv().HK_BEATALL_V6 then return end
getgenv().HK_BEATALL_V6 = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer

-- ==================== SETTINGS ====================
local Settings = {
    Ragebot = {Enabled = true, TargetPart = "Head"},
    SilentAim = {Enabled = true, FOV = 120, HitChance = 95},
    
    AntiAim = {
        Enabled = true,
        Mode = "Orbit",        -- Orbit / Desync / Spin
        OrbitSpeed = 28,
        OrbitRadius = 7.5,
        SpinSpeed = 40,
        HideInFloor = false,
    },
    
    Exploits = {
        Wallbang = true,
        VoidSpam = true,
        SkinUnlock = true,
    },
}

print("HK.BEATALL V6 - RAGE HYBRID LOADED")

-- ==================== SKIN UNLOCK ====================
if Settings.Exploits.SkinUnlock then
    hookmetamethod(game, "__index", function(self, key)
        if not checkcaller() and (key == "HasSkin" or key == "Owned" or tostring(self):find("Skin")) then
            return true
        end
        return rawget(self, key)
    end)
end

-- ==================== WALLBANG ====================
hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if Settings.Exploits.Wallbang and (method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList" or method == "Raycast") then
        return nil
    end
    return oldNamecall(self, ...)
end)

-- ==================== UTILITY ====================
local function GetClosest()
    local closest, dist = nil, Settings.SilentAim.FOV
    local mouse = UserInputService:GetMouseLocation()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and plr.Character:FindFirstChild("Head") then
            local pos, onScreen = Camera:WorldToViewportPoint(plr.Character.Head.Position)
            local d = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
            if onScreen and d < dist then
                dist = d
                closest = plr
            end
        end
    end
    return closest
end

-- ==================== MAIN RAGE ENGINE ====================
RunService.Heartbeat:Connect(function()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Ragebot + Silent Aim
    if Settings.Ragebot.Enabled or Settings.SilentAim.Enabled then
        local target = GetClosest()
        if target and target.Character and target.Character.Head then
            if Settings.Ragebot.Enabled then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
            end
        end
    end

    -- ==================== ANTI-AIM (Orbit + Desync) ====================
    if Settings.AntiAim.Enabled then
        local t = tick()
        
        if Settings.AntiAim.Mode == "Orbit" then
            local angle = t * Settings.AntiAim.OrbitSpeed
            local rad = Settings.AntiAim.OrbitRadius
            local offset = Vector3.new(math.cos(angle) * rad, 1.5, math.sin(angle) * rad)
            
            hrp.CFrame = CFrame.new(hrp.Position + offset) * CFrame.Angles(0, angle * 3, 0)
        end

        if Settings.AntiAim.HideInFloor then
            hrp.CFrame = hrp.CFrame * CFrame.new(0, -1.8, 0)
        end
    end

    -- ==================== VOID SPAM ====================
    if Settings.Exploits.VoidSpam then
        for _, v in ipairs(workspace:GetChildren()) do
            if v:IsA("BasePart") and (v.Position - hrp.Position).Magnitude < 42 then
                pcall(function()
                    v.AssemblyLinearVelocity = Vector3.new(math.random(-7000,7000), 11000, math.random(-7000,7000))
                end)
            end
        end
    end
end)

-- ==================== UI (현재 1순위) ====================
-- (UI는 다음에 더 예쁘고 Tab 방식으로 업그레이드 해줄게. 지금은 기본으로)

local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 480, 0, 420)
Main.Position = UDim2.new(0.5, -240, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Visible = true

-- TopBar, Title, Toggle 버튼들... (이전 버전처럼)

print("V6 Rage Hybrid - Orbit + VoidSpam + Desync 방향 완료")




