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

-- BOTÃO MG
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
Menu.Size = UDim2.new(0,250,0,200)
Menu.Position = UDim2.new(0.05,0,0.2,0)
Menu.BackgroundColor3 = Color3.new(0.05,0.05,0.05)
Menu.Visible = false
Menu.Active = true
Menu.Draggable = true

-- VARIÁVEIS
local Aimbot = false
local ESP = false

-- TOGGLE
local function CreateToggle(text, callback, y)
    local btn = Instance.new("TextButton", Menu)
    btn.Size = UDim2.new(0.9,0,0,40)
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

-- BOTÕES
CreateToggle("Aimbot", function(v) Aimbot = v end, 10)
CreateToggle("ESP", function(v) ESP = v end, 60)

-- ABRIR MENU
Button.MouseButton1Click:Connect(function()
    Menu.Visible = not Menu.Visible
end)

-- ESP STORAGE (SEM LAG)
local ESPFolder = Instance.new("Folder", Workspace)
ESPFolder.Name = "MG_ESP_FOLDER"

-- FUNÇÃO ESP
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
            box.Transparency = 0.5
            box.AlwaysOnTop = true
            box.Parent = ESPFolder
        end
    end
end

-- LOOP ESP OTIMIZADO
task.spawn(function()
    while true do
        UpdateESP()
        task.wait(0.5)
    end
end)

-- AIMBOT SEGURO
RunService.RenderStepped:Connect(function()
    if not Aimbot then return end

    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local closest, dist = nil, math.huge

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
            local head = v.Character.Head
            local magnitude = (head.Position - char.HumanoidRootPart.Position).Magnitude

            if magnitude < dist then
                dist = magnitude
                closest = head
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
