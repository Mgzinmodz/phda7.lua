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
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999

-- BOTÃO
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

Instance.new("UICorner", ButtonMG).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", ButtonMG).Color = Color3.new(1,0,0)

-- FOV
local FOVCircle = Instance.new("Frame")
FOVCircle.Parent = ScreenGui
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = false

local Circle = Instance.new("ImageLabel")
Circle.Parent = FOVCircle
Circle.BackgroundTransparency = 1
Circle.Size = UDim2.new(1,0,1,0)
Circle.Image = "rbxassetid://2658958756"
Circle.ImageColor3 = Color3.new(0.5,0,1)
Circle.ImageTransparency = 0.4

-- MENU
local MainMenu = Instance.new("Frame")
MainMenu.Parent = ScreenGui
MainMenu.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
MainMenu.BorderSizePixel = 3
MainMenu.Size = UDim2.new(0,400,0,400)
MainMenu.Position = UDim2.new(0.05,0,0.1,0)
MainMenu.Visible = false
MainMenu.Active = true
MainMenu.Draggable = true

Instance.new("UICorner", MainMenu)

-- TOPO
local TopBar = Instance.new("Frame", MainMenu)
TopBar.Size = UDim2.new(1,0,0,40)
TopBar.BackgroundColor3 = Color3.new(0,0,0)

local BtnClose = Instance.new("TextButton", TopBar)
BtnClose.Size = UDim2.new(0,35,0,30)
BtnClose.Position = UDim2.new(1,-40,0,2)
BtnClose.Text = "X"

local BtnMinimize = Instance.new("TextButton", TopBar)
BtnMinimize.Size = UDim2.new(0,35,0,30)
BtnMinimize.Position = UDim2.new(1,-75,0,2)
BtnMinimize.Text = "-"

-- VARIÁVEIS
_G.Aimbot = false
_G.ShowFOV = false
_G.FOV_Size = 200
_G.ESP_Box = false
_G.ESP_Line = false

local Y = 55
local ESPObjects = {}

-- UI
local function CreateOption(Name, VarName)
    local Frame = Instance.new("Frame", MainMenu)
    Frame.Size = UDim2.new(0.9,0,0,45)
    Frame.Position = UDim2.new(0.05,0,0,Y)
    Y = Y + 55

    local Toggle = Instance.new("TextButton", Frame)
    Toggle.Size = UDim2.new(0,30,0,30)
    Toggle.Position = UDim2.new(0.85,0,0.5,-15)

    Toggle.MouseButton1Click:Connect(function()
        _G[VarName] = not _G[VarName]
        Toggle.BackgroundColor3 = _G[VarName] and Color3.new(0,1,0) or Color3.new(0.2,0.2,0.2)
    end)
end

CreateOption("Aimbot","Aimbot")
CreateOption("FOV","ShowFOV")
CreateOption("ESP Line","ESP_Line")
CreateOption("ESP Box","ESP_Box")

-- BOTÕES
ButtonMG.MouseButton1Click:Connect(function()
    MainMenu.Visible = not MainMenu.Visible
end)

BtnClose.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

BtnMinimize.MouseButton1Click:Connect(function()
    MainMenu.Visible = false
end)

-- AIMBOT
RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = _G.ShowFOV
    FOVCircle.Size = UDim2.new(0,_G.FOV_Size,0,_G.FOV_Size)
    FOVCircle.Position = UDim2.new(0.5,-_G.FOV_Size/2,0.5,-_G.FOV_Size/2)

    if _G.Aimbot and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local Closest,Dist = nil,200

        for _,v in pairs(Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
                local d = (Player.Character.HumanoidRootPart.Position - v.Character.Head.Position).Magnitude
                if d < Dist then
                    Dist = d
                    Closest = v
                end
            end
        end

        if Closest and Closest.Character then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Closest.Character.Head.Position)
        end
    end
end)

-- ESP
local function CreateESP(p)
    local box = Instance.new("BoxHandleAdornment", Workspace)
    local line = Instance.new("LineHandleAdornment", Workspace)

    ESPObjects[p] = {Box = box, Line = line}
end

RunService.Heartbeat:Connect(function()
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= Player then
            if not ESPObjects[p] then
                CreateESP(p)
            end

            local char = p.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") then
                local esp = ESPObjects[p]

                esp.Box.Size = Vector3.new(2,3,1)
                esp.Box.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0,1.5,0)
                esp.Box.Visible = _G.ESP_Box

                esp.Line.From = Camera.CFrame.Position
                esp.Line.To = char.Head.Position
                esp.Line.Visible = _G.ESP_Line
            end
        end
    end
end)

print("✅ MGCHEATS CARREGADO!")
