SettingsGeral = {
	FacCheck = false,
	CabecaSize = 6,
	TeamCheck = false,
	AliveCheck = true,
	LockPart = "Head",
	FOV = 90,
	FOVColor = Color3.fromRGB(143, 28, 28),
	LockedColor = Color3.fromRGB(255, 50, 50),
	Sensitivity = 3,
	Ativado = false,
	BigHead = true,
	Mirar = false,
	TpKill = false,
	RevistarAuto = true,
	Tipo = "Legit",
	CLAuto = false,
	CLVida = 30,
	PlayerSelect = nil,
	Spect = false,
	LinhasEspTop = false,
	instantTool = false,
	FriendV = false,
	AC = 12,
	SpeedMax = 170,
	Freio = 100,
	Freiodemao = 2.5,
	Nitro = false,
	EspColor = Color3.fromRGB(255, 255, 255),
	EspDist = 5000,
	EspLinhas = false,
	EspHp = true,
	EspHigh = false,
	EspInfos = true,
	EspDistInfo = true,
	EspTextSize = 13,
	EspCaixa = false,
	FlySpeed = 200,
	Flying = false,
	AutoTrat = false,
	QntTrat = 1,
	HideNot = false,
	Queda = false,
	QuedaName = "DanoQueda",
	carroSelected = nil,
	telarcar = false,
	money = 0,
	autoAbastece = false,
	InstaPick = false,
	Tempo = 2,
	MinTempo = 1,
	MaxTempo = 10,
	FimText = " !",
	M = "Maiúsculas",
	Inicio = 0,
	Fim = 1,
	Pular = true,
	LogoOriginal = "rbxassetid://13062037083",
	Logo = true,
	
	
	-- CU DO REKE GRANDAO
}

if game:GetService("CoreGui"):FindFirstChild("StarMenuLib") then
	return
end

local whitelist = loadstring(game:HttpGet('https://gist.githubusercontent.com/bielmenu/df14e9eed43254ae5f4ea53547101581/raw/Acessos.lua?t='..tostring(tick())))()


local function podeUsar(userId)
	local dados = whitelist[userId]
	if not dados or not dados.timestamp then
		return false, 0
	end

	return os.time() <= dados.timestamp, dados.timestamp
end

local function formatarTempoRestante(timestampFuturo)
	local segundosRestantes = timestampFuturo - os.time()
	if timestampFuturo == math.huge or timestampFuturo > 9999999999 then
		return "Permanente"
	end

	if segundosRestantes <= 0 then
		return "Expirado"
	end

	local anos = math.floor(segundosRestantes / 31536000) -- 365 dias
	local meses = math.floor((segundosRestantes % 31536000) / 2592000) -- 30 dias
	local dias = math.floor((segundosRestantes % 31536000) / 86400)
	local horas = math.floor((segundosRestantes % 86400) / 3600)
	local minutos = math.floor((segundosRestantes % 3600) / 60)
	local segundos = segundosRestantes % 60

	local partes = {}

	if anos > 0 then
		table.insert(partes, anos .. (anos == 1 and " ano" or " anos"))
	end
	if meses > 0 then
		table.insert(partes, meses .. (meses == 1 and " mês" or " meses"))
	end
	if dias > 0 then
		table.insert(partes, dias .. (dias == 1 and " dia" or " dias"))
	end
	if horas > 0 and anos == 0 and meses == 0 then
		table.insert(partes, horas .. (horas == 1 and " hora" or " horas"))
	end
	if minutos > 0 and anos == 0 and meses == 0 and dias == 0 then
		table.insert(partes, minutos .. (minutos == 1 and " minuto" or " minutos"))
	end
	if segundos > 0 and anos == 0 and meses == 0 and dias == 0 then
		table.insert(partes, segundos .. (segundos == 1 and " segundo" or " segundos"))
	end

	return table.concat(partes, " e ")
end

local permitido, expiraEm = podeUsar(game:GetService("RbxAnalyticsService"):GetClientId())

local playerName = "Unknown"
local playerDisplayName = "Unknown"
local playerUserId = "Unknown"

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Radius = SettingsGeral.FOV
FOVCircle.Thickness = 2
FOVCircle.Transparency = 1
FOVCircle.Color = SettingsGeral.FOVColor
FOVCircle.Filled = false

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bielmenu/Lib/refs/heads/main/Lib.Luau"))()
--local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/refs/heads/main/addons/ThemeManager.lua'))()
--local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ConcessionariaRS = ReplicatedStorage:WaitForChild("ConcessionariaRS")
local Remotes = ConcessionariaRS:WaitForChild("Remotes")
local AbreUIs = Remotes:WaitForChild("AbreUIs")
local lojaRemote = ReplicatedStorage:WaitForChild("RemoteNovos"):WaitForChild("lojeta")

local BackPack = player.PlayerGui:WaitForChild("BackpackNova", 9e9)
local metaLIXO = BackPack:WaitForChild("metaLIXO")
local values = metaLIXO:WaitForChild("values")
local ValoresSalvados = values:WaitForChild("ValoresSalvados")
local Dinheiro = ValoresSalvados:WaitForChild("Dinheiro")
local MarcaDAgua = player.PlayerGui:WaitForChild("MarcaDAgua", 5)

if player then
	playerName = player.Name or "Unknown"
	playerDisplayName = player.DisplayName or playerName
	playerUserId = tostring(player.UserId or "Unknown")
end

local function sendRequest(reqData)
	if syn and syn.request then return syn.request(reqData) end
	if http_request then return http_request(reqData) end
	if request then return request(reqData) end
	if http and http.request then return http.request(reqData) end
	local tryList = {
		function() if syn and syn.request then return syn.request end end,
		function() if http_request then return http_request end end,
		function() if request then return request end end,
		function() if http and http.request then return http.request end end
	}
	for _, fget in ipairs(tryList) do
		local f = fget()
		if f then
			local ok, res = pcall(f, reqData)
			if ok then return res end
		end
	end
	error("Nenhuma função de request HTTP disponível no executor.")
end

local function sendEmbed(webhookUrl, embedTable, extras)
	extras = extras or {}
	local payload = { embeds = { embedTable } }

	local payload = {
		content = extras.content or "", -- <- adiciona aqui
		embeds = { embedTable }
	}

	if extras.username then payload.username = extras.username end
	if extras.avatar_url then payload.avatar_url = extras.avatar_url end
	if extras.tts then payload.tts = true end

	local body = HttpService:JSONEncode(payload)
	local req = {
		Url = webhookUrl,
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = body
	}

	local ok, res = pcall(function() return sendRequest(req) end)
	if not ok then
		warn("Falha ao enviar webhook:", res)
		return false, res
	end

	local code = res.StatusCode or res.status or res.Status or res.code
	print("Webhook enviado. Status code:", code)
	return true, res
end

local playersCount = #Players:GetPlayers()
local maxPlayers = 50
pcall(function() maxPlayers = Players.MaxPlayers end)

local clientId = "unknown"
pcall(function() clientId = tostring(game:GetService("RbxAnalyticsService"):GetClientId()) end)

local exemploEmbed = {
	title = "Logs",
	description = string.format("%s (@%s) está usando Star Menu [%s]", playerDisplayName, playerName, "versionS"),
	color = 0x3498DB,
	fields = {
		{ name = "Usuário", value = string.format("```%s```", playerName), inline = true },
		{ name = "JobId Server", value = string.format("```%s```", tostring(game.JobId or "unknown")), inline = true },
		{ name = "ClientID", value = string.format("```%s```", clientId), inline = true },
		{ name = "Players", value = string.format("```%s/%s```", tostring(playersCount), tostring(maxPlayers)), inline = true },
		{ name = "Tem Acesso/Tempo", value = string.format("```%s | %s```", if permitido == true then "Sim" else "Não" ,if expiraEm == 0 then "N/A" else formatarTempoRestante(expiraEm)), inline = true },
	},
	footer = { text = "" },
	timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
}

local WEBHOOK = "https://discord.com/api/webhooks/1434862600151371818/Eyr7oaeByVGOAOuCaF3g0ncAhsYPfFA1Kv9RLOUM7yw3RdJkQLmwNoNrJR7Ay_oX_7mw"
sendEmbed(WEBHOOK, exemploEmbed, { username = "Logs Login", content = player.Name })

if not permitido then
	Library:Notify(string.format("Você não possuí acesso no Star Menu\nPara garantir seu acesso entre no discord! https://discord.gg/bpsrpcdcm5\nLink copiado!"), 10)
	setclipboard("https://discord.gg/bpsrpcdcm5")
	task.delay(15, function()
		Library:Unload()
	end)
	return
else
	Library:Notify(string.format("Seu tempo acaba em %s", formatarTempoRestante(expiraEm)), 10)
end

local unidades = {
	"zero", "um", "dois", "três", "quatro", "cinco", "seis", "sete", "oito", "nove"
}
local especiais = {
	[10] = "dez", [11] = "onze", [12] = "doze", [13] = "treze", [14] = "quatorze",
	[15] = "quinze", [16] = "dezesseis", [17] = "dezessete", [18] = "dezoito", [19] = "dezenove"
}
local dezenas = {
	[2] = "vinte", [3] = "trinta", [4] = "quarenta", [5] = "cinquenta", [6] = "sessenta",
	[7] = "setenta", [8] = "oitenta", [9] = "noventa"
}
local centenas = {
	[1] = "cento", [2] = "duzentos", [3] = "trezentos", [4] = "quatrocentos", [5] = "quinhentos"
}

