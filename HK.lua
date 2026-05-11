-- [[ HK.BEATALL.V1 : THE ULTIMATE MASTER ]]
-- CONCEPT: UNNAMED GAUGE + KICKHOOK BYPASS HYBRID
-- FEATURES: VOID, DESYNC, SLINGSHOT, ANTI-AIM, SKIN UNLOCK
-- SECURITY: NO KOREAN / MOUSE-FIXED / PC-MOBILE SUPPORT

if getgenv().HK_FINAL_RUN then return end
getgenv().HK_FINAL_RUN = true

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- [ 1. INTEGRATED SETTINGS ]
local HK_SET = {
    Main = {Slingshot = false, Power = 100, Wallbang = true},
    Exploit = {Void = false, Desync = false, VoidRadius = 50},
    AA = {Enabled = false, Pitch = "Jitter", Yaw = 180, Underground = false},
    Misc = {Skins = true, TP = false, EmoteSpeed = 1.0},
    Visuals = {Accent = Color3.fromHex("#7B61FF"), Visible = true}
}

-- [ 2. MOUSE & UI FIX ]
UIS.MouseIconEnabled = true
UIS.MouseBehavior = Enum.MouseBehavior.Default

-- [ 3. CORE HYBRID ENGINE (Based on Video Analysis) ]
RS.Heartbeat:Connect(function()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- SLINGSHOT & WALLBANG (Unnamed Killer)
    if HK_SET.Main.Slingshot then
        hrp.AssemblyLinearVelocity = hrp.CFrame.LookVector * HK_SET.Main.Power + Vector3.new(0, 2, 0)
        if HK_SET.Main.Wallbang then hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -0.7) end
    end

    -- ZERO-POINT VOID (Physics Pollution)
    if HK_SET.Exploit.Void then
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("BasePart") and not v:IsDescendantOf(char) then
                if (v.Position - hrp.Position).Magnitude < HK_SET.Exploit.VoidRadius then
                    v.AssemblyLinearVelocity = Vector3.new(1e8, 1e8, 1e8)
                end
            end
        end
    end

    -- PHASE-SHIFT / DESYNC (Ghosting)
    if HK_SET.Exploit.Desync then
        hrp.CFrame = hrp.CFrame * CFrame.new(math.random(-10,10)/100, 0, math.random(-10,10)/100)
    end

    -- ANTI-AIM & ALWAYS UNDERGROUND
    if HK_SET.AA.Enabled then
        if HK_SET.AA.Underground then hrp.CFrame = hrp.CFrame * CFrame.new(0, -8, 0) end
        local rj = hrp:FindFirstChild("RootJoint") or (char:FindFirstChild("LowerTorso") and char.LowerTorso:FindFirstChild("RootJoint"))
        if rj then
            local pv = (HK_SET.AA.Pitch == "Jitter" and math.random(-89, 89) or -89)
            rj.C0 = CFrame.new(rj.C0.Position) * CFrame.Angles(math.rad(pv), math.rad(HK_SET.AA.Yaw), 0)
        end
    end

    -- 3RD PERSON
    LP.CameraMaxZoomDistance = HK_SET.Misc.TP and 50 or 0.5
    LP.CameraMinZoomDistance = HK_SET.Misc.TP and 20 or 0.5
end)

-- [ 4. FINAL MASTER UI (Full Buttons) ]
local sg = Instance.new("ScreenGui")
pcall(function() sg.Parent = (gethui and gethui()) or CoreGui or LP:WaitForChild("PlayerGui") end)

local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 520, 0, 420)
Main.Position = UDim2.new(0.5, -260, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 2
Main.BorderColor3 = HK_SET.Visuals.Accent
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = HK_SET.Visuals.Accent
Title.Text = "  HK.BEATALL.V1 | MASTER VERSION"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.Code
Title.TextXAlignment = Enum.TextXAlignment.Left

local function CreateBtn(txt, pos, callback)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0, 230, 0, 40)
    b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = txt
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Code
    b.MouseButton1Click:Connect(callback)
    return b
end

-- BUTTON LAYOUT
CreateBtn("SLINGSHOT: TOGGLE", UDim2.new(0, 20, 0, 60), function() HK_SET.Main.Slingshot = not HK_SET.Main.Slingshot end)
CreateBtn("VOID SPAM: TOGGLE", UDim2.new(0, 270, 0, 60), function() HK_SET.Exploit.Void = not HK_SET.Exploit.Void end)
CreateBtn("PHASE DESYNC: TOGGLE", UDim2.new(0, 20, 0, 110), function() HK_SET.Exploit.Desync = not HK_SET.Exploit.Desync end)
CreateBtn("ANTI-AIM: TOGGLE", UDim2.new(0, 270, 0, 110), function() HK_SET.AA.Enabled = not HK_SET.AA.Enabled end)
CreateBtn("ALWAYS UNDERGROUND", UDim2.new(0, 20, 0, 160), function() HK_SET.AA.Underground = not HK_SET.AA.Underground end)
CreateBtn("3RD PERSON: TOGGLE", UDim2.new(0, 270, 0, 160), function() HK_SET.Misc.TP = not HK_SET.Misc.TP end)

-- MOUSE FIX ON TOGGLE
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
        UIS.MouseBehavior = Enum.MouseBehavior.Default
    end
end)

local MobBtn = Instance.new("TextButton", sg)
MobBtn.Size = UDim2.new(0, 45, 0, 45)
MobBtn.Position = UDim2.new(0, 10, 0.5, -22)
MobBtn.Text = "HK"
MobBtn.BackgroundColor3 = HK_SET.Visuals.Accent
Instance.new("UICorner", MobBtn).CornerRadius = UDim.new(1, 0)
MobBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible UIS.MouseBehavior = Enum.MouseBehavior.Default end)

print("HK.BEATALL.V1 MASTER LOADED.")




