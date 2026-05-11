-- [[ HK.BEATALL.V1 : REAL RAYFIELD EDITION ]]
-- USING OFFICIAL RAYFIELD LIBRARY
-- FEATURES: EXTREME WALLBANG, PROJECTILE TP, SILENT AIM, RAGE

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "HK.BEATALL.V1 | Rivals",
   LoadingTitle = "HK.BEATALL.V1",
   LoadingSubtitle = "by Manus AI",
   ConfigurationSaving = { Enabled = true, FolderName = "HK_BEATALL", FileName = "Config" },
   KeySystem = false
})

-- [[ SETTINGS ]]
getgenv().HK_SET = {
    Combat = { SilentAim = false, Wallbang = false, ProjectileTP = false, FOV = 150 },
    Movement = { Fly = false, Speed = 16, InfJump = false, Tornado = false },
    Visuals = { Box = false, AntiFlash = false }
}

-- [[ CORE ENGINE: WALLBANG & SILENT AIM ]]
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local function GetClosestTarget()
    local target, dist = nil, getgenv().HK_SET.Combat.FOV
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if vis then
                local d = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                if d < dist then dist = d target = p end
            end
        end
    end
    return target
end

-- Hooking for Wallbang & Projectile TP
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if (getgenv().HK_SET.Combat.Wallbang or getgenv().HK_SET.Combat.SilentAim) and (method == "FindPartOnRayWithIgnoreList" or method == "Raycast") then
        local target = GetClosestTarget()
        if target then
            local headPos = target.Character.Head.Position
            if method == "FindPartOnRayWithIgnoreList" then
                args[1] = Ray.new(Camera.CFrame.Position, (headPos - Camera.CFrame.Position).Unit * 1000)
                return OldNamecall(self, unpack(args))
            end
        end
    end
    
    -- Projectile TP Logic (Simplified for Slingshot)
    if getgenv().HK_SET.Combat.ProjectileTP and method == "FireServer" and self.Name == "ProjectileRemote" then
        local target = GetClosestTarget()
        if target then
            args[1] = target.Character.Head.Position -- Teleport projectile to head
            return OldNamecall(self, unpack(args))
        end
    end
    
    return OldNamecall(self, ...)
end)

-- [[ TABS ]]
local MainTab = Window:CreateTab("Main", 4483362458)
local MoveTab = Window:CreateTab("Movement", 4483362458)

-- [[ MAIN TAB ]]
MainTab:CreateSection("Combat")
MainTab:CreateToggle({
   Name = "Extreme Wallbang",
   CurrentValue = false,
   Callback = function(Value) getgenv().HK_SET.Combat.Wallbang = Value end,
})
MainTab:CreateToggle({
   Name = "Projectile TP (Slingshot)",
   CurrentValue = false,
   Callback = function(Value) getgenv().HK_SET.Combat.ProjectileTP = Value end,
})
MainTab:CreateToggle({
   Name = "Silent Aim",
   CurrentValue = false,
   Callback = function(Value) getgenv().HK_SET.Combat.SilentAim = Value end,
})

-- [[ MOVEMENT TAB ]]
MoveTab:CreateSection("Movement")
MoveTab:CreateToggle({
   Name = "Tornado Mode",
   CurrentValue = false,
   Callback = function(Value) getgenv().HK_SET.Movement.Tornado = Value end,
})
MoveTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value) getgenv().HK_SET.Movement.InfJump = Value end,
})

-- [[ LOOP ENGINE ]]
RunService.Heartbeat:Connect(function()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if getgenv().HK_SET.Movement.Tornado then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(30), 0)
    end
end)

UIS.JumpRequest:Connect(function()
    if getgenv().HK_SET.Movement.InfJump then
        LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

Rayfield:Notify({
   Title = "HK.BEATALL.V1 REAL RAYFIELD",
   Content = "Wallbang & Projectile TP Active",
   Duration = 5,
})