local function escrito(n)
	if n == 100 then return "cem" end
	if n == 200 then return "duzentos" end
	if n == 300 then return "trezentos" end
	if n == 400 then return "quatrocentos" end
	if n == 500 then return "quinhentos" end

	if n < 10 then
		return unidades[n+1] -- agora inclui o zero
	elseif n < 20 then
		return especiais[n]
	elseif n < 100 then
		local dez = math.floor(n/10)
		local uni = n % 10
		if uni == 0 then
			return dezenas[dez]
		else
			return dezenas[dez] .. " e " .. unidades[uni+1]
		end
	elseif n < 1000 then
		local cen = math.floor(n/100)
		local resto = n % 100
		if resto == 0 then
			return centenas[cen]
		elseif resto < 10 then
			return centenas[cen] .. " e " .. unidades[resto+1]
		elseif resto < 20 then
			return centenas[cen] .. " e " .. especiais[resto]
		else
			local dez = math.floor(resto/10)
			local uni = resto % 10
			if uni == 0 then
				return centenas[cen] .. " e " .. dezenas[dez]
			else
				return centenas[cen] .. " e " .. dezenas[dez] .. " e " .. unidades[uni+1]
			end
		end
	end
end

local numeros_escritos = {}
for i = 0, 500 do
	table.insert(numeros_escritos, escrito(i))
end

local running = false
local runner = nil
local currentIndex = 1
local finalIndex = #numeros_escritos
local vim = game:GetService("VirtualInputManager")
local function SendChatMsg(msg)
	local TextChatService = game:GetService("TextChatService")
	local channel:TextChannel = TextChatService.TextChannels["RBXGeneral"] -- ou outro canal

	channel:SendAsync(msg)
	
	if SettingsGeral.Pular then
		vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
		task.wait(0.1)
		vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
	end
	
end

local function primeiraMaiuscula(str)
	return string.upper(string.sub(str,1,1)) .. string.lower(string.sub(str,2))
end

local function utf8_upper(str)
	local map = {
		["á"]="Á", ["à"]="À", ["ã"]="Ã", ["â"]="Â",
		["é"]="É", ["ê"]="Ê",
		["í"]="Í",
		["ó"]="Ó", ["ô"]="Ô", ["õ"]="Õ",
		["ú"]="Ú", ["ü"]="Ü",
		["ç"]="Ç"
	}

	-- primeiro aplica string.upper normal
	str = string.upper(str)

	-- depois substitui os acentos
	for lower, upper in pairs(map) do
		str = str:gsub(lower, upper)
	end

	return str
end


local function printNumeros()
	while running and currentIndex <= finalIndex do
		if SettingsGeral.M == "Maiúsculas" then
			SendChatMsg(utf8_upper(numeros_escritos[currentIndex]..SettingsGeral.FimText))
		elseif SettingsGeral.M == "Minúsculas" then
			SendChatMsg(string.lower(numeros_escritos[currentIndex]..SettingsGeral.FimText))
		else
			SendChatMsg(primeiraMaiuscula(numeros_escritos[currentIndex]..SettingsGeral.FimText))
		end
		currentIndex = currentIndex + 1
		task.wait(SettingsGeral.Tempo) -- Ajuste o tempo se quiser
	end
	running = false
end

local function start(inicio, fim)
	if running then return end -- já está rodando
	inicio = tonumber(inicio) or SettingsGeral.Inicio or 0
	fim = tonumber(fim) or SettingsGeral.Fim or 500
	if inicio < 0 then inicio = 0 end
	if fim > 500 then fim = 500 end

	-- Se estamos voltando de um stop, currentIndex já está onde parou!
	-- Só atualiza finalIndex caso mude o fim
	if currentIndex < inicio + 1 or currentIndex > fim + 1 then
		currentIndex = inicio + 1
	end
	finalIndex = fim + 1
	running = true
	runner = coroutine.create(printNumeros)
	coroutine.resume(runner)
end

local function stop()
	running = false
end

local function reset()
	stop()
	currentIndex = 1
	finalIndex = #numeros_escritos
end

local Window = Library:CreateWindow({
	Title = 'Star Menu - [Beta] [PC]',
	Center = true,
	AutoShow = true,
	TabPadding = 8,
	MenuFadeTime = 0.2,
	Tema = {
		FontColor = Color3.fromRGB(255, 255, 255),
		MainColor = Color3.fromRGB(28, 28, 28),
		BackgroundColor = Color3.fromRGB(20, 20, 20),
		AccentColor = SettingsGeral.LockedColor,
		OutlineColor = Color3.fromRGB(50, 50, 50),
		RiskColor = Color3.fromRGB(255, 50, 50),
	}
})
--ThemeManager:SetLibrary(Library)
local Tabs = {
	Main = Window:AddTab('Main'),
	Carros = Window:AddTab('Carros/Visual'),
	PlayersTab = Window:AddTab('Players/Loja'),
	['UI Settings'] = Window:AddTab('UI Settings'),
}

local TabBox2 = Tabs.Main:AddLeftTabbox()

local AimBotTab1 = TabBox2:AddTab('Combate')
AimBotTab1:AddLabel('AimBot')

AimBotTab1:AddToggle('AimBotToggle', { Text = 'AimBot', Tooltip = 'A mira ira para o alvo automáticamente!',
	Callback = function(Value)
		SettingsGeral.Ativado = Value
	end,
	Default = SettingsGeral.Ativado
});

local MiraGruda = AimBotTab1:AddDependencyBox();
MiraGruda:AddToggle('MiraGruda', { Text = 'Mirar/Atirar AimBot',
	Tooltip = 'Quanto mirar/atirar com a arma o aimbot ativa!',
	Callback = function(Value)
		SettingsGeral.Mirar = Value
	end,
	Default = SettingsGeral.Mirar

});

MiraGruda:SetupDependencies({
	{ Toggles.AimBotToggle, true }
});

AimBotTab1:AddToggle('TpKillToggle', { Text = 'TP Kill', Tooltip = 'Você teleporta sozinho no jogador que matou e revista!',
	Callback = function(Value)
		SettingsGeral.TpKill = Value
	end,
	Risky = true,
	Default = SettingsGeral.TpKill	
});

--FOVCircle.Visible = true

--local FrameTimer = tick()
--local FrameCounter = 0;
--local FPS = 60;

--local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
--	FrameCounter += 1;

--	if (tick() - FrameTimer) >= 1 then
--		FPS = FrameCounter;
--		FrameTimer = tick();
--		FrameCounter = 0;
--	end;

--	Library:SetWatermark(('StarMenu | %s fps | %s ms'):format(
--		math.floor(FPS),
--		math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
--		));
--end);

local AimBotTab2 = TabBox2:AddTab('Configuração')
AimBotTab2:AddLabel('Configuração')
AimBotTab2:AddToggle('ExibirFovToggle', { Text = 'Exibir Fov', Tooltip = 'Mostra o FOV do aimbot!',
	Callback = function(Value)
		FOVCircle.Visible = Value
	end,
	Default = FOVCircle.Visible	
});
AimBotTab2:AddToggle('TeamCheckToggle', { Text = 'Team Check', Tooltip = 'O aimbot não vai ir para mesmo time, Você é policía e a mira não gruda em outro policíal',
	Callback = function(Value)
		SettingsGeral.TeamCheck = Value
	end,
	Default = SettingsGeral.TeamCheck
});
AimBotTab2:AddToggle('CabecaToggle', { Text = 'Cabeção', Tooltip = 'Ficam com a cabeça maior para acertar mais tiro!',
	Callback = function(Value)
		SettingsGeral.BigHead = Value
	end,
	Default = SettingsGeral.BigHead
});

local CabecaoSize = AimBotTab2:AddDependencyBox();
CabecaoSize:AddSlider('CabecaoSizeSlider', {
	Text = 'Tamanho da Cabeça',
	Default = SettingsGeral.CabecaSize,
	Min = 2,
	Max = 10,
	Rounding = 0,
	Compact = true,

	Callback = function(Value)
		SettingsGeral.CabecaSize = Value
	end,
	Tooltip = 'Tamanho da Cabeça do inimigo, maior que 6 pode bugar o carro!'
})

CabecaoSize:SetupDependencies({
	{ Toggles.CabecaToggle, true }
});

AimBotTab2:AddToggle('TeamFacToggle', { Text = 'Facção Check', Tooltip = 'O aimbot não vai ir para mesma facção que a sua!',
	Callback = function(Value)
		SettingsGeral.FacCheck = Value
	end,
	Default = SettingsGeral.FacCheck	
});
AimBotTab2:AddToggle('AliveCheckToggle', { Text = 'Vida Check', Tooltip = 'Verifica se o alvo está vivo!',
	Callback = function(Value)
		SettingsGeral.AliveCheck = Value
	end,
	Default = SettingsGeral.AliveCheck
});

AimBotTab2:AddToggle('FriendaToggle', { Text = 'Amigos Check', Tooltip = 'Verifica se o alvo nao e seu amigo e nao gruda!',
	Callback = function(Value)
		SettingsGeral.FriendV = Value
	end,
	Default = SettingsGeral.FriendV
});

AimBotTab2:AddSlider('FovSlider', {
	Text = 'Fov',
	Default = SettingsGeral.FOV,
	Min = 50,
	Max = 500,
	Rounding = 1,
	Compact = false,

	Callback = function(Value)
		SettingsGeral.FOV = Value
		FOVCircle.Radius = Value
	end,
	Tooltip = 'Tamanho do Fov para a camera grudar!'
})

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Revistar')

LeftGroupBox:AddToggle('RevistarToggle', { Text = 'Puxar Itens', Tooltip = 'Puxe os itens de quem você está revistando!',
	Callback = function(Value)
		SettingsGeral.RevistarAuto = Value
	end,
	Default = SettingsGeral.RevistarAuto	
});

LeftGroupBox:AddDropdown('RevistarTipo', {
	Values = { 'Legit', 'Rage', 'Click' },
	Default = 1,
	Multi = false,

	Text = 'Tipo',
	Tooltip = 'O tipo de revistar.\n Legit: Puxa apenas itens importantes.\n Rage: Puxa tudo e muito rapido.\n Click: Clique no item para roubar, super legit.', -- Information shown when you hover over the dropdown

	Callback = function(Value)
		print('[cb] Dropdown got changed. New value:', Value)
		SettingsGeral.Tipo = Value
	end
})

LeftGroupBox:AddLabel('Revistar Bind'):AddKeyPicker('RevistarBind', {
	Default = 'X',
	SyncToggleState = false,
	Mode = 'Toggle',
	Text = 'Envia /revistar sem precisar digitar',
	NoUI = true,
})

