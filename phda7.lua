-- // SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- // GUI
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "MGCHEATS"
ScreenGui.ResetOnSpawn = false

-- BOTÃO MG
local ButtonMG = Instance.new("TextButton", ScreenGui)
ButtonMG.Size = UDim2.new(0,70,0,70)
ButtonMG.Position = UDim2.new(0.02,0,0.45,0)
ButtonMG.Text = "MG"
ButtonMG.BackgroundColor3 = Color3.new(0,0,0)
ButtonMG.TextColor3 = Color3.new(1,0,0)
ButtonMG.BorderSizePixel = 3
ButtonMG.Active = true
ButtonMG.Draggable = true

Instance.new("UICorner", ButtonMG).CornerRadius = UDim.new(1,0)

-- MENU
local MainMenu = Instance.new("Frame", ScreenGui)
MainMenu.Size = UDim2.new(0,300,0,350)
MainMenu.Position = UDim2.new(0.05,0,0.1,0)
MainMenu.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainMenu.Visible = false
MainMenu.Active = true
MainMenu.Draggable = true

-- BOTÃO ABRIR
ButtonMG.MouseButton1Click:Connect(function()
    MainMenu.Visible = not MainMenu.Visible
end)

-- VARIÁVEIS
_G.Aimbot = false
_G.ESP_Line = false
_G.ESP_Box = false
_G.ShowFOV = false
_G.FOV_Size = 120

-- BOTÕES SIMPLES
local function CreateToggle(text, y, var)
    local btn = Instance.new("TextButton", MainMenu)
    btn.Size = UDim2.new(0.9,0,0,40)
    btn.Position = UDim2.new(0.05,0,0,y)
    btn.Text = text.." OFF"
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    
    btn.MouseButton1Click:Connect(function()
        _G[var] = not _G[var]
        btn.Text = text.." "..(_G[var] and "ON" or "OFF")
    end)
end

CreateToggle("Aimbot",10,"Aimbot")
CreateToggle("ESP Linha",60,"ESP_Line")
CreateToggle("ESP Caixa",110,"ESP_Box")
CreateToggle("FOV",160,"ShowFOV")

-- FOV CIRCULO
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(150,0,255)
FOVCircle.Thickness = 2
FOVCircle.Filled = false

-- ESP
local ESP = {}

local function CreateESP(plr)
    if plr == Player then return end
    
    ESP[plr] = {
        Line = Drawing.new("Line"),
        Box = Drawing.new("Square")
    }
    
    ESP[plr].Line.Thickness = 2
    ESP[plr].Line.Color = Color3.new(1,0,0)
    
    ESP[plr].Box.Thickness = 2
    ESP[plr].Box.Color = Color3.new(0,1,0)
    ESP[plr].Box.Filled = false
end

for _,v in pairs(Players:GetPlayers()) do
    CreateESP(v)
end

Players.PlayerAdded:Connect(CreateESP)

-- LOOP
RunService.RenderStepped:Connect(function()
    
    -- FOV
    FOVCircle.Visible = _G.ShowFOV
    FOVCircle.Radius = _G.FOV_Size
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    
    -- AIMBOT
    if _G.Aimbot then
        local closest = nil
        local dist = math.huge
        
        for _,v in pairs(Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
                local pos, visible = Camera:WorldToViewportPoint(v.Character.Head.Position)
                
                if visible then
                    local mag = (Vector2.new(pos.X,pos.Y) - FOVCircle.Position).Magnitude
                    
                    if mag < _G.FOV_Size and mag < dist then
                        dist = mag
                        closest = v
                    end
                end
            end
        end
        
        if closest then
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position, closest.Character.Head.Position),
                0.2
            )
        end
    end
    
    -- ESP
    for plr,esp in pairs(ESP) do
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
            
            if vis then
                -- LINHA
                esp.Line.Visible = _G.ESP_Line
                esp.Line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                esp.Line.To = Vector2.new(pos.X,pos.Y)
                
                -- CAIXA
                esp.Box.Visible = _G.ESP_Box
                esp.Box.Size = Vector2.new(50,80)
                esp.Box.Position = Vector2.new(pos.X-25,pos.Y-40)
            else
                esp.Line.Visible = false
                esp.Box.Visible = false
            end
        end
    end
end)
