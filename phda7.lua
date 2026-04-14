-- // SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local function GetCharacter()
    return Player.Character or Player.CharacterAdded:Wait()
end

-- // GUI PRINCIPAL
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MGCHEATS_MM2"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999

-- BOTÃO MG (igual seu)
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

-- MENU
local MainMenu = Instance.new("Frame")
MainMenu.Parent = ScreenGui
MainMenu.Size = UDim2.new(0,480,0,650)
MainMenu.Position = UDim2.new(0.05,0,0.1,0)
MainMenu.BackgroundColor3 = Color3.new(0.08,0.08,0.08)
MainMenu.Visible = false
MainMenu.Active = true
MainMenu.Draggable = true

Instance.new("UICorner", MainMenu)

-- BOTÕES
ButtonMG.MouseButton1Click:Connect(function()
    MainMenu.Visible = not MainMenu.Visible
end)

-- VARIÁVEIS
_G.ESP_Player = false
_G.NameESP = false
_G.DistanceESP = false

local ESPObjects = {}

-- CRIAR ESP
local function CreateESP(player)
    if player == Player then return end

    local box = Instance.new("BoxHandleAdornment")
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Transparency = 1
    box.Parent = Workspace

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,200,0,50)
    billboard.AlwaysOnTop = true

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.new(1,1,1)
    text.Parent = billboard

    ESPObjects[player] = {
        Box = box,
        Name = billboard,
        Text = text
    }
end

-- ATUALIZAR ESP
local function UpdateESP(player)
    local esp = ESPObjects[player]
    if not esp then return end

    local char = player.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")

    if not root or not head then return end

    if _G.ESP_Player then
        esp.Box.Adornee = root
        esp.Box.Size = char:GetExtentsSize()
        esp.Box.Color3 = Color3.new(0,1,0)
        esp.Box.Visible = true

        esp.Name.Adornee = head
        esp.Name.Parent = Workspace
        esp.Name.Enabled = _G.NameESP
        esp.Text.Text = player.Name
    else
        esp.Box.Visible = false
        esp.Name.Enabled = false
    end
end

-- CRIAR PARA TODOS
for _,p in pairs(Players:GetPlayers()) do
    CreateESP(p)
end

Players.PlayerAdded:Connect(CreateESP)

-- LOOP
RunService.RenderStepped:Connect(function()
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= Player then
            UpdateESP(p)
        end
    end
end)