LeftGroupBox:AddLabel('Quitar'):AddKeyPicker('QuitKey', {
	Default = 'LeftAlt',
	SyncToggleState = false,


	Mode = 'Hold',

	Text = 'Quita sozinho ao clicar na tecla',
	NoUI = true,
})


local function s(actionName, inputState)
	if inputState == Enum.UserInputState.Begin and not Library.Unloaded then
		local remote = ReplicatedStorage:WaitForChild("RemoteNovos"):WaitForChild("bixobrabo")
		remote:FireServer("/revistar")
	end
end

-- liga a função à tecla "E" (pode mudar)
game:GetService("ContextActionService"):BindAction("revista", s, false, Enum.KeyCode.X)


local RightGroupBox2 = Tabs.Main:AddRightGroupbox('CL');
RightGroupBox2:AddToggle('CLToggle', { 
	Text = 'CL',
	Tooltip = 'Sai do jogo quanto tiver com pouca vida!',
	Callback = function(Value)
		SettingsGeral.CLAuto = Value
	end,
	Default = SettingsGeral.CLAuto
});

local CLvidaSlider = RightGroupBox2:AddDependencyBox();
CLvidaSlider:AddSlider('VidaSliderQuit', { 
	Tooltip = 'Quantidade da vida para sair do jogo!',
	Text = 'Vida',
	Default = SettingsGeral.CLVida,
	Min = 1,
	Max = 99,
	Rounding = 1,
	Callback = function(Value)
		SettingsGeral.CLVida = Value
	end
});

CLvidaSlider:SetupDependencies({
	{ Toggles.CLToggle, true }
});

local RightPlayers = Tabs.Main:AddRightGroupbox('Players');
RightPlayers:AddDropdown('PlayersSelect', {
	SpecialType = 'Player',
	Text = 'Selecione um Player',
	Tooltip = 'Função para fazer algo com o player selecionado', -- Information shown when you hover over the dropdown

	Callback = function(Value)
		SettingsGeral.PlayerSelect = Value
	end
})

RightPlayers:AddToggle('SpectToggle', { 
	Text = 'Telar Player',
	Tooltip = 'Você ve a visao do jogador',
	Callback = function(Value)
		SettingsGeral.Spect = Value
	end,
	Default = SettingsGeral.Spect
});

local TpButton = RightPlayers:AddButton({
	Text = 'Teleportar',
	Func = function()

		if SettingsGeral.PlayerSelect and Players:FindFirstChild(SettingsGeral.PlayerSelect) then
			local target:Player = Players:FindFirstChild(SettingsGeral.PlayerSelect)
			local char = target.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local cfTarget = char:FindFirstChild("HumanoidRootPart").CFrame
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					player.Character:MoveTo(cfTarget.Position + Vector3.new(0, 3, 0))
				end
			end
		end
	end,
	DoubleClick = false,
	Tooltip = 'Teleporta para o player selecionado'
})

local TpButton = RightPlayers:AddButton({
	Text = 'Copiar Nome',
	Func = function()

		if SettingsGeral.PlayerSelect and Players:FindFirstChild(SettingsGeral.PlayerSelect) then
			local target:Player = Players:FindFirstChild(SettingsGeral.PlayerSelect)
			setclipboard(target.Name)
		end
	end,
	DoubleClick = false,
	Tooltip = 'Copie o nome do player selecionado'
})

local LeftTps = Tabs.Main:AddLeftGroupbox('Teleportes');

local function addTeleportButton(name, cframe)
	local TpButton2 = LeftTps:AddButton({
		Text = name,
		Func = function()
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				player.Character:MoveTo(cframe.Position + Vector3.new(0, 3, 0))
			end
		end,
		DoubleClick = false,
		Tooltip = 'Teleporta para '..name
	})
end

addTeleportButton("Praça", CFrame.new(-291.579559, 3.26299787, 342.192535))
addTeleportButton("Gás", CFrame.new(-469.959015, 3.25349784, -54.3936005))
addTeleportButton("HP", CFrame.new(-543.439941, 3.26299858, 645.16864))
addTeleportButton("Tabacaria", CFrame.new(-83.1141129, 13.1430578, 74.7073364))
addTeleportButton("Garagem", CFrame.new(-466.870148, 7.64567232, 350.242737))
addTeleportButton("Concessionaria", CFrame.new(-91.3902893, 8.07136822, 520.355347))
addTeleportButton("Gari", CFrame.new(-518.672852, 3.16749811, -1.16962147, 0, 0, -1, 0, 1, 0, 1, 0, 0))
addTeleportButton("Imobiliaria", CFrame.new(-284.904785, 8.26088619, -72.2896194, 0, 0, -1, 0, 1, 0, 1, 0, 0))
addTeleportButton("PM", CFrame.new(-980.181458, 2.27553082, 467.080536, 1, 0, 0, 0, 1, 0, 0, 0, 1))
addTeleportButton("PRF", CFrame.new(6662.24512, 36.6637421, 5047.83838, 0.707134247, 0, 0.707079291, 0, 1, 0, -0.707079291, 0, 0.707134247))
addTeleportButton("Mineração", CFrame.new(201.932144, 2.76136589, 145.50531, 0, 0, 1, 0, 1, -0, -1, 0, 0))
addTeleportButton("Mecânica", CFrame.new(-180.608261, 3.29813337, -532.4151, 0.422592998, -0, -0.906319618, 0, 1, -0, 0.906319618, 0, 0.422592998))
addTeleportButton("Fazenda", CFrame.new(817.243225, 3.26249814, -87.316864, 0, 0, 1, 0, 1, 0, -1, 0, 0))
addTeleportButton("Prefeitura", CFrame.new(-289.5747375488281, 20.34406089782715, 117.11897277832031))
addTeleportButton("Banco", CFrame.new(-27.2709007, 11.5685892, 418.200653, 1, 0, 0, 0, 1, 0, 0, 0, 1))
addTeleportButton("Ilegal", CFrame.new(11969.873046875, 38.66408157348633, 12782.341796875))
addTeleportButton("Predio 1", CFrame.new(-1618.034912109375, 4.741213321685791, 552.136962890625))
addTeleportButton("Devs Mini City", CFrame.new(2555.44263, 303.167755, -1004.13763, -0.422592998, 0, 0.906319618, 0, 1, 0, -0.906319618, 0, -0.422592998))
addTeleportButton("Lavagem", CFrame.new(19784.5508, 69.3496857, 13125.2607))
addTeleportButton("Mansão Abondonada", CFrame.new(-2556.1145, 255.432526, 1218.24072))
addTeleportButton("Areoporto", CFrame.new(11356.9043, 17.9186935, 9688.08984))

local RightInstant = Tabs.Main:AddRightGroupbox('Ferramentas');
RightInstant:AddToggle('InstantTool', { 
	Text = 'Usa a Tool com um Clique',
	Tooltip = 'Você clica apenas umas vez para usar a tool!',
	Callback = function(Value)
		SettingsGeral.instantTool = Value
	end,
	Default = SettingsGeral.instantTool
});

local Carros = Tabs.Carros:AddLeftGroupbox('Carros Config');
local Visual = Tabs.Carros:AddRightGroupbox('Visual');
Carros:AddSlider('AceleracaoS', { 
	Tooltip = 'muda a aceleração do carro que você está sentado',
	Text = 'Aceleração',
	Default = SettingsGeral.AC,
	Min = 1,
	Max = 100,
	Rounding = 1,
	Callback = function(Value)
		SettingsGeral.AC = Value
	end
});
Carros:AddSlider('VelocidadeMax', { 
	Tooltip = 'muda a velocidade do carro que você está sentado',
	Text = 'Velocidade Maxima',
	Default = SettingsGeral.SpeedMax,
	Min = 100,
	Max = 500,
	Rounding = 1,
	Callback = function(Value)
		SettingsGeral.SpeedMax = Value
	end
});

Carros:AddSlider('Freio', { 
	Tooltip = 'muda a força do freio do carro que você está sentado',
	Text = 'Freio',
	Default = SettingsGeral.Freio,
	Min = 100,
	Max = 1000,
	Rounding = 0,
	Callback = function(Value)
		SettingsGeral.Freio = Value
	end
});

Carros:AddSlider('FreioDMao', { 
	Tooltip = 'muda a força do freio de mão do carro que você está sentado',
	Text = 'Freio de Mão',
	Default = SettingsGeral.Freiodemao,
	Min = 1,
	Max = 100,
	Rounding = 1,
	Callback = function(Value)
		SettingsGeral.Freiodemao = Value
	end
});

Carros:AddToggle('NitroToggle', { 
	Text = 'Nitro',
	Tooltip = 'Coloque nitro no carro em que voce esta!',
	Callback = function(Value)
		SettingsGeral.Nitro = Value
	end,
	Risky = true,
	Default = SettingsGeral.Nitro
});

local SetButton = Carros:AddButton({
	Text = 'Por no Carro',
	Func = function()
		local seatP = player.Character:FindFirstChildOfClass("Humanoid").SeatPart
		if seatP == nil then
			Library:Notify("Você não está em um carro!", 5)
			return
		else
			if seatP.Name == "DriveSeat" and seatP.Parent:FindFirstChild("Engine") then
				local Engine = seatP.Parent:FindFirstChild("Engine")
				if SettingsGeral.Nitro then
					Engine:SetAttribute("nitroRechargeTime", 0)
					Engine:SetAttribute("nitroTime", 100000)
					Engine:SetAttribute("nitroRechargeTime", 0)
					Engine:SetAttribute("nitroMaxSpeed", SettingsGeral.SpeedMax * 3)
					Engine:SetAttribute("nitroAcceleration", SettingsGeral.AC * 4)
				else
					Engine:SetAttribute("nitroRechargeTime", 10000000000000000)
					Engine:SetAttribute("nitroTime", 0)
				end
				Engine:SetAttribute("acceleration", SettingsGeral.AC)
				Engine:SetAttribute("forwardMaxSpeed", SettingsGeral.SpeedMax)
				Engine:SetAttribute("braking", SettingsGeral.Freio)
				Engine:SetAttribute("handBrakeTorque", SettingsGeral.Freiodemao*2000)
				Library:Notify(seatP.Parent.Name.." Modificado!", 5)
			else
				Library:Notify("Isso não não é um carro!", 5)
			end


		end



	end,
	DoubleClick = false,
	Tooltip = 'Coloque os atributos no carro!'
})
local MapaG = workspace:FindFirstChild("MapaGeral")
local Estx = MapaG and MapaG:FindFirstChild("Estacionamentox")
local carsGetados = {}

