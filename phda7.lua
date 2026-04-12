--// SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

--// GUI BASE
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "MG_PANEL"
ScreenGui.ResetOnSpawn = false

-- BOTÃO FLUTUANTE
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
Menu.Size = UDim2.new(0,280,0,260)
Menu.Position = UDim2.new(0.05,0,0.2,0)
Menu.BackgroundColor3 = Color3.new(0.05,0.05,0.05)
Menu.Visible = false
Menu.Active = true
Menu.Draggable = true
Menu.BorderColor3 = Color3.new(0,1,0)

-- TÍTULO
local Title = Instance.new("TextLabel", Menu)
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundTransparency = 1
Title.Text = "★ MGCHEATS ★"
Title.TextColor3 = Color3.new(0,1,0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- BOTÃO FECHAR
local Close = Instance.new("TextButton", Menu)
Close.Size = UDim2.new(0,30,0,25)
Close.Position = UDim2.new(1,-35,0,2)
Close.Text = "X"
Close.BackgroundColor3 = Color3.new(0.4,0,0)
Close.TextColor3 = Color3.new(1,1,1)

Close.MouseButton1Click:Connect(function()
	Menu.Visible = false
end)

-- VARIÁVEIS
local Aimbot = false
local ESP = false
local ShowFOV = false
local FOV_Size = 120

-- FUNÇÃO TOGGLE
local function CreateToggle(text, y, callback)
	local btn = Instance.new("TextButton", Menu)
	btn.Size = UDim2.new(0.9,0,0,35)
	btn.Position = UDim2.new(0.05,0,0,y)
	btn.Text = text.." [OFF]"
	btn.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
	btn.TextColor3 = Color3.new(1,1,1)

	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = text.." ["..(state and "ON" or "OFF").."]"
		btn.BackgroundColor3 = state and Color3.new(0,1,0) or Color3.new(0.1,0.1,0.1)
		callback(state)
	end)
end

-- TOGGLES
CreateToggle("AIMBOT", 40, function(v) Aimbot = v end)
CreateToggle("ESP", 80, function(v) ESP = v end)
CreateToggle("EXIBIR FOV", 120, function(v) ShowFOV = v end)

-- SLIDER FOV
local Slider = Instance.new("TextButton", Menu)
Slider.Size = UDim2.new(0.9,0,0,35)
Slider.Position = UDim2.new(0.05,0,0,170)
Slider.Text = "TAMANHO FOV: "..FOV_Size
Slider.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
Slider.TextColor3 = Color3.new(0,1,0)

Slider.MouseButton1Click:Connect(function()
	FOV_Size = FOV_Size + 20
	if FOV_Size > 300 then FOV_Size = 60 end
	Slider.Text = "TAMANHO FOV: "..FOV_Size
end)

-- ABRIR MENU
Button.MouseButton1Click:Connect(function()
	Menu.Visible = not Menu.Visible
end)

-- CÍRCULO FOV
local Circle = Instance.new("Frame", ScreenGui)
Circle.BackgroundTransparency = 1
Circle.Visible = false

local Img = Instance.new("ImageLabel", Circle)
Img.Size = UDim2.new(1,0,1,0)
Img.BackgroundTransparency = 1
Img.Image = "rbxassetid://266543007"
Img.ImageColor3 = Color3.new(0,1,0)
Img.ImageTransparency = 0.4

-- LOOP VISUAL
RunService.RenderStepped:Connect(function()
	Circle.Visible = ShowFOV
	Circle.Size = UDim2.new(0, FOV_Size, 0, FOV_Size)
	Circle.Position = UDim2.new(0.5, -FOV_Size/2, 0.5, -FOV_Size/2)
end)
