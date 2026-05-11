-- [[ HK.BEATALL.V1 : ULTIMATE RIVALS ENHANCEMENT ]]
-- PURE ENGLISH VERSION / NO KOREAN
-- FEATURES: ADVANCED FLIGHT, STABILIZED ORBIT, TRUE WALLBANG
-- TOGGLE: RIGHT SHIFT

if getgenv().HK_EXECUTED then return end
getgenv().HK_EXECUTED = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ GLOBAL SETTINGS ]]
getgenv().HK_SET = {
    Combat = { SilentAim = false, Wallbang = false, FOV = 150 },
    Defense = { Jitter = false, Desync = false, Roll = false },
    Movement = { Flight = false, Orbit = false, Speed = 25 },
    Misc = { UnlockAll = false }
}

-- [[ CORE ENGINE: SILENT AIM & WALLBANG ]]
local function GetClosestTarget()
    local target, dist = nil, getgenv().HK_SET.Combat.FOV
    local mouse = UserInputService:GetMouseLocation()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if vis then
                local d = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                if d < dist then dist = d target = p end
            end
        end
    end
    return target
end

local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if (getgenv().HK_SET.Combat.SilentAim or getgenv().HK_SET.Combat.Wallbang) and (method == "FindPartOnRayWithIgnoreList" or method == "Raycast") then
        local target = GetClosestTarget()
        if target then
            local headPos = target.Character.Head.Position
            if method == "FindPartOnRayWithIgnoreList" then
                args[1] = Ray.new(Camera.CFrame.Position, (headPos - Camera.CFrame.Position).Unit * 1000)
                return OldNamecall(self, unpack(args))
            end
        end
    end
    return OldNamecall(self, ...)
end)

-- [[ PHYSICS ENGINE: FLIGHT, ORBIT, DESYNC ]]
RunService.Heartbeat:Connect(function()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Safe Desync
    if getgenv().HK_SET.Defense.Desync then
        hrp.Velocity = Vector3.new(math.random(-100, 100), 0, math.random(-100, 100))
    end

    -- Advanced WASD Flight
    if getgenv().HK_SET.Movement.Flight then
        local moveDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        hrp.Velocity = moveDir * getgenv().HK_SET.Movement.Speed * 2
        hrp.CFrame = hrp.CFrame + (moveDir * 0.5)
    end

    -- Stabilized Orbit (Kicia Style)
    if getgenv().HK_SET.Movement.Orbit then
        local target = GetClosestTarget()
        if target and target.Character:FindFirstChild("HumanoidRootPart") then
            local t_hrp = target.Character.HumanoidRootPart
            local t = tick() * 15
            local offset = Vector3.new(math.cos(t) * 10, 5, math.sin(t) * 10)
            hrp.CFrame = CFrame.new(t_hrp.Position + offset, t_hrp.Position)
            hrp.Velocity = Vector3.zero
        end
    end

    -- Kicia Roll
    if getgenv().HK_SET.Defense.Roll then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, 0, math.rad(math.sin(tick() * 15) * 60))
    end
end)

-- [[ UI LIBRARY (HK STYLE) ]]
local Library = {}
function Library:Init()
    local ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size, Main.Position = UDim2.new(0, 560, 0, 480), UDim2.new(0.5, -280, 0.5, -240)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Instance.new("UICorner", Main)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(123, 97, 255)

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size, Sidebar.BackgroundColor3 = UDim2.new(0, 150, 1, 0), Color3.fromRGB(8, 8, 8)
    Instance.new("UICorner", Sidebar)

    local Title = Instance.new("TextLabel", Sidebar)
    Title.Size, Title.Text = UDim2.new(1, 0, 0, 60), "HK.BEATALL.V1"
    Title.Font, Title.TextColor3 = Enum.Font.GothamBold, Color3.fromRGB(123, 97, 255)
    Title.TextSize, Title.BackgroundTransparency = 18, 1

    local Content = Instance.new("Frame", Main)
    Content.Position, Content.Size = UDim2.new(0, 160, 0, 10), UDim2.new(1, -170, 1, -20)
    Content.BackgroundTransparency = 1

    local TabContainer = Instance.new("Frame", Sidebar)
    TabContainer.Position, TabContainer.Size = UDim2.new(0, 0, 0, 70), UDim2.new(1, 0, 1, -70)
    TabContainer.BackgroundTransparency = 1
    Instance.new("UIListLayout", TabContainer).HorizontalAlignment = Enum.HorizontalAlignment.Center

    function Library:CreateTab(name)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size, TabBtn.BackgroundColor3 = UDim2.new(0, 130, 0, 35), Color3.fromRGB(20, 20, 20)
        TabBtn.Text, TabBtn.TextColor3 = name, Color3.fromRGB(200, 200, 200)
        TabBtn.Font = Enum.Font.GothamBold
        Instance.new("UICorner", TabBtn)

        local Page = Instance.new("ScrollingFrame", Content)
        Page.Size, Page.Visible = UDim2.new(1, 0, 1, 0), false
        Page.BackgroundTransparency, Page.ScrollBarThickness = 1, 0
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Content:GetChildren()) do v.Visible = false end
            Page.Visible = true
        end)

        local Elements = {}
        function Elements:CreateToggle(text, config, key)
            local Toggle = Instance.new("TextButton", Page)
            Toggle.Size, Toggle.BackgroundColor3 = UDim2.new(1, 0, 0, 40), Color3.fromRGB(25, 25, 25)
            Toggle.Text, Toggle.TextColor3 = "  " .. text, Color3.new(1, 1, 1)
            Toggle.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Toggle)
            Toggle.MouseButton1Click:Connect(function()
                config[key] = not config[key]
                Toggle.BackgroundColor3 = config[key] and Color3.fromRGB(123, 97, 255) or Color3.fromRGB(25, 25, 25)
            end)
        end
        return Elements
    end
    UserInputService.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.RightShift then Main.Visible = not Main.Visible end end)
    return Library
end

-- [[ INITIALIZE ]]
local Lib = Library:Init()
local Combat = Lib:CreateTab("Combat")
Combat:CreateToggle("Silent Aim", getgenv().HK_SET.Combat, "SilentAim")
Combat:CreateToggle("Wallbang", getgenv().HK_SET.Combat, "Wallbang")

local Defense = Lib:CreateTab("Defense")
Defense:CreateToggle("Safe Desync", getgenv().HK_SET.Defense, "Desync")
Defense:CreateToggle("Kicia Roll", getgenv().HK_SET.Defense, "Roll")

local Move = Lib:CreateTab("Movement")
Move:CreateToggle("WASD Flight", getgenv().HK_SET.Movement, "Flight")
Move:CreateToggle("Target Orbit", getgenv().HK_SET.Movement, "Orbit")

print("HK.BEATALL.V1 GLOBAL MASTER LOADED.")