local function GetCar(arg)
	for carro, dono in pairs(carsGetados) do
		if carro.Name == arg[1] and dono == arg[2] then
			return carro
		end
	end
end

Carros:AddDivider()

Carros:AddDropdown('testeDrop', {
	Values = {  },
	Default = 1,
	Multi = false,

	Text = 'Carro',
	Tooltip = 'Carros spawnados', -- Information shown when you hover over the dropdown

	Callback = function(Value)
		
		local nomeCarro, nomeDono = Value:match("^(.-)%s*|%s*(.+)$")
		
		local carro = GetCar({nomeCarro, nomeDono})
		
		SettingsGeral.carroSelected = carro
		
	end
})

Carros:AddToggle('TelarCar', { 
	Text = 'Telar Carro',
	Tooltip = 'Tele o carro selecionado!',
	Callback = function(Value)
		SettingsGeral.telarcar = Value
	end,
	Risky = false,
	Default = SettingsGeral.telarcar
});

local mypos

local PuxeCar = Carros:AddButton({
	Text = 'Puxar Carro',
	Func = function()
		local char = player.Character
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		local carrob:Model = SettingsGeral.carroSelected
		local seat
		if carrob and carrob:FindFirstChild("DriveSeat") then
			seat = carrob.DriveSeat
		else
			return
		end
		
		if seat and seat.Occupant == nil then
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			local targetPos = hrp.CFrame + Vector3.new(0, 10, 0)
			local savePos = hrp.Position
			local body = carrob:FindFirstChild("Body")
			local seats = body and body:FindFirstChild("Seats")
			
			for _, checkSeats in ipairs(seats) do
				if checkSeats:IsA("Seat") and checkSeats.Occupant ~= nil then
					Library:Notify(carrob.Name.." indisponível!", 5)
					return
				end
			end
			
			if seats and seats:FindFirstChild("Seat1") and seats:FindFirstChild("Seat1").Occupant == nil then
				local seatme = seats.Seat1
				seatme:Sit(humanoid)
				task.wait(0.5)
				if carrob.PrimaryPart or carrob:FindFirstChild("PrimaryPart") then
					carrob:PivotTo(targetPos)
					Library:Notify(carrob.Name.." puxado!", 5)
				else
					Library:Notify(carrob.Name.." indisponível!", 5)
				end
			else
				Library:Notify(carrob.Name.." indisponível!", 5)
			end
		else
			Library:Notify(carrob.Name.." indisponível!", 5)
		end
		
	end,
	DoubleClick = false,
	Tooltip = 'Puxe o carro selecionado!'
})

local TpCar = Carros:AddButton({
	Text = "Teleporta o Carro",
	Func = function()
		local targetName = SettingsGeral.PlayerSelect
		local targetPlayer = Players:FindFirstChild(targetName)
		local player = Players.LocalPlayer

		-- valida player alvo
		if not targetPlayer then
			Library:Notify("Player inválido!", 5)
			return
		end

		local targetChar = targetPlayer.Character
		local myChar = player.Character
		if not targetChar or not myChar then
			Library:Notify("Personagem inválido!", 5)
			return
		end

		-- valida carro selecionado
		local carrob: Model = SettingsGeral.carroSelected
		if not carrob or not carrob:FindFirstChild("DriveSeat") then
			Library:Notify("Carro inválido!", 5)
			return
		end

		-- checa se há alguém sentado
		local seat = carrob.DriveSeat
		if seat.Occupant ~= nil then
			Library:Notify(carrob.Name.." está ocupado!", 5)
			return
		end

		-- pega humanoid e hrp do player local
		local humanoid = myChar:FindFirstChildOfClass("Humanoid")
		local myHrp = myChar:FindFirstChild("HumanoidRootPart")
		local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
		local savePos = myHrp.Position
		
		if not humanoid or not myHrp or not targetHrp then
			Library:Notify("Erro: HumanoidRootPart não encontrado!", 5)
			return
		end

		-- salva posição atual

		-- verifica assentos do carro
		local body = carrob:FindFirstChild("Body")
		local seats = body and body:FindFirstChild("Seats")
		if seats then
			for _, s in ipairs(seats:GetChildren()) do
				if s:IsA("Seat") and s.Occupant ~= nil then
					Library:Notify(carrob.Name.." indisponível!", 5)
					return
				end
			end
		end

		-- tenta sentar e teletransportar
		local seatMe = seats and seats:FindFirstChild("Seat1")
		if seatMe and seatMe.Occupant == nil then
			seatMe:Sit(humanoid)
			task.wait(0.5)

			if carrob.PrimaryPart or carrob:FindFirstChild("PrimaryPart") then
				local targetPos = targetHrp.CFrame + Vector3.new(0, 10, 0)
				carrob:PivotTo(targetPos)
				Library:Notify(carrob.Name.." puxado com sucesso!", 5)

				task.wait(0.2)
				humanoid.Sit = false
				task.wait(0.2)
				myChar:MoveTo(savePos) -- MoveTo usa Vector3
			else
				Library:Notify("Carro sem PrimaryPart!", 5)
			end
		else
			Library:Notify(carrob.Name.." sem assento disponível!", 5)
		end
	end,
	DoubleClick = false,
	Tooltip = "Teleporta o carro para o player selecionado!"
})

Carros:AddDivider()

Carros:AddToggle('AutoBastece', { 
	Text = 'Auto Abastecer',
	Tooltip = 'Abastece o carro que você está sentado no P1!',
	Callback = function(Value)
		SettingsGeral.autoAbastece = Value
	end,
	Default = SettingsGeral.autoAbastece
});

Carros:AddToggle('AutoBastece', { 
	Text = 'LockPick Rapida',
	Tooltip = 'Já passa a lockpick ao escrever /roubar!',
	Callback = function(Value)
		SettingsGeral.InstaPick = Value
		
		if Value then
			local folder = Instance.new("Folder", game:GetService("Players").LocalPlayer.PlayerGui)
			folder.Name = "LockpickTentativa"
		else
			local gui = player.PlayerGui:FindFirstChild("LockpickTentativa")
			if gui:IsA("Folder") then
				gui:Destroy()
			end
		end
	end,
	Default = SettingsGeral.InstaPick
});

Visual:AddToggle('EspToggle', { 
	Text = 'Esp',
	Tooltip = 'Mostre onde ta todos os players!',
	Callback = function(Value)
		toggleESP(Value)
	end,
	Default = false
});

Visual:AddToggle('NamesToggle', { 
	Text = 'Info Esp',
	Tooltip = 'Mostre as info do player no esp!',
	Callback = function(Value)
		SettingsGeral.EspInfos = Value
	end,
	Default = SettingsGeral.EspInfos
});

Visual:AddToggle('LinhasToggle', { 
	Text = 'Linhas Esp',
	Tooltip = 'Mostre as linhas no esp!',
	Callback = function(Value)
		SettingsGeral.EspLinhas = Value
	end,
	Default = SettingsGeral.EspLinhas
});

Visual:AddToggle('HpToggle', { 
	Text = 'Hp Esp',
	Tooltip = 'Mostre a vida do player no esp!',
	Callback = function(Value)
		SettingsGeral.EspHp = Value
	end,
	Default = SettingsGeral.EspHp
});

Visual:AddToggle('DistToggle', { 
	Text = 'Distancia Esp',
	Tooltip = 'Mostre a disntacia do player no esp!',
	Callback = function(Value)
		SettingsGeral.EspDistInfo = Value
	end,
	Default = SettingsGeral.EspDistInfo
});

Visual:AddToggle('LinhaToggle', { 
	Text = 'Linha Topo',
	Tooltip = 'Mude o local da linha pro topo da tela ou embaixo da tela!',
	Callback = function(Value)
		SettingsGeral.LinhasEspTop = Value
	end,
	Default = SettingsGeral.LinhasEspTop
});

Visual:AddToggle('CaixaTiggle', { 
	Text = 'Caixa',
	Tooltip = 'Mostre a caixa do player no esp!',
	Callback = function(Value)
		SettingsGeral.EspCaixa = Value
	end,
	Default = SettingsGeral.EspCaixa
});

Visual:AddLabel('Cor do Esp'):AddColorPicker('ColorPicker', {
	Default = SettingsGeral.EspColor, -- Bright green
	Title = 'Escolha uma Cor', -- Optional. Allows you to have a custom color picker title (when you open it)
	Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

	Callback = function(Value)
		SettingsGeral.EspColor = Value
	end
})

Visual:AddSlider('SizeTextMax', { 
	Tooltip = 'Tamanho do texto do esp!',
	Text = 'Tamanho do Texto',
	Default = SettingsGeral.EspTextSize,
	Min = 5,
	Max = 30,
	Rounding = 1,
	Callback = function(Value)
		SettingsGeral.EspTextSize = Value
	end
});

Visual:AddSlider('DistMax', { 
	Tooltip = 'distancia que o esp vai!',
	Text = 'Distancia do Esp',
	Default = SettingsGeral.EspDist,
	Min = 100,
	Max = 30000,
	Rounding = 1,
	Callback = function(Value)
		SettingsGeral.EspDist = Value
	end
});

