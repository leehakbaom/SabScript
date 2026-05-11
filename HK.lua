-- [[ HK.BEATALL.V1 : THE ABSOLUTE FINAL MASTER ]]
-- NO KOREAN / ALL FEATURES / AUTO-SAVE / MOUSE-FIXED
-- FEATURES: SLINGSHOT, VOID, DESYNC, AA(YAW/PITCH), UNDERGROUND, ORBIT, DANCE, SKINS

local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()

-- [ 1. SETTINGS & TABLES ]
local HK_SET = {
    Main = {Slingshot = false, Power = 120, Wallbang = true},
    Combat = {Orbit = false, Speed = 15, Radius = 8},
    Exploit = {Void = false, VoidRadius = 60, Desync = false},
    AA = {
        Enabled = false, 
        PitchMode = "Jitter", -- Down, Up, Jitter, Custom
        PitchValue = 0, 
        YawValue = 0, -- -180 to 360
        Underground = false
    },
    Dance = {Enabled = false, Id = "rbxassetid://10921261194", Speed = 1.0, Track = nil},
    Misc = {Skins = false, TP = false}
}

local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")

-- [ 2. CORE ENGINES ]
RS.Heartbeat:Connect(function()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- A. Slingshot & Wallbang
    if HK_SET.Main.Slingshot then
        hrp.AssemblyLinearVelocity = hrp.CFrame.LookVector * HK_SET.Main.Power + Vector3.new(0, 2, 0)
        if HK_SET.Main.Wallbang then hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -0.7) end
    end

    -- B. Void & Desync
    if HK_SET.Exploit.Void then
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("BasePart") and not v:IsDescendantOf(char) and (v.Position - hrp.Position).Magnitude < HK_SET.Exploit.VoidRadius then
                v.AssemblyLinearVelocity = Vector3.new(1e8, 1e8, 1e8)
            end
        end
    end
    if HK_SET.Exploit.Desync then
        hrp.CFrame = hrp.CFrame * CFrame.new(math.random(-10,10)/100, 0, math.random(-10,10)/100)
    end

    -- C. Advanced Anti-Aim & Underground (YAW/PITCH/UG)
    if HK_SET.AA.Enabled then
        if HK_SET.AA.Underground then hrp.CFrame = hrp.CFrame * CFrame.new(0, -8, 0) end
        local rj = hrp:FindFirstChild("RootJoint") or (char:FindFirstChild("LowerTorso") and char.LowerTorso:FindFirstChild("RootJoint"))
        if rj then
            local p_final = 0
            if HK_SET.AA.PitchMode == "Jitter" then p_final = math.rad(math.random(-89, 89))
            elseif HK_SET.AA.PitchMode == "Down" then p_final = math.rad(-89)
            elseif HK_SET.AA.PitchMode == "Up" then p_final = math.rad(89)
            elseif HK_SET.AA.PitchMode == "Custom" then p_final = math.rad(HK_SET.AA.PitchValue) end
            rj.C0 = CFrame.new(rj.C0.Position) * CFrame.Angles(p_final, math.rad(HK_SET.AA.YawValue), 0)
        end
    end

    -- D. Orbit
    if HK_SET.Combat.Orbit then
        local target = nil
        local dist = 500
        for _, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local d = (v.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if d < dist then dist = d target = v end
            end
        end
        if target then
            local t_hrp = target.Character.HumanoidRootPart
            local a = tick() * HK_SET.Combat.Speed
            hrp.CFrame = CFrame.new(t_hrp.Position + Vector3.new(math.cos(a) * HK_SET.Combat.Radius, 4, math.sin(a) * HK_SET.Combat.Radius), t_hrp.Position)
        end
    end

    LP.CameraMaxZoomDistance = HK_SET.Misc.TP and 60 or 0.5
end)

-- [ 3. DANCE FUNCTION ]
local function UpdateDance()
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if HK_SET.Dance.Track then HK_SET.Dance.Track:Stop() end
    if not HK_SET.Dance.Enabled then return end
    local anim = Instance.new("Animation")
    anim.AnimationId = HK_SET.Dance.Id
    HK_SET.Dance.Track = hum:LoadAnimation(anim)
    HK_SET.Dance.Track.Looped = true
    HK_SET.Dance.Track:Play()
    HK_SET.Dance.Track:AdjustSpeed(HK_SET.Dance.Speed)
end

-- [ 4. UI WINDOW ]
local Window = Rayfield:CreateWindow({
   Name = "HK.BEATALL.V1 | MASTER",
   ConfigurationSaving = {Enabled = true, FolderName = "HK_Configs", FileName = "MasterConfig"}
})

-- TABS
local TabMain = Window:CreateTab("Main", 4483362458)
local TabAA = Window:CreateTab("Anti-Aim", 4483362458)
local TabDance = Window:CreateTab("Dancing", 4483362458)
local TabMisc = Window:CreateTab("Misc/Skins", 4483362458)

-- Tab: Main
TabMain:CreateToggle({Name = "Slingshot Engine", Flag = "Sling", Callback = function(v) HK_SET.Main.Slingshot = v end})
TabMain:CreateToggle({Name = "Zero-Point Void", Flag = "Void", Callback = function(v) HK_SET.Exploit.Void = v end})
TabMain:CreateToggle({Name = "Phase Desync", Flag = "Desync", Callback = function(v) HK_SET.Exploit.Desync = v end})

-- Tab: Anti-Aim (YAW & PITCH & UNDERGROUND)
TabAA:CreateToggle({Name = "Enable Anti-Aim", Flag = "AA", Callback = function(v) HK_SET.AA.Enabled = v end})
TabAA:CreateDropdown({Name = "Pitch Mode", Options = {"Down", "Up", "Jitter", "Custom"}, CurrentOption = "Jitter", Flag = "PMode", Callback = function(v) HK_SET.AA.PitchMode = v end})
TabAA:CreateSlider({Name = "Yaw Value", Range = {-180, 360}, Increment = 1, Flag = "YawV", Callback = function(v) HK_SET.AA.YawValue = v end})
TabAA:CreateToggle({Name = "Always Underground", Flag = "UG", Callback = function(v) HK_SET.AA.Underground = v end})

-- Tab: Dancing
TabDance:CreateToggle({Name = "Solar System Dance", Flag = "Dance", Callback = function(v) HK_SET.Dance.Enabled = v UpdateDance() end})
TabDance:CreateSlider({Name = "Dance Speed", Range = {0.1, 10}, Increment = 0.1, Flag = "DanceS", Callback = function(v) HK_SET.Dance.Speed = v if HK_SET.Dance.Track then HK_SET.Dance.Track:AdjustSpeed(v) end end)

-- Tab: Misc
TabMisc:CreateButton({Name = "Unlock All Skins", Callback = function() 
    pcall(function()
        local p = {LP:FindFirstChild("Inventory"), LP:FindFirstChild("Data") and LP.Data:FindFirstChild("Skins")}
        for _, path in pairs(p) do if path then for _, v in pairs(path:GetDescendants()) do if v:IsA("BoolValue") then v.Value = true end end end end
    end)
end})
TabMisc:CreateToggle({Name = "Third Person", Flag = "TP", Callback = function(v) HK_SET.Misc.TP = v end})

Rayfield:LoadConfiguration()





