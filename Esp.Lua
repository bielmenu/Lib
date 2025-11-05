local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local EspSla = {}

-- Modelos
local Models = ReplicatedStorage:WaitForChild("Models")
local TrackGui = Models:WaitForChild("trackPart"):WaitForChild("TrackGui")

-- Lista
local Rastreando = {}

local function colocarTrack(player)
	if player == LocalPlayer then return end
	if not player.Character then player.CharacterAdded:Wait() end

	local head = player.Character:WaitForChild("Head")

	-- evita duplicado
	if head:FindFirstChild(TrackGui.Name) then return end

	local guiClone = TrackGui:Clone()
	guiClone.Parent = head
	guiClone.Healthbar.percentage.Text = player.Name

	Rastreando[player.Name] = head
end

local function removerTrack(player)
	local head = Rastreando[player.Name]
	if head and head:FindFirstChild(TrackGui.Name) then
		head[TrackGui.Name]:Destroy()
	end
	Rastreando[player.Name] = nil
end

-- 🔥 FUNÇÕES DE ATIVAR E DESATIVAR
function EspSla.Ativar()
	for _, plr in ipairs(Players:GetPlayers()) do
		colocarTrack(plr)
	end

	-- Ativa quando novos players entrarem
	EspSla._conAdd = Players.PlayerAdded:Connect(function(plr)
		plr.CharacterAdded:Connect(function()
			colocarTrack(plr)
		end)
	end)

	-- Remove caso saia, para evitar lixo
	EspSla._conRemove = Players.PlayerRemoving:Connect(function(plr)
		removerTrack(plr)
	end)
end

function EspSla.Desativar()
	for name, _ in pairs(Rastreando) do
		local plr = Players:FindFirstChild(name)
		if plr then
			removerTrack(plr)
		end
	end

	Rastreando = {}

	-- desconecta eventos caso tenha sido ativado
	if EspSla._conAdd then EspSla._conAdd:Disconnect() end
	if EspSla._conRemove then EspSla._conRemove:Disconnect() end
end

getgenv().EspSla = EspSla
return EspSla
