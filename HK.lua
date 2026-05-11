-- [[ HK.BEATALL V6.1 - FULL TOGGLE VERSION ]]
-- NO KOREAN / MOUSE FIXED / ALL FEATURES ON TOGGLE

if getgenv().HK_EXECUTED then return end
getgenv().HK_EXECUTED = true

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [ 1. SETTINGS (ALL DEFAULT OFF) ]
local HK_SET = {
    Rage = {Enabled = false}, -- Default OFF
    AA = {Enabled = false, Speed = 15, Radius = 6, Floor = false}, -- Default OFF
    Exploits = {Void = false, Wallbang = false, Skins = true} -- Skins is safe to keep ON
}

-- [ 2. SECURE METATABLE HOOK ]
local mt = getrawmetatable(game)
local oldIndex = mt.__index
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__index = newcclosure(function(self, key)
    if HK_SET.Exploits.Skins and not checkcaller() then
        if key == "HasSkin" or key == "Owned" or tostring(self):find("Skin") then return true end
    end
    return oldIndex(self, key)
end)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if HK_SET.Exploits.Wallbang and (method == "FindPartOnRay" or method == "Raycast") then return nil end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- [ 3. CORE ENGINE (ONLY RUNS WHEN ENABLED) ]
RS.Heartbeat:Connect(function()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- RAGEBOT
    if HK_SET.Rage.Enabled then
        local target = nil
        local dist = 150
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis then
                    local d = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if d < dist then dist = d target = p end
                end
            end
        end
        if target then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Character.Head.Position), 0.2)
        end
    end

    -- ANTI-AIM (ORBIT)
    if HK_SET.AA.Enabled then
        local t = tick()
        local angle = t * HK_SET.AA.Speed
        local off = Vector3.new(math.cos(angle)*HK_SET.AA.Radius, 0, math.sin(angle)*HK_SET.AA.Radius)
        hrp.CFrame = CFrame.new(hrp.Position + off) * CFrame.Angles(0, angle, 0)
    end

    -- VOID SPAM
    if HK_SET.Exploits.Void then
        for _, v in ipairs(workspace:GetChildren()) do
            if v:IsA("BasePart") and (v.Position - hrp.Position).Magnitude < 35 then
                pcall(function() v.AssemblyLinearVelocity = Vector3.new(0, 5000, 0) end)
            end
        end
    end
end)

-- [ 4. UI CONSTRUCTION (KICKHOOK STYLE) ]
local sg = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 400, 0, 320)
Main.Position = UDim2.new(0.5, -200, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(123, 97, 255)
Main.Active = true
Main.Draggable = true

local function CreateToggle(txt, y, callback)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0, 360, 0, 40)
    b.Position = UDim2.new(0, 20, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = txt
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Code
    b.MouseButton1Click:Connect(function()
        callback()
        b.BackgroundColor3 = b.BackgroundColor3 == Color3.fromRGB(30, 30, 30) and Color3.fromRGB(123, 97, 255) or Color3.fromRGB(30, 30, 30)
    end)
end

CreateToggle("RAGEBOT (LERP)", 60, function() HK_SET.Rage.Enabled = not HK_SET.Rage.Enabled end)
CreateToggle("VOID SPAM (BYPASS)", 110, function() HK_SET.Exploits.Void = not HK_SET.Explorts.Void end)
CreateToggle("ORBIT AA (STABLE)", 160, function() HK_SET.AA.Enabled = not HK_SET.AA.Enabled end)
CreateToggle("WALLBANG (PURE)", 210, function() HK_SET.Exploits.Wallbang = not HK_SET.Exploits.Wallbang end)

-- TOGGLE UI & MOUSE FIX
UIS.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
        UIS.MouseBehavior = Enum.MouseBehavior.Default
    end
end)

print("HK.BEATALL V6.1 FULL TOGGLE READY.")





