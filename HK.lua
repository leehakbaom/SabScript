-- [[ HK.BEATALL V6 - RAGE HYBRID ]]
-- NO KOREAN / ERROR FIXED / FULL FEATURES

if getgenv().HK_BEATALL_V6 then return end
getgenv().HK_BEATALL_V6 = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer

local Settings = {
    Ragebot = {Enabled = true, TargetPart = "Head"},
    SilentAim = {Enabled = true, FOV = 120},
    AntiAim = {
        Enabled = true, 
        Mode = "Orbit", 
        OrbitSpeed = 28, 
        OrbitRadius = 7.5,
        HideInFloor = false,
    },
    Exploits = {Wallbang = true, VoidSpam = true, SkinUnlock = true},
}

-- [[ 1. SKIN UNLOCK ]]
if Settings.Exploits.SkinUnlock then
    hookmetamethod(game, "__index", function(self, key)
        if not checkcaller() and (key == "HasSkin" or key == "Owned" or tostring(self):find("Skin")) then
            return true
        end
        return rawget(self, key)
    end)
end

-- [[ 2. WALLBANG (FIXED) ]]
local oldNamecall -- Define it first to fix the error
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if Settings.Exploits.Wallbang and (method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList" or method == "Raycast") then
        return nil
    end
    return oldNamecall(self, ...)
end)

-- [[ 3. MAIN ENGINE ]]
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

RunService.Heartbeat:Connect(function()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if Settings.Ragebot.Enabled then
        local target = GetClosest()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end

    if Settings.AntiAim.Enabled then
        local t = tick()
        if Settings.AntiAim.Mode == "Orbit" then
            local angle = t * Settings.AntiAim.OrbitSpeed
            local rad = Settings.AntiAim.OrbitRadius
            hrp.CFrame = CFrame.new(hrp.Position + Vector3.new(math.cos(angle) * rad, 0, math.sin(angle) * rad)) * CFrame.Angles(0, angle, 0)
        end
        if Settings.AntiAim.HideInFloor then
            hrp.CFrame = hrp.CFrame * CFrame.new(0, -1.8, 0)
        end
    end

    if Settings.Exploits.VoidSpam then
        for _, v in ipairs(workspace:GetChildren()) do
            if v:IsA("BasePart") and (v.Position - hrp.Position).Magnitude < 42 then
                pcall(function() v.AssemblyLinearVelocity = Vector3.new(0, 11000, 0) end)
            end
        end
    end
end)

print("HK.BEATALL V6 STABLE LOADED.")





