-- [[ HK.BEATALL.V1 : EXTREME HYBRID ENGINE ]]
-- ALL FEATURES: SLINGSHOT, VOID, DESYNC, AA(YAW/PITCH), UNDERGROUND, SKIN, DANCE, SPEED
-- NO KOREAN / MOUSE-FIXED / NO EXTERNAL LIB

if getgenv().HK_FINAL_RUN then return end
getgenv().HK_FINAL_RUN = true

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- [ 1. SETTINGS TABLE ]
local HK_SET = {
    Main = {Slingshot = false, Power = 140, Wallbang = true},
    Exploit = {Void = false, Desync = false},
    AA = {Enabled = false, Yaw = 180, Pitch = 0, Jitter = false, Underground = false},
    Misc = {Skins = true, TP = false, Dance = false, DanceSpeed = 1.0}
}

-- [ 2. CORE ENGINES (MAX PERFORMANCE) ]
RS.Heartbeat:Connect(function()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    -- A. SLINGSHOT & WALLBANG
    if HK_SET.Main.Slingshot then
        hrp.AssemblyLinearVelocity = hrp.CFrame.LookVector * HK_SET.Main.Power + Vector3.new(0, 5, 0)
        if HK_SET.Main.Wallbang then hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -1.0) end
    end

    -- B. ZERO-POINT VOID (2e308 Intensity)
    if HK_SET.Exploit.Void then
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("BasePart") and not v:IsDescendantOf(char) and (v.Position - hrp.Position).Magnitude < 60 then
                v.AssemblyLinearVelocity = Vector3.new(2e308, 2e308, 2e308)
            end
        end
    end

    -- C. ANTI-AIM & UNDERGROUND
    if HK_SET.AA.Enabled then
        if HK_SET.AA.Underground then hrp.CFrame = hrp.CFrame * CFrame.new(0, -9, 0) end
        local rj = hrp:FindFirstChild("RootJoint") or (char:FindFirstChild("LowerTorso") and char.LowerTorso:FindFirstChild("RootJoint"))
        if rj then
            local y_v = math.rad(HK_SET.AA.Yaw)
            local p_v = math.rad(HK_SET.AA.Pitch)
            if HK_SET.AA.Jitter then 
                y_v = math.rad(math.random(-180, 180)) 
                p_v = math.rad(math.random(-89, 89))
            end
            rj.C0 = CFrame.new(rj.C0.Position) * CFrame.Angles(p_v, y_v, 0)
        end
    end

    -- D. DANCE SPEED CONTROL
    if HK_SET.Misc.Dance and _G.HK_Track then
        _G.HK_Track:AdjustSpeed(HK_SET.Misc.DanceSpeed)
    end
end)

-- [ 3. UI CONSTRUCTION (PURE KICKHOOK STYLE) ]
local sg = Instance.new("ScreenGui")
pcall(function() sg.Parent = (gethui and gethui()) or CoreGui or LP:WaitForChild("PlayerGui") end)

local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 550, 0, 420)
Main.Position = UDim2.new(0.5, -275, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromHex("#7B61FF")
Main.Active = true
Main.Draggable = true

local function NewBtn(txt, pos, cb)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0, 240, 0, 35)
    b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.Text = txt
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Code
    b.MouseButton1Click:Connect(cb)
    return b
end

-- [ FEATURE BUTTONS ]
NewBtn("SLINGSHOT ENGINE", UDim2.new(0, 20, 0, 50), function() HK_SET.Main.Slingshot = not HK_SET.Main.Slingshot end)
NewBtn("VOID SPAM (MAX)", UDim2.new(0, 280, 0, 50), function() HK_SET.Exploit.Void = not HK_SET.Exploit.Void end)
NewBtn("AA: TOGGLE / JITTER", UDim2.new(0, 20, 0, 100), function() HK_SET.AA.Enabled = not HK_SET.AA.Enabled HK_SET.AA.Jitter = HK_SET.AA.Enabled end)
NewBtn("ALWAYS UNDERGROUND", UDim2.new(0, 280, 0, 100), function() HK_SET.AA.Underground = not HK_SET.AA.Underground end)
NewBtn("UNLOCK ALL SKINS", UDim2.new(0, 20, 0, 150), function() 
    pcall(function()
        local p = {LP:FindFirstChild("Inventory"), LP:FindFirstChild("Data") and LP.Data:FindFirstChild("Skins")}
        for _, path in pairs(p) do if path then for _, v in pairs(path:GetDescendants()) do if v:IsA("BoolValue") then v.Value = true end end end end
    end)
end)
NewBtn("SOLAR SYSTEM DANCE", UDim2.new(0, 280, 0, 150), function() 
    HK_SET.Misc.Dance = not HK_SET.Misc.Dance
    if _G.HK_Track then _G.HK_Track:Stop() end
    if HK_SET.Misc.Dance then
        local a = Instance.new("Animation") a.AnimationId = "rbxassetid://10921261194"
        _G.HK_Track = LP.Character.Humanoid:LoadAnimation(a)
        _G.HK_Track.Looped = true
        _G.HK_Track:Play()
    end
end)

-- [ TOGGLE ]
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.RightControl then Main.Visible = not Main.Visible UIS.MouseBehavior = Enum.MouseBehavior.Default end
end)

print("HK.BEATALL.V1 MASTER LOADED.")






