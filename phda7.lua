-- // SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = Player:GetMouse()

-- // GUI PRINCIPAL
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MGCHEATS_ARENA"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999

-- BOTÃO
local ButtonMG = Instance.new("TextButton", ScreenGui)
ButtonMG.Size = UDim2.new(0, 70, 0, 70)
ButtonMG.Position = UDim2.new(0.02, 0, 0.45, 0)
ButtonMG.Text = "MG"
ButtonMG.BackgroundColor3 = Color3.new(0,0,0)
ButtonMG.TextColor3 = Color3.new(1,0,0)
ButtonMG.BorderSizePixel = 3
ButtonMG.Active = true
ButtonMG.Draggable = true

Instance.new("UICorner", ButtonMG).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", ButtonMG).Color = Color3.new(1,0,0)

-- FOV
local FOVCircle = Instance.new("Frame", ScreenGui)
FOVCircle.Size = UDim2.new(0,200,0,200)
FOVCircle.Position = UDim2.new(0.5,-100,0.5,-100)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = false

local Circle = Instance.new("ImageLabel", FOVCircle)
Circle.Size = UDim2.new(1,0,1,0)
Circle.BackgroundTransparency = 1
Circle.Image = "rbxassetid://2658958756"
Circle.ImageColor3 = Color3.new(0.5,0,1)
Circle.ImageTransparency = 0.4

-- MENU
local MainMenu = Instance.new("Frame", ScreenGui)
MainMenu.Size = UDim2.new(0,450,0,550)
MainMenu.Position = UDim2.new(0.05,0,0.1,0)
MainMenu.BackgroundColor3 = Color3.new(0.08,0.08,0.08)
MainMenu.Visible = false
MainMenu.Active = true
MainMenu.Draggable = true

Instance.new("UICorner", MainMenu)

-- BOTÕES MENU
ButtonMG.MouseButton1Click:Connect(function()
    MainMenu.Visible = not MainMenu.Visible
end)

-- VARIÁVEIS
_G.Aimbot = false
_G.ShowFOV = false
_G.ESP_Box = false
_G.ESP_Line = false

local ESPObjects = {}

-- AIMBOT + FOV
RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = _G.ShowFOV

    if _G.Aimbot and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local Closest = nil
        local Dist = math.huge

        for _,v in pairs(Players:GetPlayers()) do
            if v ~= Player and v.Character 
            and v.Character:FindFirstChild("Head")
            and v.Character:FindFirstChild("Humanoid")
            and v.Character.Humanoid.Health > 0 then

                local mag = (Player.Character.HumanoidRootPart.Position - v.Character.Head.Position).Magnitude

                if mag < Dist then
                    Dist = mag
                    Closest = v
                end
            end
        end

        if Closest then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Closest.Character.Head.Position)
        end
    end
end)

-- ESP
local function CreateESP(player)
    if player == Player then return end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Parent = Workspace
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Color3 = Color3.new(0,1,0)
    box.Transparency = 1

    local line = Instance.new("LineHandleAdornment")
    line.Parent = Workspace
    line.AlwaysOnTop = true
    line.ZIndex = 10
    line.Color3 = Color3.new(1,0,0)

    ESPObjects[player] = {Box = box, Line = line}
end

local function UpdateESP()
    for _,player in pairs(Players:GetPlayers()) do
        if player ~= Player then
            
            if not ESPObjects[player] then
                CreateESP(player)
            end

            local char = player.Character
            
            if char 
            and char:FindFirstChild("HumanoidRootPart")
            and char:FindFirstChild("Head")
            and char:FindFirstChild("Humanoid")
            and char.Humanoid.Health > 0 then

                local hrp = char.HumanoidRootPart
                local head = char.Head

                local esp = ESPObjects[player]

                -- BOX
                esp.Box.Adornee = hrp
                esp.Box.Size = Vector3.new(2,3,1)
                esp.Box.Visible = _G.ESP_Box

                -- LINE (CORRIGIDO)
                esp.Line.Adornee = head
                esp.Line.Length = 5
                esp.Line.Visible = _G.ESP_Line

            else
                if ESPObjects[player] then
                    ESPObjects[player].Box.Visible = false
                    ESPObjects[player].Line.Visible = false
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(UpdateESP)

print("✅ MGCHEATS CARREGADO!")
