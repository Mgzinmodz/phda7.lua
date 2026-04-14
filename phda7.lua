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
ScreenGui.Name = "MGCHEATS_MM2"
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
ButtonMG.BorderColor3 = Color3.new(1,0,0)
ButtonMG.TextColor3 = Color3.new(1,0,0)
ButtonMG.Active = true
ButtonMG.Draggable = true

Instance.new("UICorner", ButtonMG).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", ButtonMG).Color = Color3.new(1,0,0)

-- MENU
local MainMenu = Instance.new("Frame")
MainMenu.Parent = ScreenGui
MainMenu.Size = UDim2.new(0,480,0,680)
MainMenu.Position = UDim2.new(0.05,0,0.1,0)
MainMenu.Visible = false
MainMenu.BackgroundColor3 = Color3.new(0.08,0.08,0.08)
MainMenu.Active = true
MainMenu.Draggable = true

Instance.new("UICorner", MainMenu)

-- VARS
_G.ESP_Sheriff = false
_G.ESP_Murder = false
_G.ESP_Player = false
_G.NameESP = false
_G.DistanceESP = false

local ESPObjects = {}

-- FUNÇÃO ROLE
local function GetRole(player)
    local role = "Player"
    local ls = player:FindFirstChild("leaderstats")
    if ls and ls:FindFirstChild("Role") then
        role = ls.Role.Value
    end
    return role
end

-- CREATE ESP
local function CreateESP(player)
    if player == Player then return end

    local esp = {}

    esp.Box = Instance.new("BoxHandleAdornment")
    esp.Box.Parent = Workspace
    esp.Box.AlwaysOnTop = true

    esp.Name = Instance.new("BillboardGui")
    esp.Name.Size = UDim2.new(0,200,0,50)
    esp.Name.AlwaysOnTop = true

    local txt = Instance.new("TextLabel", esp.Name)
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1

    esp.NameText = txt
    esp.Name.Parent = Workspace

    esp.Distance = Instance.new("BillboardGui")
    esp.Distance.Size = UDim2.new(0,100,0,30)
    esp.Distance.AlwaysOnTop = true

    local dist = Instance.new("TextLabel", esp.Distance)
    dist.Size = UDim2.new(1,0,1,0)
    dist.BackgroundTransparency = 1

    esp.DistText = dist
    esp.Distance.Parent = Workspace

    ESPObjects[player] = esp
end

-- UPDATE ESP
local function UpdateESP(player)
    if not ESPObjects[player] then return end

    local char = player.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChild("Humanoid")

    if not root or not head or not hum or hum.Health <= 0 then return end

    local role = GetRole(player)
    local showESP = false
    local color = Color3.new(0,1,0)

    if role == "Sheriff" and _G.ESP_Sheriff then
        color = Color3.new(0,0.5,1)
        showESP = true
    elseif role == "Murderer" and _G.ESP_Murder then
        color = Color3.new(1,0,0)
        showESP = true
    elseif _G.ESP_Player then
        showESP = true
    end

    -- BOX
    ESPObjects[player].Box.Adornee = char
    ESPObjects[player].Box.Color3 = color
    ESPObjects[player].Box.Visible = showESP

    -- NAME
    ESPObjects[player].Name.Adornee = head
    ESPObjects[player].Name.Enabled = showESP and _G.NameESP
    ESPObjects[player].NameText.Text = player.Name

    -- DISTANCIA
    local localChar = Player.Character
    if localChar and localChar:FindFirstChild("HumanoidRootPart") then
        local dist = (localChar.HumanoidRootPart.Position - root.Position).Magnitude
        ESPObjects[player].Distance.Adornee = head
        ESPObjects[player].Distance.Enabled = showESP and _G.DistanceESP
        ESPObjects[player].DistText.Text = math.floor(dist).."m"
    end
end

-- CRIAR ESP PRA TODOS
for
