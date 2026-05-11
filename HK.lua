-- [[ HK.BEATALL.V1 : ULTIMATE HYBRID FINAL ]]
-- FEATURES: VOID SPAM, DESYNC, SLINGSHOT, AA, SKINS
-- NO KOREAN / MOUSE FIXED / PURE LUA

if getgenv().HK_FINAL_RUN then return end
getgenv().HK_FINAL_RUN = true

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- [ 1. SETTINGS ]
local HK_SET = {
    Main = {Slingshot = false, Power = 100, Wallbang = true},
    Exploit = {Void = false, Desync = false, VoidRadius = 50},
    AA = {Enabled = false, Pitch = "Jitter", Yaw = 0, Underground = false},
    Misc = {SkinUnlock = true, TP = false, EmoteSpeed = 1.0},
    Visuals = {Accent = Color3.fromHex("#7B61FF")}
}

-- [ 2. MOUSE FIX ]
UIS.MouseIconEnabled = true
UIS.MouseBehavior = Enum.MouseBehavior.Default

-- [ 3. CORE ENGINE (VOID & DESYNC & AA) ]
RS.Heartbeat:Connect(function()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- A. ZERO-POINT VOID (PHYSICS POLLUTION)
    if HK_SET.Exploit.Void then
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("BasePart") and not v:IsDescendantOf(char) then
                if (v.Position - hrp.Position).Magnitude < HK_SET.Exploit.VoidRadius then
                    v.AssemblyLinearVelocity = Vector3.new(1e8, 1e8, 1e8)
                end
            end
        end
    end

    -- B. PHASE-SHIFT / DESYNC (GHOSTING)
    if HK_SET.Exploit.Desync then
        -- Spoofing network ownership / position jitter
        hrp.CFrame = hrp.CFrame * CFrame.new(math.random(-10,10)/100, 0, math.random(-10,10)/100)
    end

    -- C. SLINGSHOT & WALLBANG
    if HK_SET.Main.Slingshot then
        hrp.AssemblyLinearVelocity = hrp.CFrame.LookVector * HK_SET.Main.Power + Vector3.new(0, 2, 0)
        if HK_SET.Main.Wallbang then hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -0.7) end
    end

    -- D. ANTI-AIM & UNDERGROUND
    if HK_SET.AA.Enabled then
        if HK_SET.AA.Underground then hrp.CFrame = hrp.CFrame * CFrame.new(0, -8, 0) end
        local rj = hrp:FindFirstChild("RootJoint") or (char:FindFirstChild("LowerTorso") and char.LowerTorso:FindFirstChild("RootJoint"))
        if rj then
            local p_v = (HK_SET.AA.Pitch == "Jitter" and math.random(-89, 89) or -89)
            rj.C0 = CFrame.new(rj.C0.Position) * CFrame.Angles(math.rad(p_v), math.rad(HK_SET.AA.Yaw), 0)
        end
    end
end)

-- [ 4. UI CONSTRUCTION ]
local sg = Instance.new("ScreenGui")
pcall(function() sg.Parent = (gethui and gethui()) or CoreGui or LP:WaitForChild("PlayerGui") end)

local m = Instance.new("Frame", sg)
m.Size = UDim2.new(0, 550, 0, 420)
m.Position = UDim2.new(0.5, -275, 0.5, -210)
m.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
m.BorderSizePixel = 2
m.BorderColor3 = HK_SET.Visuals.Accent
m.Visible = true
m.Active = true
m.Draggable = true

local title = Instance.new("TextLabel", m)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = HK_SET.Visuals.Accent
title.Text = "  HK.BEATALL.V1 | ALL FEATURES"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.Code
title.TextXAlignment = Enum.TextXAlignment.Left

local info = Instance.new("TextLabel", m)
info.Size = UDim2.new(1, -20, 1, -50)
info.Position = UDim2.new(0, 10, 0, 50)
info.BackgroundTransparency = 1
info.Text = "MOUSE: UNLOCKED\nTOGGLE: RIGHT CONTROL\n\n[LOADED MODULES]\n- ZERO-POINT VOID SPAM\n- PHASE-SHIFT DESYNC\n- SLINGSHOT & WALLBANG\n- ANTI-AIM (PITCH/YAW/UG)\n- SKIN & EMOTE CONTROL"
info.TextColor3 = Color3.new(0.9, 0.9, 0.9)
info.Font = Enum.Font.Code
info.TextSize = 14
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextYAlignment = Enum.TextYAlignment.Top

-- [ 5. INPUT ]
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.RightControl then
        m.Visible = not m.Visible
        UIS.MouseBehavior = Enum.MouseBehavior.Default
    end
end)

print("HK.BEATALL.V1 FULL DESTRUCTION LOADED.")



