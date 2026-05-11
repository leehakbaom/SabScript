-- [[ HK.BEATALL V6 - STABILIZED RAGE ]]
-- FIXED: INFINITE ERROR LOOP & SCREEN FREEZE
-- NO KOREAN / NO ERRORS

if getgenv().HK_EXECUTED then return end
getgenv().HK_EXECUTED = true

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Settings = {
    Rage = {Enabled = true},
    Silent = {Enabled = true, FOV = 130},
    AA = {Enabled = true, Orbit = true, Speed = 30, Radius = 8, Floor = false},
    Exploits = {Wallbang = true, Void = true, Skins = true}
}

-- [[ 1. SAFE METATABLE HOOKING ]]
local mt = getrawmetatable(game)
local oldIndex = mt.__index
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__index = newcclosure(function(self, key)
    if Settings.Exploits.Skins and not checkcaller() then
        if key == "HasSkin" or key == "Owned" or tostring(self):find("Skin") then
            return true
        end
    end
    return oldIndex(self, key)
end)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if Settings.Exploits.Wallbang and (method == "FindPartOnRay" or method == "Raycast") then
        return nil
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- [[ 2. TARGETING SYSTEM ]]
local function GetTarget()
    local target, dist = nil, Settings.Silent.FOV
    local mouse = UIS:GetMouseLocation()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            local d = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
            if vis and d < dist then
                dist = d
                target = p
            end
        end
    end
    return target
end

-- [[ 3. MAIN LOOP (ERROR-FREE) ]]
RS.Heartbeat:Connect(function()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Ragebot
    if Settings.Rage.Enabled then
        local t = GetTarget()
        if t and t.Character and t.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position)
        end
    end

    -- Anti-Aim (Orbit & Floor)
    if Settings.AA.Enabled then
        local t = tick()
        if Settings.AA.Orbit then
            local angle = t * Settings.AA.Speed
            local off = Vector3.new(math.cos(angle)*Settings.AA.Radius, 0, math.sin(angle)*Settings.AA.Radius)
            hrp.CFrame = CFrame.new(hrp.Position + off) * CFrame.Angles(0, angle, 0)
        end
        if Settings.AA.Floor then
            hrp.CFrame = hrp.CFrame * CFrame.new(0, -1.8, 0)
        end
    end

    -- Void Spam
    if Settings.Exploits.Void then
        for _, v in ipairs(workspace:GetChildren()) do
            if v:IsA("BasePart") and (v.Position - hrp.Position).Magnitude < 40 then
                pcall(function() v.AssemblyLinearVelocity = Vector3.new(0, 12000, 0) end)
            end
        end
    end
end)

-- [[ 4. MINIMAL UI ]]
local sg = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
local m = Instance.new("Frame", sg)
m.Size, m.Position = UDim2.new(0, 400, 0, 300), UDim2.new(0.5, -200, 0.5, -150)
m.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
m.Visible = true

local function Add(txt, y, cb)
    local b = Instance.new("TextButton", m)
    b.Size, b.Position = UDim2.new(0, 360, 0, 40), UDim2.new(0, 20, 0, y)
    b.Text, b.BackgroundColor3 = txt, Color3.fromRGB(40, 40, 40)
    b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(cb)
end

Add("TOGGLE RAGE", 60, function() Settings.Rage.Enabled = not Settings.Rage.Enabled end)
Add("TOGGLE VOID", 110, function() Settings.Exploits.Void = not Settings.Exploits.Void end)
Add("TOGGLE AA", 160, function() Settings.AA.Enabled = not Settings.AA.Enabled end)

UIS.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.RightControl then m.Visible = not m.Visible end end)
print("HK LOADED.")





