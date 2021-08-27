local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

emP = {}
Tunnel.bindInterface("emp_hacker",emP)
local idgens = Tools.newIDGenerator()
local porcentagem = 0
local itemname = ""
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------

--fifith -> Dps com drop menor de coletes
function emP.checkPayment(vestPoint,fifith)
	local source = source
	local user_id = vRP.getUserId(source)
	local nomeBonito = ""
	local porcentagem = math.random(100)
	local quantidade = 0
	if user_id then
		if vestPoint then
			itemname = "colete"
			nomeBonito = "Colete Balístico"
			if fifith then
				quantidade = 1
				if porcentagem >= 50 then
					TriggerClientEvent("Notify",source,"importante","Nenhum item encontrado no local, tente novamente!",8000)
					return false
				elseif exports["pd-inventory"]:checkWeightAmount(user_id,itemname,parseInt(quantidade)) then
					exports["pd-inventory"]:giveItem(user_id,itemname,parseInt(quantidade))
					TriggerClientEvent("Notify",source,"sucesso","Você hackeou o sistema com sucesso e roubou <b>"..quantidade.." "..nomeBonito.."</b>.",8000)
					return true
				else
					return false
				end
			else
				quantidade = 5
				if porcentagem <= 70 then
					TriggerClientEvent("Notify",source,"importante","Nenhum item encontrado no local, tente novamente!",8000)
					return false
				else
					exports["pd-inventory"]:giveItem(user_id,itemname,parseInt(quantidade))
					TriggerClientEvent("Notify",source,"sucesso","Você hackeou o sistema com sucesso e roubou <b>"..quantidade.." "..nomeBonito.."</b>.",8000)
					return true
				end
			end
		else
			itemname = "keycard"
			nomeBonito = "Cartão de Acesso"
			quantidade = 1
			if porcentagem <= 30 then
				TriggerClientEvent("Notify",source,"importante","Nenhum item encontrado no local, tente novamente!",8000)
				return false
			elseif exports["pd-inventory"]:checkWeightAmount(user_id,itemname,parseInt(quantidade)) then
				exports["pd-inventory"]:giveItem(user_id,itemname,parseInt(quantidade))
				TriggerClientEvent("Notify",source,"sucesso","Você hackeou o sistema com sucesso e roubou <b>"..quantidade.." "..nomeBonito.."</b>.",8000)
				return true
			else
				return false
			end
		end
	end	
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkTimers()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["pd-inventory"]:getItemAmount(user_id,"laptop") >= 1 then
			return true
		else
			TriggerClientEvent("Notify",source,"importante","Precisa de um <b>laptop</b> para hackear o sistema.",8000)
			return false
		end
	end
end

function emP.checkPolice()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local policia = vRP.getUsersByPermission("policia.permissao")
		if #policia >= 0 then
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Não há policiais suficientes em serviço.") 
			return false
		end
	end
end

local blips = {}
function emP.MarcarOcorrencia()
	local source = source
	local user_id = vRP.getUserId(source)
	local x,y,z = vRPclient.getPosition(source)
	if user_id then
		local soldado = vRP.getUsersByPermission("policia.permissao")
		for l,w in pairs(soldado) do
			local player = vRP.getUserSource(parseInt(w))
			if player then
				async(function()
					local id = idgens:gen()
					blips[id] = vRPclient.addBlip(player,x,y,z,153,84,"Ocorrência",0.5,false)
					vRPclient._playSound(player,"CONFIRM_BEEP","HUD_MINI_GAME_SOUNDSET")
					TriggerClientEvent('chatMessage',player,"911",{64,64,255},"Recebemos a denuncia de um hacker, verifique o ocorrido.")
					SetTimeout(15000,function() vRPclient.removeBlip(player,blips[id]) idgens:free(id) end)
				end)
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK TIMER
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.setSearch()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.searchTimer(user_id,parseInt(300))
	end
end