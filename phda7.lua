-- // SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- // GUI PRINCIPAL
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MGCHEATS_ARENA"
pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
end

ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999

-- BOTÃO MG
local ButtonMG = Instance.new("TextButton")
ButtonMG.Parent = ScreenGui
ButtonMG.BackgroundColor3 = Color3.new(0, 0, 0)
ButtonMG.BorderColor3 = Color3.new(1, 0, 0)
ButtonMG.BorderSizePixel = 3
ButtonMG.Size = UDim2.new(0, 70, 0, 70)
ButtonMG.Position = UDim2.new(0.02, 0, 0.45, 0)
ButtonMG.Font = Enum.Font.GothamBold
ButtonMG.Text = "MG"
ButtonMG.TextColor3 = Color3.new(1, 0, 0)
ButtonMG.TextSize = 28
ButtonMG.Active = true
ButtonMG.Draggable = true

Instance.new("UICorner", ButtonMG).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ButtonMG).Color = Color3.new(1, 0, 0)

-- FOV
local FOVCircle = Instance.new("Frame")
FOVCircle.Parent = ScreenGui
FOVCircle.BackgroundTransparency = 1
FOVCircle.Size = UDim2.new(0, 200, 0, 200)
FOVCircle.Position = UDim2.new(0.5, -100, 0.5, -100)
FOVCircle.Visible = false

local Circle = Instance.new("ImageLabel", FOVCircle)
Circle.BackgroundTransparency = 1
Circle.Size = UDim2.new(1, 0, 1, 0)
Circle.Image = "rbxassetid://2658958756"
Circle.ImageColor3 = Color3.new(0.5, 0, 1)
Circle.ImageTransparency = 0.4

-- MENU
local MainMenu = Instance.new("Frame")
MainMenu.Parent = ScreenGui
MainMenu.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
MainMenu.BorderColor3 = Color3.new(0.5, 0, 1)
MainMenu.BorderSizePixel = 3
MainMenu.Size = UDim2.new(0, 400, 0, 350)
MainMenu.Position = UDim2.new(0.05, 0, 0.1, 0)
MainMenu.Visible = false
MainMenu.Active = true
MainMenu.Draggable = true

Instance.new("UICorner", MainMenu).CornerRadius = UDim.new(0, 12)

-- BOTÕES MENU
local BtnClose = Instance.new("TextButton", MainMenu)
BtnClose.Size = UDim2.new(0, 35, 0, 30)
BtnClose.Position = UDim2.new(1, -40, 0, 5)
BtnClose.Text = "X"

-- VARIAVEIS
_G.Aimbot = false
_G.ShowFOV = false
_G.ESP_Box = false
_G.ESP_Line = false

local Y = 50
local ESPObjects = {}

-- FUNÇÃO BOTÃO
local function CreateOption(Name, Var)
    local Btn = Instance.new("TextButton")
    Btn.Parent = MainMenu
    Btn.Size = UDim2.new(0.9, 0, 0, 40)
    Btn.Position = UDim2.new(0.05, 0, 0, Y)
    Btn.Text = Name
    Y += 45

    Btn.MouseButton1Click:Connect(function()
        _G[Var] = not _G[Var]
        Btn.BackgroundColor3 = _G[Var] and Color3.new(0,1,0) or Color3.new(0.2,0.2,0.2)
    end)
end

CreateOption("Aimbot", "Aimbot")
CreateOption("FOV", "ShowFOV")
CreateOption("ESP Linha", "ESP_Line")
CreateOption("ESP Caixa", "ESP_Box")

-- ABRIR MENU
ButtonMG.MouseButton1Click:Connect(function()
    MainMenu.Visible = not MainMenu.Visible
end)

BtnClose.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- AIMBOT
RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = _G.ShowFOV

    if _G.Aimbot and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local Closest, Dist = nil, math.huge

        for _, v in pairs(Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
                local d = (Player.Character.HumanoidRootPart.Position - v.Character.Head.Position).Magnitude
                if d < Dist then
                    Dist = d
                    Closest = v
                end
            end
        end

        if Closest and Closest.Character and Closest.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Closest.Character.Head.Position)
        end
    end
end)

-- ESP
local function CreateESP(p)
    local box = Instance.new("BoxHandleAdornment", Workspace)
    box.AlwaysOnTop = true
    box.Color3 = Color3.new(0,1,0)

    local line = Instance.new("LineHandleAdornment", Workspace)
    line.AlwaysOnTop = true
    line.Color3 = Color3.new(1,0,0)

    ESPObjects[p] = {Box = box, Line = line}
end

RunService.Heartbeat:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player then
            if not ESPObjects[p] then
                CreateESP(p)
            end

            local char = p.Character
            local esp = ESPObjects[p]

            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") then
                esp.Box.Size = Vector3.new(2,3,1)
                esp.Box.CFrame = char.HumanoidRootPart.CFrame
                esp.Box.Visible = _G.ESP_Box

                esp.Line.From = Camera.CFrame.Position
                esp.Line.To = char.Head.Position
                esp.Line.Visible = _G.ESP_Line
            else
                esp.Box.Visible = false
                esp.Line.Visible = false
            end
        end
    end
end)

print("OK")