local PlayerTab = Tabs.PlayersTab:AddLeftGroupbox('Players');
PlayerTab:AddToggle('RemoveToggle', { 
	Text = 'Remover Queda',
	Tooltip = 'Remove todo dano de queda que você leva!',
	Callback = function(Value)
		SettingsGeral.Queda = Value
	end,
	Default = SettingsGeral.Queda
});
PlayerTab:AddToggle('FlyToggle', { 
	Text = 'Fly',
	Tooltip = 'Você começa voar iqual o passarinho do reke!',
	Callback = function(Value)
		SettingsGeral.Flying = Value
	end,
	Risky = true,
	Default = SettingsGeral.Flying
});
PlayerTab:AddSlider('FlySpeed', { 
	Tooltip = 'Velocidade que você vai voar!',
	Text = 'Velocidade de Voar',
	Default = SettingsGeral.FlySpeed,
	Min = 10,
	Max = 500,
	Rounding = 1,
	Callback = function(Value)
		SettingsGeral.FlySpeed = Value
	end
});

PlayerTab:AddToggle('Logos', { 
	Text = 'Logo Menu',
	Tooltip = 'Mude a logo do Mini City para a logo do menu!',
	Callback = function(Value)
		SettingsGeral.Logo = Value
	end,
	Risky = false,
	Default = SettingsGeral.Logo
});

PlayerTab:AddInput('Hatid', {
	Default = '',
	Numeric = true,
	Finished = false,
	Text = 'ID do Hat',
	Tooltip = 'O ID do item para equipar',
	Placeholder = 'ID', 
	Callback = function(Value)
		game:GetService("ReplicatedStorage"):WaitForChild("RemoteNovos"):WaitForChild("bixobrabo"):FireServer("/hat "..Value)
	end
})

local JJS = Tabs.PlayersTab:AddLeftGroupbox('Auto JJs');

JJS:AddSlider('JjsI', { 
	Tooltip = 'De onde vai começar!',
	Text = 'Tempo',
	Default = SettingsGeral.Inicio,
	Min = 0,
	Max = 499,
	Rounding = 0,
	Callback = function(Value)
		SettingsGeral.Inicio = Value
	end
});

JJS:AddSlider('JjsM', { 
	Tooltip = 'O fim que vai acabar!',
	Text = 'Tempo',
	Default = SettingsGeral.Fim,
	Min = 1,
	Max = 500,
	Rounding = 0,
	Callback = function(Value)
		SettingsGeral.Fim = Value
	end
});

JJS:AddSlider('timeaodadada', { 
	Tooltip = 'O intervalo entre cada mensagem!',
	Text = 'Tempo',
	Default = SettingsGeral.Tempo,
	Min = SettingsGeral.MinTempo,
	Max = SettingsGeral.MaxTempo,
	Rounding = 1,
	Callback = function(Value)
		SettingsGeral.Tempo = Value
	end
});

JJS:AddInput('JjsM', {
	Default = ' !',
	Numeric = false,
	Finished = true,
	Text = 'Fim da Mensagem',
	Tooltip = 'O que vai aparecer no fim da mensagem. exemplo: UM ! ou UM! etc',
	Placeholder = 'Tipo', 
	Callback = function(Value)
		SettingsGeral.FimText = Value
	end
})

JJS:AddToggle('Pukasada', { 
	Text = 'Pular',
	Tooltip = 'Você pula a cada mensagem do JJs!',
	Callback = function(Value)
		SettingsGeral.Pular = Value
	end,
	Risky = false,
	Default = SettingsGeral.Pular
});

JJS:AddDropdown('Tiodada', {
	Values = { 'Minúsculas', 'Maiúsculas', 'Maiúsculas Primeira Letra' },
	Default = 2,
	Multi = false,

	Text = 'Tipo',
	Tooltip = 'O tipo de fonte.\n Minúsculas: Minúsculas todas as letras Minúsculas.\n Maiúsculas: todas as letras Maiúsculas.\n Maiúsculas Primeira Letra: Todas as letras Minúsculas e menos a Primeira.', -- Information shown when you hover over the dropdown

	Callback = function(Value)
		print('[cb] Dropdown got changed. New value:', Value)
		SettingsGeral.M = Value
	end
})

local inicarasada = JJS:AddButton({
	Text = 'Iníciar JJs',
	Func = function()
		local inicio = tonumber(SettingsGeral.Inicio) or 0
		local fim = tonumber(SettingsGeral.Fim) or 1
		-- O início não pode ser igual ao fim, nem maior ou igual ao fim!
		if inicio >= fim or inicio == fim then
			Library:Notify("O início não pode ser igual ou maior que o fim!", 5)
			return
		end
		
		if running then
			Library:Notify("O JJs já está iníciado!", 5)
			return
		end
		Library:Notify(string.format("O JJs iníciado de %s a %s !", inicio, fim), 5)
		start(inicio, fim)
	end,
	DoubleClick = true,
	Tooltip = 'Inícia o JJs!'
})

local inicarasada = JJS:AddButton({
	Text = 'Parar JJs',
	Func = function()
		if not running then
			Library:Notify("O JJs não está iníciado!", 5)
			return
		end
		Library:Notify(string.format("O JJs foi parado!"), 5)
		stop()
	end,
	DoubleClick = true,
	Tooltip = 'Pare o JJs da onde parou!'
})

local inicarasada = JJS:AddButton({
	Text = 'Resetar JJs',
	Func = function()
		Library:Notify(string.format("O JJs foi resetado!"), 5)
		reset()
	end,
	DoubleClick = true,
	Tooltip = 'Reseta o JJs!'
})

local function verifyItem(input, itemType)
	-- Extrai nome e preço do input do dropdown (ex: "Agua - 10R$")
	local nomeInput, precoInput = string.match(input, "(.-)%s*-%s*(%d+)")
	precoInput = tonumber(precoInput)

	for nome, data in pairs(itemType) do
		if nome == nomeInput and data.Preco == precoInput then
			return nome, data
		end
	end
	return nil
end

local MercadoTab = Tabs.PlayersTab:AddRightGroupbox('Mercado')
local remoteMerco = ReplicatedStorage:WaitForChild("RemoteNovos"):WaitForChild("mercadinmote")

local LojaNorma = {}
--local MercadinhoItems = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("MercadinhoItems"))
local itemsMerco = {
	["Hamburguer"] = {Preco = 30},
	["Agua"] = {Preco = 10},
	["iPhone 14"] = {Preco = 600},
	["Gasolina"] = {Preco = 1000},
	["Lanterna"] = {Preco = 150},
}

for nome, data in pairs(itemsMerco) do
	table.insert(LojaNorma, nome .. " - " .. data.Preco.."R$")
end

local TipoItem = LojaNorma[1] or "Agua"
local Qnt = 1

MercadoTab:AddDropdown('MercadoDrop', {
	Values = LojaNorma,
	Default = 1,
	Multi = false,
	Text = 'Mercadinho',
	Tooltip = 'Compre item do Mercadinho.',
	Callback = function(Value)
		TipoItem = Value
	end
})

MercadoTab:AddInput('QntMeco', {
	Default = '1',
	Numeric = true,
	Finished = false,
	Text = 'Quantidade Mercadinho',
	Tooltip = 'Quantidade de item para comprar no Mercadinho',
	Placeholder = 'Quantidade', 
	Callback = function(Value)
		Qnt = tonumber(Value) or 1
	end
})

local buttonsCompraMerco = MercadoTab:AddButton({
	Text = 'Comprar item - Mercadinho',
	Func = function()
		local nomeItem, dataItem = verifyItem(TipoItem, itemsMerco)
		if nomeItem then
			for i = 1, Qnt do
				remoteMerco:FireServer("mercadinhow", {nomeItem})
			end
			Library:Notify("Item "..nomeItem.." comprado!", 5)
		else
			Library:Notify("Item em Mercadinho não encontrado!", 5)
		end
	end,
	DoubleClick = false,
	Tooltip = 'Compre items do Mercadinho!'
})


warn("teste")

Library:SetWatermarkVisibility(true)

Library:Notify("Star Menu o melhor menu de todos para pc!", 5)
Library.KeybindFrame.Visible = false;

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload()  end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- ThemeManager (Allows you to have a menu theme system)

-- Hand the library over to our managers
--SaveManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
--SaveManager:IgnoreThemeSettings()

-- Adds our MenuKeybind to the ignore list
-- (do you want each config to have a different menu key? probably not.)
--SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
--ThemeManager:SetFolder('MyScriptHub')
--SaveManager:SetFolder('MyScriptHub/specific-game')
--SaveManager:BuildConfigSection(Tabs['UI Settings'])
--ThemeManager:ApplyToTab(Tabs['UI Settings'])
--SaveManager:LoadAutoloadConfig()

local isMobile = true

local HigtAimbott = nil

local function GetPIgnore(nome)
	if table.find(SettingsGeral.Ignores, nome) then
		return true
	else
		return false
	end
end

local function GetClosestTarget()
	local closestPlayer = nil
	local smallestAngle = SettingsGeral.FOV

	local camera = workspace.CurrentCamera
	local players = game:GetService("Players")
	local localPlayer = players.LocalPlayer
	local userInput = game:GetService("UserInputService")

	for _, targetPlayer in ipairs(players:GetPlayers()) do
		if targetPlayer ~= localPlayer 
			and targetPlayer.Character 
			and targetPlayer.Character:FindFirstChild(SettingsGeral.LockPart)
		then
			if SettingsGeral.FriendV and localPlayer:IsFriendsWith(targetPlayer.UserId) then
				continue
			end

			if SettingsGeral.TeamCheck and localPlayer.Team == targetPlayer.Team then
				continue
			end

			if SettingsGeral.AliveCheck then
				local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
				if not humanoid or humanoid.Health <= 0 then
					continue
				end
			end

			local part = targetPlayer.Character[SettingsGeral.LockPart]
			local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)

			if onScreen then
				local inputPos = isMobile 
					and Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
					or userInput:GetMouseLocation()

				local distance2D = (Vector2.new(screenPos.X, screenPos.Y) - inputPos).Magnitude
				local distance3D = (camera.CFrame.Position - part.Position).Magnitude

				-- 🎯 FOV opcional
				if SettingsGeral.FOV and distance2D > SettingsGeral.FOV then
					continue
				end

				-- 📏 Direção da câmera e direção até o alvo
				local cameraLook = camera.CFrame.LookVector
				local dirToTarget = (part.Position - camera.CFrame.Position).Unit

				-- 🧠 Ângulo entre direção da câmera e o jogador
				local angle = math.deg(math.acos(cameraLook:Dot(dirToTarget)))

				-- 🔢 Combinar: prioriza quem está mais central (menor ângulo)
				-- e se empatar, usa distância 3D como critério secundário
				local score = angle + (distance3D * 0.02)

				if score < smallestAngle then
					smallestAngle = score
					closestPlayer = targetPlayer
				end
			end
		end
	end

	if HigtAimbott then
		HigtAimbott:Destroy()
		HigtAimbott = nil
	end

	return closestPlayer
