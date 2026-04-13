-- // SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- GUI
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "MGCHEATS"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.ResetOnSpawn = false

-- BOTÃO
local ButtonMG = Instance.new("TextButton", ScreenGui)
ButtonMG.Size = UDim2.new(0,70,0,70)
ButtonMG.Position = UDim2.new(0.02,0,0.45,0)
ButtonMG.Text = "MG"
ButtonMG.BackgroundColor3 = Color3.new(0,0,0)
ButtonMG.TextColor3 = Color3.new(1,0,0)
ButtonMG.Draggable = true
Instance.new("UICorner", ButtonMG)

-- MENU
local MainMenu = Instance.new("Frame", ScreenGui)
MainMenu.Size = UDim2.new(0,300,0,350)
MainMenu.Position = UDim2.new(0.05,0,0.1,0)
MainMenu.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
MainMenu.Visible = false
MainMenu.Draggable = true
Instance.new("UICorner", MainMenu)

-- TOPO
local Title = Instance.new("TextLabel", MainMenu)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "★ MGCHEATS ★"
Title.TextColor3 = Color3.new(0.2,1,1)
Title.BackgroundTransparency = 1

-- VARS
_G.Aimbot = false
_G.ESP_Line = false
_G.ESP_Box = false
_G.ShowFOV = false
_G.FOV_Size = 100

-- BOTÕES
local function Btn(txt,y,var)
    local b = Instance.new("TextButton",MainMenu)
    b.Size = UDim2.new(0.9,0,0,40)
    b.Position = UDim2.new(0.05,0,0,y)
    b.Text = txt
    b.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
    b.MouseButton1Click:Connect(function()
        _G[var]=not _G[var]
        b.BackgroundColor3 = _G[var] and Color3.new(0,1,0) or Color3.new(0.2,0.2,0.2)
    end)
end

Btn("AIMBOT",50,"Aimbot")
Btn("ESP LINE",100,"ESP_Line")
Btn("ESP CAIXA",150,"ESP_Box")
Btn("EXIBIR FOV",200,"ShowFOV")

-- FOV
local FOVCircle = Instance.new("Frame",ScreenGui)
FOVCircle.BackgroundTransparency = 1
local img = Instance.new("ImageLabel",FOVCircle)
img.Size = UDim2.new(1,0,1,0)
img.BackgroundTransparency = 1
img.Image = "rbxassetid://266543007"
img.ImageColor3 = Color3.new(0.5,0,1)

-- MENU
ButtonMG.MouseButton1Click:Connect(function()
    MainMenu.Visible = not MainMenu.Visible
end)

-- ESP FOLDER
local ESPFolder = Instance.new("Folder",Workspace)

-- LOOP
RunService.RenderStepped:Connect(function()

    -- FOV
    if _G.ShowFOV then
        local s = _G.FOV_Size*1.5
        FOVCircle.Visible = true
        FOVCircle.Size = UDim2.new(0,s,0,s)
        FOVCircle.Position = UDim2.new(0.5,-s/2,0.5,-s/2)
    else
        FOVCircle.Visible = false
    end

    -- AIMBOT
    if _G.Aimbot then
        local closest,dist=nil,math.huge
        local center = Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)

        for _,v in pairs(Players:GetPlayers()) do
            if v~=Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local pos,on = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                if on then
                    local d=(Vector2.new(pos.X,pos.Y)-center).Magnitude
                    if d<_G.FOV_Size and d<dist then
                        dist=d
                        closest=v
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

    ESPFolder:ClearAllChildren()

    for _,v in pairs(ScreenGui:GetChildren()) do
        if v.Name=="LINE" then v:Destroy() end
    end

    for _,v in pairs(Players:GetPlayers()) do
        if v~=Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local hrp=v.Character.HumanoidRootPart
            local pos,on=Camera:WorldToViewportPoint(hrp.Position)

            if _G.ESP_Line and on then
                local l=Instance.new("Frame",ScreenGui)
                l.Name="LINE"
                l.BackgroundColor3=Color3.new(0,1,0)

                local c=Vector2.new(Camera.ViewportSize.X/2,0)
                local dir=Vector2.new(pos.X,pos.Y)-c
                local d=dir.Magnitude

                l.Size=UDim2.new(0,2,0,d)
                l.Position=UDim2.new(0,c.X,0,0)
                l.Rotation=math.deg(math.atan2(dir.Y,dir.X))+90
            end

            if _G.ESP_Box then
                local b=Instance.new("BoxHandleAdornment")
                b.Adornee=hrp
                b.Size=Vector3.new(4,6,4)
                b.Color3=Color3.new(0,1,0)
                b.Transparency=0.5
                b.AlwaysOnTop=true
                b.Parent=ESPFolder
            end
        end
    end
end)
