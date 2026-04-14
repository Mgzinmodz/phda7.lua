-- // SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService") -- CORRIGIDO (era Game)
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- // GUI PRINCIPAL
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MGCHEATS_ARENA"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999

-- ==============================================
-- // BOTÃO FLUTUANTE VERMELHO
-- ==============================================
local ButtonMG = Instance.new("TextButton")
ButtonMG.Name = "ButtonMG"
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

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(1, 0)
UICornerBtn.Parent = ButtonMG

local UIStrokeBtn = Instance.new("UIStroke")
UIStrokeBtn.Thickness = 3
UIStrokeBtn.Color = Color3.new(1, 0, 0)
UIStrokeBtn.Parent = ButtonMG

-- ==============================================
-- // CIRCULO DO FOV ROXO (LINHA)
-- ==============================================
local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOVCircle"
FOVCircle.Parent = ScreenGui
FOVCircle.BackgroundTransparency = 1
FOVCircle.Size = UDim2.new(0, 300, 0, 300)
FOVCircle.Position = UDim2.new(0.5, -150, 0.5, -150)
FOVCircle.Visible = false

local Circle = Instance.new("ImageLabel")
Circle.Name = "Circle"
Circle.Parent = FOVCircle
Circle.BackgroundTransparency = 1
Circle.Size = UDim2.new(1, 0, 1, 0)
Circle.Position = UDim2.new(0,0,0,0)
Circle.Image = "rbxassetid://2658958756"
Circle.ImageColor3 = Color3.new(0.5, 0, 1)
Circle.ImageTransparency = 0.3
Circle.ZIndex = 10

-- ==============================================
-- // MENU PRINCIPAL
-- ==============================================
local MainMenu = Instance.new("Frame")
MainMenu.Name = "MainMenu"
MainMenu.Parent = ScreenGui
MainMenu.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
MainMenu.BorderColor3 = Color3.new(0.5, 0, 1)
MainMenu.BorderSizePixel = 3
MainMenu.Size = UDim2.new(0, 400, 0, 400)
MainMenu.Position = UDim2.new(0.05, 0, 0.1, 0)
MainMenu.Active = true
MainMenu.Draggable = true
MainMenu.Visible = false

local UICornerMenu = Instance.new("UICorner")
UICornerMenu.CornerRadius = UDim.new(0, 12)
UICornerMenu.Parent = MainMenu

-- ==============================================
-- // TOPO
-- ==============================================
local TopBar = Instance.new("Frame")
TopBar.Parent = MainMenu
TopBar.BackgroundColor3 = Color3.new(0,0,0)
TopBar.BorderColor3 = Color3.new(0.5, 0, 1)
TopBar.Size = UDim2.new(1, 0, 0, 40)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0,10,0,0)
Title.Font = Enum.Font.GothamBold
Title.Text = "★ MGCHEATS ★"
Title.TextColor3 = Color3.new(0.2, 1, 1)
Title.TextSize = 20

local BtnMinimize = Instance.new("TextButton")
BtnMinimize.Parent = TopBar
BtnMinimize.Size = UDim2.new(0, 35, 0, 30)
BtnMinimize.Position = UDim2.new(1, -75, 0, 2)
BtnMinimize.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
BtnMinimize.Text = "-"

local BtnClose = Instance.new("TextButton")
BtnClose.Parent = TopBar
BtnClose.Size = UDim2.new(0, 35, 0, 30)
BtnClose.Position = UDim2.new(1, -40, 0, 2)
BtnClose.BackgroundColor3 = Color3.new(0.5, 0, 0)
BtnClose.Text = "X"

-- ==============================================
-- // VARIAVEIS
-- ==============================================
_G.Aimbot = false
_G.ShowFOV = false
_G.ESP_Box = false
_G.ESP_Line = false

local Y = 55
local ESPObjects = {}

-- ==============================================
-- // FUNÇÕES UI
-- ==============================================
local function CreateOption(Name, VarName, Emoji)
    local Frame = Instance.new("Frame")
    Frame.Parent = MainMenu
    Frame.Size = UDim2.new(0.9, 0, 0, 45)
    Frame.Position = UDim2.new(0.05, 0, 0, Y)
    Y = Y + 55

    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Text = Emoji.."  "..Name

    local Toggle = Instance.new("TextButton")
    Toggle.Parent = Frame
    Toggle.Size = UDim2.new(0, 30, 0, 30)
    Toggle.Position = UDim2.new(0.85, 0, 0.5, -15)

    Toggle.MouseButton1Click:Connect(function()
        _G[VarName] = not _G[VarName]
        Toggle.BackgroundColor3 = _G[VarName] and Color3.new(0,1,0) or Color3.new(0.2,0.2,0.2)
    end)
end

-- OPÇÕES
CreateOption("Aimbot", "Aimbot", "🎯")
CreateOption("Exibir círculo FOV", "ShowFOV", "🟣")
CreateOption("ESP LINE", "ESP_Line", "🔴")
CreateOption("ESP Caixa", "ESP_Box", "🟩")

-- LOGICA
ButtonMG.MouseButton1Click:Connect(function()
    MainMenu.Visible = not MainMenu.Visible
end)

BtnClose.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

BtnMinimize.MouseButton1Click:Connect(function()
    MainMenu.Visible = false
end)

-- AIMBOT + SEGURANÇA
RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = _G.ShowFOV

    if _G.Aimbot and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local Closest = nil
        local MaxDistance = 200

        for _, v in pairs(Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
                local Dist = (Player.Character.HumanoidRootPart.Position - v.Character.Head.Position).Magnitude
                if Dist < MaxDistance then
                    MaxDistance = Dist
                    Closest = v
                end
            end
        end

        if Closest and Closest.Character and Closest.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Closest.Character.Head.Position)
        end
    end
end)

print("✅ MGCHEATS CARREGADO!")
