-- // SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService") -- CORRIGIDO
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Proteção contra personagem não carregado
if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then
    Player.CharacterAdded:Wait()
end

-- // GUI PRINCIPAL
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MGCHEATS_ARENA"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999

-- BOTÃO
local ButtonMG = Instance.new("TextButton")
ButtonMG.Parent = ScreenGui
ButtonMG.Size = UDim2.new(0,70,0,70)
ButtonMG.Position = UDim2.new(0.02,0,0.45,0)
ButtonMG.Text = "MG"
ButtonMG.BackgroundColor3 = Color3.new(0,0,0)
ButtonMG.TextColor3 = Color3.new(1,0,0)
ButtonMG.Active = true
ButtonMG.Draggable = true

Instance.new("UICorner", ButtonMG).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", ButtonMG).Color = Color3.new(1,0,0)

-- FOV
local FOVCircle = Instance.new("Frame")
FOVCircle.Parent = ScreenGui
FOVCircle.Size = UDim2.new(0,300,0,300)
FOVCircle.Position = UDim2.new(0.5,-150,0.5,-150)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = false

Instance.new("UICorner", FOVCircle).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", FOVCircle).Color = Color3.new(1,1,1)

-- MENU
local MainMenu = Instance.new("Frame")
MainMenu.Parent = ScreenGui
MainMenu.Size = UDim2.new(0,400,0,400)
MainMenu.Position = UDim2.new(0.05,0,0.1,0)
MainMenu.Visible = false
MainMenu.Active = true
MainMenu.Draggable = true
MainMenu.BackgroundColor3 = Color3.new(0.1,0.1,0.1)

-- VARIÁVEIS
_G.Aimbot = false
_G.ShowFOV = false
_G.FOV_Size = 300
_G.ESP_Box = false
_G.ESP_Line = false

local ESPObjects = {}

-- BOTÕES
ButtonMG.MouseButton1Click:Connect(function()
    MainMenu.Visible = not MainMenu.Visible
end)

-- AIMBOT + FOV
RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = _G.ShowFOV
    FOVCircle.Size = UDim2.new(0,_G.FOV_Size,0,_G.FOV_Size)
    FOVCircle.Position = UDim2.new(0.5,-_G.FOV_Size/2,0.5,-_G.FOV_Size/2)

    if _G.Aimbot and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local Closest = nil
        local MaxDistance = 200

        for _,v in pairs(Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
                local Dist = (Player.Character.HumanoidRootPart.Position - v.Character.Head.Position).Magnitude
                if Dist < MaxDistance then
                    MaxDistance = Dist
                    Closest = v
                end
            end
        end

        if Closest and Closest.Character then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Closest.Character.Head.Position)
        end
    end
end)

print("✅ MGCHEATS CARREGADO!")