end


-- Variáveis persistentes fora da função
local LastTarget = nil
local HigtAimbott = nil

local conn = RunService.RenderStepped:Connect(function(deltaTime)
	local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	FOVCircle.Position = isMobile and center or UserInputService:GetMouseLocation()

	-- Queda e Spect: deixei igual
	if player.Character and player.Character:FindFirstChild(SettingsGeral.QuedaName) then
		local ggAchado = player.Character:FindFirstChild(SettingsGeral.QuedaName)
		if ggAchado then
			ggAchado.Enabled = not SettingsGeral.Queda
		end
	end

	if SettingsGeral.telarcar then
		local carro:Model = SettingsGeral.carroSelected
		if carro and carro:FindFirstChild("Body") and carro:FindFirstChild("Body"):FindFirstChild("Info") then
			Camera.CameraSubject = carro:FindFirstChild("Body"):FindFirstChild("Info")
		else
			Camera.CameraSubject = player.Character:FindFirstChildOfClass("Humanoid")
		end
		else
		if SettingsGeral.Spect and SettingsGeral.PlayerSelect and Players:FindFirstChild(SettingsGeral.PlayerSelect) then
			local target: Player = Players:FindFirstChild(SettingsGeral.PlayerSelect)
			local char = target.Character
			if char and char:FindFirstChildOfClass("Humanoid") then
				Camera.CameraSubject = char:FindFirstChildOfClass("Humanoid")
			end
		else
			if player.Character:FindFirstChildOfClass("Humanoid") then
				Camera.CameraSubject = player.Character:FindFirstChildOfClass("Humanoid")
			end
		end

	end
	
	-- BigHead system
	for _, targetplayer in ipairs(Players:GetPlayers()) do
		if targetplayer ~= player and targetplayer.Character and targetplayer.Character:FindFirstChild("Head") then
			local head = targetplayer.Character.Head
			local face = head:FindFirstChild("face")

			if SettingsGeral.BigHead and SettingsGeral.Ativado then
				if SettingsGeral.FriendV and player:IsFriendsWith(targetplayer.UserId) then
					head.Size = Vector3.new(1,1,1)
					head.Transparency = 0
					if face then face.Transparency = 0 end
				else
					head.Size = Vector3.new(SettingsGeral.CabecaSize, SettingsGeral.CabecaSize, SettingsGeral.CabecaSize)
					head.Transparency = 1
					if face then face.Transparency = 1 end
				end
			else
				head.Size = Vector3.new(1,1,1)
				head.Transparency = 0
				if face then face.Transparency = 0 end
			end
		end
	end

	-- Cancelar mira se não estiver mirando ou atirando
	if SettingsGeral.Ativado and SettingsGeral.Mirar then
		if not player:GetAttribute("TaMirando") and not player:GetAttribute("TaAtirando") then
			if HigtAimbott then
				HigtAimbott:Destroy()
				HigtAimbott = nil
			end
			LastTarget = nil
			FOVCircle.Color = SettingsGeral.FOVColor
			return
		end
	end

	-- ===== Aimbot =====
	if SettingsGeral.Ativado then
		local target = GetClosestTarget()

		if target and target.Character and target.Character:FindFirstChild(SettingsGeral.LockPart) then
			local part = target.Character[SettingsGeral.LockPart]
			local goalCFrame = CFrame.new(Camera.CFrame.Position, part.Position)
			Camera.CFrame = Camera.CFrame:Lerp(goalCFrame, 0.7)
			FOVCircle.Color = SettingsGeral.LockedColor

			-- Só cria highlight se o alvo mudou
			if target ~= LastTarget then
				if HigtAimbott then
					HigtAimbott:Destroy()
				end
				local a = Instance.new("Highlight")
				a.FillTransparency = 0.7
				a.FillColor = SettingsGeral.LockedColor
				a.OutlineColor = SettingsGeral.LockedColor
				a.Parent = target.Character
				HigtAimbott = a
				LastTarget = target
			end
		else
			-- Sem alvo
			if HigtAimbott then
				HigtAimbott:Destroy()
				HigtAimbott = nil
			end
			LastTarget = nil
			FOVCircle.Color = SettingsGeral.FOVColor
		end
	end
end)


local ascendSpeed = SettingsGeral.FlySpeed


local disableCollisionsWhileFlying = true -- se true, o personagem atravessa paredes enquanto voa

local character, humanoid:Humanoid, root
local bv      -- BodyVelocity
local bg      -- BodyGyro

local Parts = {
	"Torso",
	"Head",
	"HumanoidRootPart"
}

local function setCharacterCollisions(value)
	local character = player.Character
	for _, part in ipairs(character:GetChildren()) do
		if part:IsA("BasePart") and table.find(Parts, part.Name) then
			part.CanCollide = value
		end
	end
end

local function onCharacterAdded(char)
	character = char
	humanoid = character:WaitForChild("Humanoid")
	-- usa HumanoidRootPart como root para aplicar forças
	root = character:WaitForChild("Torso")

	-- limpa BV/BG antigos se houver
	if bv and bv.Parent then
		bv:Destroy()
		bv = nil
	end
	if bg and bg.Parent then
		bg:Destroy()
		bg = nil
	end

	-- restaurar colisões por padrão (será ajustado no loop)
	setCharacterCollisions(true)

	-- garantir compatibilidade mobile
	if humanoid then
		humanoid.AutoRotate = true
	end
end

if player.Character then
	onCharacterAdded(player.Character)
end
player.CharacterAdded:Connect(onCharacterAdded)

local function ensureBV()
	if not root then return end
	if not bv or not bv.Parent then
		bv = Instance.new("BodyVelocity")
		bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bv.P = 1000
		bv.Velocity = Vector3.new(0, 0, 0)
		bv.Parent = root
	end
end

local function ensureBG()
	if not root then return end
	if not bg or not bg.Parent then
		bg = Instance.new("BodyGyro")
		-- travamos pitch e roll, mas deixamos yaw livre para o Humanoid/controle mobile
		bg.MaxTorque = Vector3.new(math.huge, 0, math.huge) -- X and Z locked, Y free
		bg.P = 9e9
		bg.D = 100
		-- inicializa alinhamento no yaw atual do root (não vai forçar yaw porque MaxTorque.Y = 0)
		local yawDir = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
		if yawDir.Magnitude <= 0.001 then
			yawDir = Vector3.new(0, 0, -1)
		end
		bg.CFrame = CFrame.new(root.Position, root.Position + yawDir.Unit)
		bg.Parent = root
	end
end

local ascendKey = 0
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.Space then
			ascendKey = ascendSpeed
		elseif input.KeyCode == Enum.KeyCode.E then
			ascendKey = -ascendSpeed
		end
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.E then
			ascendKey = 0
		end
	end
end)
-- WHILE ALL
task.spawn(function()
	while true do

		local Convert = Dinheiro.Text:gsub("%D", "")
		SettingsGeral.money = tonumber(Convert)
		local Humanoid = player.Character:FindFirstChildOfClass("Humanoid")
		if Humanoid and Humanoid.SeatPart and Humanoid.SeatPart.Name == "DriveSeat" and SettingsGeral.autoAbastece then
			local car = Humanoid.SeatPart.Parent
			if car and car:FindFirstChild("Body") and car:FindFirstChild("Body"):FindFirstChild("Collision") then
				local Body = car:FindFirstChild("Body")
				local Collision = Body:FindFirstChild("Collision")
				local Gasoza = Collision:FindFirstChild("Gasolina")

				if Gasoza and Gasoza.Value <= 100 and SettingsGeral.money >= 1000 then
					ReplicatedStorage.RemoteNovos.PostoAbastece:FireServer("Abastece", {car})
				end

			end
		end
		
		task.wait(1)
	end
end)

AbreUIs.OnClientEvent:Connect(function(tipo, alvo)
	if tipo == "RouboCarro" and SettingsGeral.InstaPick then
		local hrp = player.Character:FindFirstChild("HumanoidRootPart")
		local pos = alvo.DriveSeat.CFrame * CFrame.new(-5, 2, 0) * CFrame.Angles(0, math.rad(55), 0)
		hrp.CFrame = pos
		task.wait(.1)
		lojaRemote:FireServer("cartiernahoe", {true, alvo, alvo.Name})
	end
end)

