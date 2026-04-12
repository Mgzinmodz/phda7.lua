--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--// GUI
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "MGCHEATS"
ScreenGui.ResetOnSpawn = false

-- BOTÃO
local Button = Instance.new("TextButton", ScreenGui)
Button.Size = UDim2.new(0,60,0,60)
Button.Position = UDim2.new(0.02,0,0.4,0)
Button.Text = "MG"
Button.BackgroundColor3 = Color3.new(0,0,0)
Button.TextColor3 = Color3.new(0,1,0)
Button.Active = true
Button.Draggable = true
Instance.new("UICorner", Button).CornerRadius = UDim.new(1,0)

-- MENU
local Menu = Instance.new("Frame", ScreenGui)
Menu.Size = UDim2.new(0,260,0,260)
Menu.Position = UDim2.new(0.05,0,0.2,0)
Menu.BackgroundColor3 = Color3.new(0.05,0.05,0.05)
Menu.Visible = false
Menu.Active = true
Menu.Draggable = true

-- VARIÁVEIS
local Aimbot = false
local ESP = false
local ShowFOV = false
local FOV_Size = 120

-- TOGGLE
local function CreateToggle(text, callback, y)
    local btn = Instance.new("TextButton", Menu)
    btn.Size = UDim2.new(0.9,0,0,35)
    btn.Position = UDim2.new(0.05,0,0,y)
    btn.Text = text..": OFF"
    btn.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
    btn.TextColor3 = Color3.new(1,1,1)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text..": "..(state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.new(0,1,0) or Color3.new(0.1,0.1,0.1)
        callback(state)
    end)
end

-- SLIDER FOV
local Slider = Instance.new("TextButton", Menu)
Slider.Size = UDim2.new(0.9,0,0,35)
Slider.Position = UDim2.new(0.05,0,0,150)
Slider.Text = "FOV: "..FOV_Size
Slider.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
Slider.TextColor3 = Color3.new(0,1,0)

Slider.MouseButton1Click:Connect(function()
    FOV_Size = FOV_Size + 20
    if FOV_Size > 300 then FOV_Size = 60 end
    Slider.Text = "FOV: "..FOV_Size
end)

-- BOTÕES
CreateToggle("Aimbot", function(v) Aimbot = v end, 10)
CreateToggle("ESP (Wall)", function(v) ESP = v end, 55)
CreateToggle("Mostrar FOV", function(v) ShowFOV = v end, 100)

-- ABRIR MENU
Button.MouseButton1Click:Connect(function()
    Menu.Visible = not Menu.Visible
end)

-- ESP (ATRÁS DA PAREDE)
local ESPFolder = Instance.new("Folder", Workspace)

local function UpdateESP()
    ESPFolder:ClearAllChildren()
    if not ESP then return end

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = v.Character.HumanoidRootPart

            local box = Instance.new("BoxHandleAdornment")
            box.Adornee = hrp
            box.Size = Vector3.new(3,5,3)
            box.Color3 = Color3.new(0,1,0)
            box.Transparency = 0.3
            box.AlwaysOnTop = true -- ATRAVESSA PAREDE
            box.ZIndex = 10
            box.Parent = ESPFolder
        end
    end
end

task.spawn(function()
    while true do
        UpdateESP()
        task.wait(0.5)
    end
end)

-- FOV CIRCLE
local Circle = Instance.new("Frame", ScreenGui)
Circle.BackgroundTransparency = 1
Circle.Size = UDim2.new(0, FOV_Size, 0, FOV_Size)
Circle.Position = UDim2.new(0.5, -FOV_Size/2, 0.5, -FOV_Size/2)
Circle.Visible = false

local Img = Instance.new("ImageLabel", Circle)
Img.Size = UDim2.new(1,0,1,0)
Img.BackgroundTransparency = 1
Img.Image = "rbxassetid://266543007"
Img.ImageColor3 = Color3.new(0,1,0)
Img.ImageTransparency = 0.4

-- LOOP PRINCIPAL
RunService.RenderStepped:Connect(function()
    -- FOV VISUAL
    Circle.Visible = ShowFOV
    Circle.Size = UDim2.new(0, FOV_Size, 0, FOV_Size)
    Circle.Position = UDim2.new(0.5, -FOV_Size/2, 0.5, -FOV_Size/2)

    -- AIMBOT COM FOV
    if not Aimbot then return end

    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local closest, dist = nil, FOV_Size

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
            local head = v.Character.Head
            local screenPos, visible = Camera:WorldToViewportPoint(head.Position)

            if visible then
                local magnitude = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude

                if magnitude < dist then
                    dist = magnitude
                    closest = head
                end
            end
        end
    end

    if closest then
        Camera.CFrame = Camera.CFrame:Lerp(
            CFrame.new(Camera.CFrame.Position, closest.Position),
            0.15
        )
    end
end)
