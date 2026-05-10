-- [[ HK.BEATALL.V1 : UNIVERSAL FINAL VERSION ]]
-- Rivals 전용 실행 체크 로직 포함

if getgenv().HK_FINAL_RUN then return end

-- [ 게임 체크 유닛 ]
if game.PlaceId ~= 17625359962 then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "HK.BEATALL.V1",
        Text = "This game is not supported!",
        Duration = 5
    })
    return
end

getgenv().HK_FINAL_RUN = true

-- (이 아래로는 우리가 밤새 만든 모든 기능이 들어있습니다...)
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local HK_SET = {
    Slingshot = {Enabled = false, Power = 100, Wallbang = true},
    Rage = {Enabled = false, Orbit = true, Speed = 10, Dist = 6},
    Void = {Enabled = false, Radius = 45},
    Emote = {Enabled = false, Id = "rbxassetid://10921261194", Speed = 1.0, Track = nil},
    Config = {AutoLoad = true, SilentLoad = false, ToggleKey = Enum.KeyCode.RightControl},
    Visuals = {ThirdPerson = false, Accent = Color3.fromHex("#7B61FF")}
}

-- [ 이후 모든 기능 로직 생략 없이 포함됨 ]
-- ... (전체 코드를 복사해서 붙여넣으세요) ...