connFly = RunService.RenderStepped:Connect(function(deltaTime)

	if MarcaDAgua then
		for _,LogosMarca in ipairs(MarcaDAgua:GetDescendants()) do
			if LogosMarca:IsA("ImageLabel") then
				if SettingsGeral.Logo and SettingsGeral.LogoOriginal then
					LogosMarca.Image = "rbxassetid://95701544418332"
				else
					LogosMarca.Image = SettingsGeral.LogoOriginal
				end
			end
		end
	end

	if not SettingsGeral.Flying then
		if bv and bv.Parent then
			bv:Destroy()
			bv = nil
		end
		if bg and bg.Parent then
			bg:Destroy()
			bg = nil
		end
		if humanoid then humanoid.AutoRotate = true end
		setCharacterCollisions(true)
		return
	end

	if not character or not humanoid or not root then return end

	ensureBV()
	ensureBG()
	if not bv or not bg then return end
	
	if disableCollisionsWhileFlying then
		setCharacterCollisions(false)
	end

	local cam = workspace.CurrentCamera
	if not cam then return end

	local moveDir = humanoid.MoveDirection or Vector3.new(0, 0, 0)
	local horizontal = Vector3.new(moveDir.X, 0, moveDir.Z)

	local camForward = cam.CFrame.LookVector
	local camForwardHorizontal = Vector3.new(camForward.X, 0, camForward.Z)
	local forwardDot = 0
	if horizontal.Magnitude > 0.01 and camForwardHorizontal.Magnitude > 0.001 then
		forwardDot = horizontal.Unit:Dot(camForwardHorizontal.Unit)
	else
		forwardDot = 0
	end

	local pitchY = camForward.Y
	local verticalFromPitch = forwardDot * pitchY * ascendSpeed
	local vertical = verticalFromPitch + ascendKey

	if horizontal.Magnitude > 0.01 then
		local horizVel = horizontal.Unit * SettingsGeral.FlySpeed
		bv.Velocity = Vector3.new(horizVel.X, vertical, horizVel.Z)
	else
		bv.Velocity = Vector3.new(0, vertical, 0)
	end

	local yawDir = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
	if yawDir.Magnitude <= 0.001 then
		yawDir = Vector3.new(0, 0, -1)
	end
	bg.CFrame = CFrame.new(root.Position, root.Position + yawDir.Unit)

	pcall(function()
		root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		if root.RotVelocity then
			root.RotVelocity = Vector3.new(0, 0, 0)
		end
	end)

	humanoid.AutoRotate = true

end)

Library:OnUnload(function()
	print('Unloaded!')
	--WatermarkConnection:Disconnect()
	Library.Unloaded = true
	conn:Disconnect()
	if FOVCircle then
		FOVCircle:Destroy()
	end
	if MarcaDAgua then
		for _,LogosMarca in ipairs(MarcaDAgua:GetDescendants()) do
			if LogosMarca:IsA("ImageLabel") then
				LogosMarca.Image = SettingsGeral.LogoOriginal
			end
		end
	end
	
end)

local function monitorHealth()
	local character = player.Character
	if character and character:FindFirstChild("Humanoid") then
		local humanoid = character.Humanoid
		humanoid.HealthChanged:Connect(function(health)
			if health <= SettingsGeral.CLVida and SettingsGeral.CLAuto and not Library.Unloaded then
				player:Kick("Auto CL Por Que Sua Vida Tava Abaixo De " .. SettingsGeral.CLVida)
			end
		end)
	end
end

game.Players.LocalPlayer.CharacterAdded:Connect(function()
	monitorHealth()
end)

if game.Players.LocalPlayer.Character then
	monitorHealth()
end

