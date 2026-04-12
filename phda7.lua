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
ScreenGui.Name = "MGCHEATS"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999

-- BOTÃO MG
local ButtonMG = Instance.new("TextButton")
ButtonMG.Parent = ScreenGui
ButtonMG.Size = UDim2.new(0,70,0,70)
ButtonMG.Position = UDim2.new(0.02,0,0.45,0)
ButtonMG.Text = "MG"
ButtonMG.BackgroundColor3 = Color3.new(0,0,0)
ButtonMG.TextColor3 = Color3.new(0,1,0)
ButtonMG.Draggable = true

Instance.new("UICorner", ButtonMG).CornerRadius = UDim.new(1,0)

-- MENU
local MainMenu = Instance.new("Frame")
MainMenu.Parent = ScreenGui
MainMenu.Size = UDim2.new(0,300,0,400)
MainMenu.Position = UDim2.new(0.05,0,0.1,0)
MainMenu.BackgroundColor3 = Color3.new(0.05,0.05,0.05)
MainMenu.Visible = false
MainMenu.Draggable = true

Instance.new("UICorner", MainMenu)

-- TOPO
local TopBar = Instance.new("Frame", MainMenu)
TopBar.Size = UDim2.new(1,0,0,35)
TopBar.BackgroundColor3 = Color3.new(0,0,0)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1,0,1,0)
Title.BackgroundTransparency = 1
Title.Text = "★ MGCHEATS ★"
Title.TextColor3 = Color3.new(0.2,1,1)

local Close = Instance.new("TextButton", TopBar)
Close.Size = UDim2.new(0,35,0,30)
Close.Position = UDim2.new(1,-40,0,2)
Close.Text = "X"

-- VARIÁVEIS
_G.Aimbot = false
_G.ESP_Line = false
_G.ESP_Box = false
_G.ShowFOV = false
_G.FOV_Size = 100

local Y = 45

-- PASTA ESP (ANTI LAG)
local ESPFolder = Instance.new("Folder", Workspace)

-- FUNÇÃO BOTÃO
local function CreateOption(Name, Var)
    local Btn = Instance.new("TextButton", MainMenu)
    Btn.Size = UDim2.new(0.9,0,0,40)
    Btn.Position = UDim2.new(0.05,0,0,Y)
    Btn.Text = Name
    Btn.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
    Y += 50

    Btn.MouseButton1Click:Connect(function()
        _G[Var] = not _G[Var]
        Btn.BackgroundColor3 = _G[Var] and Color3.new(0,1,0) or Color3.new(0.2,0.2,0.2)
    end)
end

CreateOption("AIMBOT","Aimbot")
CreateOption("ESP LINE","ESP_Line")
CreateOption("ESP CAIXA","ESP_Box")
CreateOption("EXIBIR FOV","ShowFOV")

-- FOV
local FOVCircle = Instance.new("Frame", ScreenGui)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = false

local Circle = Instance.new("ImageLabel", FOVCircle)
Circle.Size = UDim2.new(1,0,1,0)
Circle.BackgroundTransparency = 1
Circle.Image = "rbxassetid://266543007"
Circle.ImageColor3 = Color3.new(0,1,0)

-- ABRIR MENU
ButtonMG.MouseButton1Click:Connect(function()
    MainMenu.Visible = not MainMenu.Visible
end)

Close.MouseButton1Click:Connect(function()
    MainMenu.Visible = false
end)

-- LOOP
RunService.RenderStepped:Connect(function()

    -- FOV
    if _G.ShowFOV then
        local size = _G.FOV_Size * 1.5
        FOVCircle.Visible = true
        FOVCircle.Size = UDim2.new(0,size,0,size)
        FOVCircle.Position = UDim2.new(0.5,-size/2,0.5,-size/2)
    else
        FOVCircle.Visible = false
    end

    -- AIMBOT
    if _G.Aimbot then
        local closest, dist = nil, math.huge
        local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

        for _,v in pairs(Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                if onScreen then
                    local d = (Vector2.new(pos.X,pos.Y) - center).Magnitude
                    if d < _G.FOV_Size and d < dist then
                        dist = d
                        closest = v
                    end
                end
            end
        end

        if closest then
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position, closest.Character.HumanoidRootPart.Position),
                0.2
            )
        end
    end
end)

-- ESP
RunService.Heartbeat:Connect(function()

    -- LIMPA
    ESPFolder:ClearAllChildren()
    for _,v in pairs(ScreenGui:GetChildren()) do
        if v.Name == "ESP_LINE" then v:Destroy() end
    end

    for _,v in pairs(Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = v.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            -- LINHA
            if _G.ESP_Line and onScreen then
                local line = Instance.new("Frame", ScreenGui)
                line.Name = "ESP_LINE"
                line.BackgroundColor3 = Color3.new(0,1,0)

                local center = Vector2.new(Camera.ViewportSize.X/2,0)
                local dir = Vector2.new(pos.X,pos.Y) - center
                local dist = dir.Magnitude

                line.Size = UDim2.new(0,2,0,dist)
                line.Position = UDim2.new(0,center.X,0,0)
                line.Rotation = math.deg(math.atan2(dir.Y,dir.X)) + 90
            end

            -- CAIXA (ATRÁS DA PAREDE)
            if _G.ESP_Box then
                local box = Instance.new("BoxHandleAdornment")
                box.Adornee = hrp
                box.Size = Vector3.new(4,6,4)
                box.Color3 = Color3.new(0,1,0)
                box.Transparency = 0.5
                box.AlwaysOnTop = true
                box.Parent = ESPFolder
            end
        end
    end
end)
