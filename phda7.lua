-- // SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local StarterPlayer = game:GetService("StarterPlayer")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

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
ButtonMG.Size = UDim2.new(0, 70, 0, 70)
ButtonMG.Position = UDim2.new(0.02, 0, 0.45, 0)
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
_G.ESP_Sheriff = false
_G.ESP_Murder = false
_G.ESP_Player = false
_G.NameESP = false
_G.DistanceESP = false

local ESPObjects = {}

-- FUNÇÃO ROLE
local function GetRole(player)
    local role = "Player"
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local roleValue = leaderstats:FindFirstChild("Role")
        if roleValue then
            role = roleValue.Value
        end
    end
    return role
end

-- CRIAR ESP
local function CreateESP(player)
    if player == Player then return end
    
    local esp = {}

    esp.Box = Instance.new("BoxHandleAdornment")
    esp.Box.Parent = Workspace
    esp.Box.AlwaysOnTop = true
    esp.Box.Transparency = 1

    esp.Name = Instance.new("BillboardGui")
    esp.Name.Size = UDim2.new(0,200,0,50)
    esp.Name.AlwaysOnTop = true

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.new(1,1,1)
    txt.Parent = esp.Name

    esp.NameText = txt
    esp.Name.Parent = Workspace

    esp.Distance = Instance.new("BillboardGui")
    esp.Distance.Size = UDim2.new(0,100,0,30)
    esp.Distance.AlwaysOnTop = true

    local dist = Instance.new("TextLabel")
    dist.Size = UDim2.new(1,0,1,0)
    dist.BackgroundTransparency = 1
    dist.TextColor3 = Color3.new(1,1,0)
    dist.Parent = esp.Distance

    esp.DistText = dist
    esp.Distance.Parent = Workspace

    ESPObjects[player] = esp
end

-- UPDATE ESP (CORRIGIDO)
local function UpdateESP(player)
    if not ESPObjects[player] then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    
    if not humanoid or not root or not head or humanoid.Health <= 0 then
        ESPObjects[player].Box.Visible = false
        ESPObjects[player].Name.Enabled = false
        ESPObjects[player].Distance.Enabled = false
        return
    end
    
    local role = GetRole(player)
    local espColor = Color3.new(0, 1, 0)
    local showESP = false
    
    if role == "Sheriff" and _G.ESP_Sheriff then
        espColor = Color3.new(0, 0.5, 1)
        showESP = true
    elseif role == "Murderer" and _G.ESP_Murder then
        espColor = Color3.new(1, 0, 0)
        showESP = true
    elseif role == "Player" and _G.ESP_Player then
        showESP = true
    end
    
    ESPObjects[player].Box.Color3 = espColor
    ESPObjects[player].Box.Size = character:GetExtentsSize()
    ESPObjects[player].Box.CFrame = character:GetModelCFrame()
    ESPObjects[player].Box.Visible = showESP

    -- NOME (CORRIGIDO)
    ESPObjects[player].Name.Adornee = head
    ESPObjects[player].Name.Enabled = _G.NameESP
    ESPObjects[player].NameText.Text = player.Name

    -- DISTÂNCIA (CORRIGIDO)
    local localChar = Player.Character
    if localChar and localChar:FindFirstChild("HumanoidRootPart") then
        local distance = (localChar.HumanoidRootPart.Position - root.Position).Magnitude
        ESPObjects[player].Distance.Adornee = head
        ESPObjects[player].Distance.Enabled = _G.DistanceESP
        ESPObjects[player].DistText.Text = math.floor(distance).."m"
    end
end

-- LOOP (ADICIONADO)
for _, p in pairs(Players:GetPlayers()) do
    if p ~= Player then
        CreateESP(p)
    end
end

Players.PlayerAdded:Connect(function(p)
    CreateESP(p)
end)

RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player then
            UpdateESP(p)
        end
    end
end)