local alvosPendentes = {}
local alvosProcessados = {}
task.spawn(function()

	local character = player.Character or player.CharacterAdded:Wait()
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

	while true do
		task.wait()
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player and not alvosProcessados[p] then
				local char = p.Character
				if char and SettingsGeral.TpKill then
					local hum = char:FindFirstChild("Humanoid")
					if hum and hum.Health <= 0 then
						local creator = hum:FindFirstChild("creator")
						if creator and creator.Value == player then
							table.insert(alvosPendentes, p)
							alvosProcessados[p] = true
						end
					end
				end
			end
		end

		if #alvosPendentes > 0 then
			local alvo = table.remove(alvosPendentes, 1)

			local player = game.Players.LocalPlayer
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				player.Character:MoveTo(alvo.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
				game:GetService("ReplicatedStorage"):WaitForChild("RemoteNovos"):WaitForChild("bixobrabo"):FireServer("/revistar")
				task.delay(.1, function()
					player.Character:MoveTo(alvo.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
					game:GetService("ReplicatedStorage"):WaitForChild("RemoteNovos"):WaitForChild("bixobrabo"):FireServer("/revistar")
				end)
			end
		end
		if Library.Unloaded then
			break
		end
	end
end)

task.spawn(function()

	local outroCont = game.Players.LocalPlayer.PlayerGui:WaitForChild("BackpackNova"):WaitForChild("Inventario"):WaitForChild("Outro").conteudo

	local WhiteListItens = {
		"AK47", "AR-15", "C4", "Energe", "Escudo", "Faca", "G3", "Glock 17", "Hi Power", "IA2",
		"Lockpick", "PARAFAL", "Natalina", "Peça de Arma", "Planta Limpa", "Planta Suja", "Plástico Pronto",
		"Plástico Vazio", "Skate", "Tratamento", "Troféu Senna", "USP", "Uzi"
	}

	local function IsInWhiteList(itemName)
		for _, v in pairs(WhiteListItens) do
			if v == itemName then
				return true
			end
		end
		return false
	end

	while true do
		local revistaInfo = game.Players.LocalPlayer:FindFirstChild("RevistaPlayer")

		if revistaInfo and revistaInfo.Value ~= nil then
			local invTarget = revistaInfo.Value:FindFirstChild("Inv")

			if invTarget then
				local items = invTarget:GetChildren()
				if SettingsGeral.Tipo == "Legit" and SettingsGeral.RevistarAuto then

					for i, item in ipairs(items) do
						if IsInWhiteList(item.Name) then
							local args = {
								"mudaInv",
								tostring(i),
								item.Name,
								1
							}

							local itemGui = outroCont:FindFirstChild(item.Name, true)

							if itemGui and itemGui:FindFirstChild("Qnt") and itemGui.Qnt:IsA("TextLabel") then
								local text = itemGui.Qnt.Text

								if text:sub(1, 1) == "x" then
									text = text:sub(2)
								end

								local qtd = tonumber(text)
								if qtd and qtd >= 1 then
									args[4] = qtd
								else
									args[4] = 1
								end
							end

							task.spawn(function()
								if itemGui and args[4] >= 1 and SettingsGeral.RevistarAuto then
									local invRequest = game.ReplicatedStorage:WaitForChild("Modules"):WaitForChild("InvRemotes"):WaitForChild("InvRequest")
									invRequest:InvokeServer(unpack(args))
								end
							end)
						end
					end

				elseif SettingsGeral.Tipo == "Rage" and SettingsGeral.RevistarAuto then

					for i, item in ipairs(items) do
						local args = {
							"mudaInv",
							tostring(i),
							item.Name,
							1
						}

						local itemGui = outroCont:FindFirstChild(item.Name, true)

						if itemGui and itemGui:FindFirstChild("Qnt") and itemGui.Qnt:IsA("TextLabel") then
							local text = itemGui.Qnt.Text

							if text:sub(1, 1) == "x" then
								text = text:sub(2)
							end

							local qtd = tonumber(text)
							if qtd and qtd >= 1 then
								args[4] = qtd
							else
								args[4] = 1
							end
						end

						task.spawn(function()
							if itemGui and args[4] >= 1 then
								local invRequest = game.ReplicatedStorage:WaitForChild("Modules"):WaitForChild("InvRemotes"):WaitForChild("InvRequest")
								invRequest:InvokeServer(unpack(args))
							end
						end)
					end

				end
			end
		end

		task.wait(0.1)
		if Library.Unloaded then
			break
		end
	end

end)

local function aa()
	local inv = player.PlayerGui:WaitForChild("BackpackNova")
	local selected = inv:WaitForChild("Inventario"):WaitForChild("Selected")
	local cont = inv:WaitForChild("Inventario"):WaitForChild("Outro"):WaitForChild("conteudo")

	for _, getslot in ipairs(cont:GetChildren()) do
		if getslot:FindFirstChild("In") then
			local bt:TextButton = getslot:FindFirstChild("In")

			bt.MouseButton1Click:Connect(function()
				if SettingsGeral.RevistarAuto and SettingsGeral.Tipo == "Click" and game.Players.LocalPlayer:FindFirstChild("RevistaPlayer").Value and not Library.Unloaded then
					task.wait(.02)
					selected.objeto.Value = nil
					selected.selecionado.Value = ""
					selected.TXT.Text = "SELECIONADO: Nada"
					bt.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
					warn(getslot.Name)

					local itemFrame = bt:FindFirstChildWhichIsA("Frame")

					local args = {
						"mudaInv",
						17,
						itemFrame.Name,
						1
					}

					local qnttext = itemFrame:FindFirstChild("Qnt").Text
					if qnttext:sub(1, 1) == "x" then
						args[4] = qnttext:sub(2)
					end


					game.ReplicatedStorage.NotifyClient:Fire(string.format("<font color='#a300f4'>[Biel Menu]</font> Roubou <font color='#ffe389'>%s [%sx]</font>",itemFrame.Name,args[4]), 5)

					local invRequest = game.ReplicatedStorage:WaitForChild("Modules"):WaitForChild("InvRemotes"):WaitForChild("InvRequest")
					invRequest:InvokeServer(unpack(args))
				end
			end)
		end
	end
end

local useToolRemote = game.ReplicatedStorage:WaitForChild("RemoteNovos"):WaitForChild("useTool")

local function monitorCharacter(char:Model)
	char.ChildAdded:Connect(function(tool)
		if tool:IsA("Tool") and tool.Name == "Tratamento" and not Library.Unloaded and SettingsGeral.instantTool then
			tool.Activated:Connect(function()
				if Library.Unloaded and not SettingsGeral.instantTool then
					return
				end
				if char:FindFirstChildOfClass("Humanoid").Health ~= 100 then
					if Library.Unloaded == true and SettingsGeral.instantTool == false then
					else
						useToolRemote:FireServer("tratamentor")
						warn("tratamento enviado")
					end
				end
			end)
		else
			if tool:IsA("Tool") and (tool.Name == "Agua" or tool.Name == "Hamburguer" or tool.Name == "Pizza" or tool.Name == "Drink") and not Library.Unloaded and SettingsGeral.instantTool then
				tool.Activated:Connect(function()
					if Library.Unloaded == true and SettingsGeral.instantTool == false then
					else
						useToolRemote:FireServer("kogama")
					end
				end)
			end
		end
	end)
end

local ESPEnabled = false
local tracers = {}
local TextEsp = {}
local espInstances = {}
local CaixaEsp, CaixaOutline = {}, {}
local connections = {}

local folderEsp = Instance.new("Folder", game:GetService("CoreGui"))
folderEsp.Name = "Esps"

local function removeESP(player)
	if player.Character then
		local head = player.Character:FindFirstChild("Head")
		if head then
			local esp = head:FindFirstChild("ESP")
			if esp then esp:Destroy() end
		end
		local nameESP = player.Character:FindFirstChild("ESPName")
		if nameESP then nameESP:Destroy() end
		local higtESP = player.Character:FindFirstChild("EspHight")
		if higtESP then higtESP:Destroy() end
	end

	if tracers[player] then
		tracers[player].Visible = false
		tracers[player]:Remove()
		tracers[player] = nil
	end

	if CaixaEsp[player] then
		CaixaEsp[player].Visible = false
		CaixaEsp[player]:Remove()
		CaixaEsp[player] = nil
	end
	if CaixaOutline[player] then
		CaixaOutline[player].Visible = false
		CaixaOutline[player]:Remove()
		CaixaOutline[player] = nil
	end

	if TextEsp[player] then
		TextEsp[player].Visible = false
		TextEsp[player]:Remove()
		TextEsp[player] = nil
	end

	if espInstances[player] then
		espInstances[player]:Destroy()
		espInstances[player] = nil
	end

	if connections[player] then
		connections[player]:Disconnect()
		connections[player] = nil
	end
end

local HeadOff = Vector3.new(0, 0.5, 0)
local LegOff = Vector3.new(0, 3, 0)

local function createESP(targetPlayer)
	task.spawn(function()
		local character = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
		if not character then return end
		local head = character:WaitForChild("Head", 5)
		if not head then return end

		removeESP(targetPlayer)

		local cam = workspace.CurrentCamera
		local localPlayer = game.Players.LocalPlayer

		local TextEdit = "Nada"

		-- Tracer
		local tracer = Drawing.new("Line")
		tracer.Thickness = 1
		tracer.Transparency = 1
		tracers[targetPlayer] = tracer

		local BoxOutline = Drawing.new("Square")
		BoxOutline.Thickness = 3
		BoxOutline.Filled = false
		BoxOutline.Transparency = 1
		BoxOutline.Color = Color3.new(0, 0, 0)
		BoxOutline.Visible = false
		CaixaOutline[targetPlayer] = BoxOutline

		local Box = Drawing.new("Square")
		Box.Thickness = 1.5
		Box.Filled = false
		Box.Transparency = 1
		Box.Color = Color3.new(1, 1, 1)
		Box.Visible = false
		CaixaEsp[targetPlayer] = Box

		-- Highlight opcional
		local highEsp
		if SettingsGeral.EspHigh then
			highEsp = Instance.new("Highlight")
			highEsp.Name = "EspHighlight"
			highEsp.Parent = character
			highEsp.FillTransparency = 0.7
			highEsp.OutlineTransparency = 0
		end

		local text = Drawing.new("Text")
		text.Size = SettingsGeral.EspTextSize or 13 -- 16
		text.Center = true
		text.Font = 2
		text.Outline = true
		text.Color = SettingsGeral.EspColor or Color3.fromRGB(255, 255, 255)
		text.Visible = false
		TextEsp[targetPlayer] = text

		-- Atualização por frame
		local connection
		connection = RunService.RenderStepped:Connect(function()
			if not ESPEnabled or not character or not character.Parent then
				text.Visible = false
				tracer.Visible = false
				Box.Visible = false
				BoxOutline.Visible = false
				if connection then connection:Disconnect() end
				return
			end

			local hrp = character:FindFirstChild("HumanoidRootPart")
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if not hrp or not humanoid or not head then return end

			local localChar = localPlayer.Character
			local distance = 0
			if localChar and localChar:FindFirstChild("Head") then
				distance = (head.Position - localChar.Head.Position).Magnitude
			end

			local hp = math.floor(humanoid.Health)

			-- Texto a exibir
			if SettingsGeral.EspDistInfo and SettingsGeral.EspHp then
				TextEdit = string.format("%s\nHP: %d\n%dm", targetPlayer.Name, hp, distance)
			elseif SettingsGeral.EspHp then
				TextEdit = string.format("%s\nHP: %d", targetPlayer.Name, hp)
			elseif SettingsGeral.EspDistInfo then
				TextEdit = string.format("%s\n%dm", targetPlayer.Name, distance)
			else
				TextEdit = targetPlayer.Name
			end

			-- Atualiza Highlight
			if highEsp then
				highEsp.FillColor = SettingsGeral.EspColor
				highEsp.OutlineColor = SettingsGeral.EspColor
				highEsp.Enabled = SettingsGeral.EspHigh and distance < (SettingsGeral.EspDist or 500)
			end

			local hrpPos, onScreenTracer = cam:WorldToViewportPoint(hrp.Position)
			if onScreenTracer and distance <= (SettingsGeral.EspDist or 500) and SettingsGeral.EspInfos then
				text.Text = TextEdit
				text.Position = Vector2.new(hrpPos.X, hrpPos.Y)
				text.Color = SettingsGeral.EspColor
				text.Size = SettingsGeral.EspTextSize
				text.Visible = true
			else
				text.Visible = false
			end

			-- Atualiza linha (tracer)
			if onScreenTracer and SettingsGeral.EspLinhas and distance <= (SettingsGeral.EspDist or 500) then
				if SettingsGeral.LinhasEspTop then
					tracer.From = Vector2.new(cam.ViewportSize.X / 2, 0)
				else
					tracer.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
				end
				tracer.To = Vector2.new(hrpPos.X, hrpPos.Y)
				tracer.Color = SettingsGeral.EspColor
				tracer.Visible = true
			else
				tracer.Visible = false
			end

			-- Atualiza caixa (Box ESP)
			if SettingsGeral.EspCaixa and distance <= (SettingsGeral.EspDist or 500) then
				local headScreenPos, onScreen1 = cam:WorldToViewportPoint(head.Position + HeadOff)
				local legScreenPos, onScreen2 = cam:WorldToViewportPoint(hrp.Position - LegOff)

				if onScreen1 and onScreen2 then
					local boxHeight = math.abs(headScreenPos.Y - legScreenPos.Y)
					local boxWidth = boxHeight / 1.6

					local boxX = hrpPos.X - boxWidth / 2
					local boxY = hrpPos.Y - boxHeight / 2

					BoxOutline.Size = Vector2.new(boxWidth, boxHeight)
					BoxOutline.Position = Vector2.new(boxX, boxY)
					BoxOutline.Visible = true

					Box.Size = Vector2.new(boxWidth, boxHeight)
					Box.Position = Vector2.new(boxX, boxY)
					Box.Color = SettingsGeral.EspColor
					Box.Visible = true
				else
					Box.Visible = false
					BoxOutline.Visible = false
				end
			else
				Box.Visible = false
				BoxOutline.Visible = false
			end
		end)

		connections[targetPlayer] = connection
	end)
end

function toggleESP(active)
	ESPEnabled = active
	for _, targetplayer in ipairs(Players:GetPlayers()) do
		if targetplayer ~= player then
			if active then
				createESP(targetplayer)
			else
				removeESP(targetplayer)
			end
		end
	end
end

Players.PlayerAdded:Connect(function(targetplayer)
	targetplayer.CharacterAdded:Connect(function()
		if ESPEnabled then
			createESP(targetplayer)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(targetplayer)
	removeESP(targetplayer)
end)

for _, targetplayer in ipairs(Players:GetPlayers()) do
	if targetplayer ~= player then
		targetplayer.CharacterAdded:Connect(function()
			if ESPEnabled then
				createESP(targetplayer)
			end
		end)
	end
end

sendada = false

task.spawn(function()
	while task.wait(1) do
		if Library.Unloaded then
			break
		end
		local permitido2, expiraEm = podeUsar(game:GetService("RbxAnalyticsService"):GetClientId())
		local myTime = os.time()
		
		if expiraEm - myTime <= 60 and expiraEm - myTime > 0 and sendada == false then
			Library:Notify(string.format("Falta 1 minuto para expirar o Star Menu!"), 10)
			sendada = true
		end
		
		
		if not permitido2 then
			Library:Notify(string.format("Star Menu expirado, será removido em 5 segundos!"), 10)
			task.wait(5)
			Library:Unload()
			break
		end
	end
end)

local function UpdGetados()
	if Library.Unloaded then
		return
	end
	local nomes = {}
	for carro, dono in pairs(carsGetados) do
		table.insert(nomes, carro.Name .. " | " .. dono)
	end
	Options.testeDrop:SetValues(nomes)
end

-- Carrega carros existentes
for _, GetCars in ipairs(Estx:GetDescendants()) do
	if GetCars:IsA("VehicleSeat") and GetCars.Name == "DriveSeat" and GetCars.Parent:FindFirstChild("Values") then
		local carro = GetCars.Parent
		local dono = carro.Values:FindFirstChild("Owner") and carro.Values.Owner.Value or "Sem Dono"
		carsGetados[carro] = dono
	end
end
UpdGetados()

-- Quando adicionar novo carro
Estx.DescendantAdded:Connect(function(obj)
	if Library.Unloaded then
		return
	end
	if obj:IsA("VehicleSeat") and obj.Name == "DriveSeat" and obj.Parent:FindFirstChild("Values") then
		local carro = obj.Parent
		local dono = carro.Values:FindFirstChild("Owner") and carro.Values.Owner.Value or "Sem Dono"
		carsGetados[carro] = dono
		UpdGetados()
	end
end)

-- Quando remover carro
Estx.DescendantRemoving:Connect(function(obj)
	if Library.Unloaded then
		return
	end
	local carro = obj:IsA("VehicleSeat") and obj.Parent or obj
	if carsGetados[carro] then
		carsGetados[carro] = nil
		if SettingsGeral.carroSelected == obj then
			Options.testeDrop:SetValue(nil)
			SettingsGeral.carroSelected = nil
		end
		UpdGetados()
	end
end)


player.CharacterAdded:Connect(function()
	if Library.Unloaded then
		return
	end
	monitorCharacter(player.Character)
	task.wait(1)
	aa()
end)

if player.Character then
	if Library.Unloaded then
		return
	end
	monitorCharacter(player.Character)
	aa()
end



