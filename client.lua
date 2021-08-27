local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("emp_hacker")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = false
local selecionado = 0
local emservico = false
local lastSelected = 0
local CoordenadaX = 1275.52
local CoordenadaY = -1710.56
local CoordenadaZ = 54.78
--1275.52,-1710.56,54.78
local locais = {
	{ ['id'] = 1, ['x'] = -106.5, ['y'] = 6469.23, ['z'] = 31.63, ['h'] = 318.87, ['vestPoint'] = false, ['fifith'] = false }, --paleto bank
	{ ['id'] = 2, ['x'] = -2961.4, ['y'] = 477.23, ['z'] = 15.7, ['h'] = 163.32, ['vestPoint'] = false, ['fifith'] = false },  --fleeca estrada
	{ ['id'] = 3, ['x'] = -1216.89, ['y'] = -335.97, ['z'] = 37.79, ['h'] = 144.88, ['vestPoint'] = false, ['fifith'] = false }, --fleeca bahamas
	{ ['id'] = 4, ['x'] = -357.49, ['y'] = -50.54, ['z'] = 49.04, ['h'] = 111.5, ['vestPoint'] = false, ['fifith'] = false },  --fleeca LS
	{ ['id'] = 5, ['x'] = 252.66, ['y'] = 207.89, ['z'] = 106.29, ['h'] = 297.43, ['vestPoint'] = false, ['fifith'] = false }, --Central
	{ ['id'] = 6, ['x'] = 307.48, ['y'] = -279.77, ['z'] = 54.17, ['h'] = 119.0, ['vestPoint'] = false, ['fifith'] = false },  --fleeca Hp antigo
	{ ['id'] = 7, ['x'] = 143.23, ['y'] = -1041.41, ['z'] = 29.37, ['h'] = 119.52, ['vestPoint'] = false, ['fifith'] = false }, --fleeca praça
	{ ['id'] = 8, ['x'] = 1180.95, ['y'] = 2709.6, ['z'] = 38.09, ['h'] = 324.14, ['vestPoint'] = false, ['fifith'] = false },  --fleeca sandy

	{ ['id'] = 9, ['x'] = -2044.51, ['y'] = -504.57, ['z'] = 12.5, ['h'] = 219.23, ['vestPoint'] = true, ['fifith'] = false },  --dp rota
	{ ['id'] = 10, ['x'] = 1853.16, ['y'] = 3689.71, ['z'] = 34.27, ['h'] = 277.35, ['vestPoint'] = true, ['fifith'] = true },  --dp sandy
	{ ['id'] = 11, ['x'] = 441.16, ['y'] = -978.85, ['z'] = 30.69, ['h'] = 168.75, ['vestPoint'] = true, ['fifith'] = false },  --dp pmesp
	{ ['id'] = 12, ['x'] = 813.83, ['y'] = 156.73, ['z'] = 82.82, ['h'] = 16.89, ['vestPoint'] = true, ['fifith'] = false },  --dp civil
	{ ['id'] = 13, ['x'] = -1167.82, ['y'] = -739.31, ['z'] = 21.51, ['h'] = 227.86, ['vestPoint'] = true, ['fifith'] = true }, --dp copom
	{ ['id'] = 14, ['x'] = -449.23, ['y'] = 6012.67, ['z'] = 31.72, ['h'] = 46.23, ['vestPoint'] = true, ['fifith'] = true }  --dp norte (paleto)
}


-----------------------------------------------------------------------------------------------------------------------------------------
-- TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local kswait = 1000
		if not emservico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(CoordenadaX,CoordenadaY,CoordenadaZ)
			local distance = GetDistanceBetweenCoords(CoordenadaX,CoordenadaY,cdz,x,y,z,true)
            if distance <= 4 then
                kswait = 4
				DrawMarker(22,CoordenadaX,CoordenadaY,CoordenadaZ-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,232,67,147,100,1,0,0,1)
				if distance <= 1.2 then
					drawTxt("PRESSIONE  ~r~E~w~  PARA INICIAR A COLETA DE DADOS",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) and emP.checkPolice() then
                        emP.setSearch()
						emservico = true
						selecionado = math.random(#locais)
						CriandoBlip(locais,selecionado)
						TriggerEvent("Notify","sucesso","Você entrou em serviço.")						
					end
				end
			end
        end
        Citizen.Wait(kswait)
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- HACKEAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local kswait = 1000	
		if emservico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(locais[selecionado].x,locais[selecionado].y,locais[selecionado].z)
			local distance = GetDistanceBetweenCoords(locais[selecionado].x,locais[selecionado].y,cdz,x,y,z,true)
            if distance <= 10 then
                kswait = 4
				DrawMarker(3,locais[selecionado].x,locais[selecionado].y,locais[selecionado].z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,232,67,147,100,1,0,0,1)
				if distance <= 2.5 then
					drawTxt("PRESSIONE  ~r~E~w~  PARA HACKEAR A REDE",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) and emP.checkTimers() and emP.checkPolice() and not IsInVehicle() then
						TriggerEvent('cancelando',true)                        
						vRP._playAnim(false,{{"anim@heists@ornate_bank@hack","hack_loop"}},true)
						laptop = CreateObject(GetHashKey("prop_laptop_01a"),x-0.6,y+0.2,z-1,true,true,true)
						SetEntityHeading(ped,85.77)
						SetEntityHeading(laptop,85.77)
						local puzzle = 1 --math.random(1,2)
						if puzzle == 1 then
							TriggerEvent("iniciarhacker")
						else
							TriggerEvent("mhacking:start",3,15,mycallback)
							TriggerEvent("mhacking:show")
						end
						TriggerEvent('cancelando',false) 
						RemoveBlip(blips)
						backentrega = selecionado
						lastSelected = backentrega
						while true do
							if backentrega == selecionado then
								selecionado = math.random(14)
							else
								break
							end
							Citizen.Wait(1)
						end
						CriandoBlip(locais,selecionado)
						TriggerEvent("Notify","importante","Vá até o próximo local e invada o sistema.")
					end
				end
			end
        end
        Citizen.Wait(kswait)	
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HACKEAR
-----------------------------------------------------------------------------------------------------------------------------------------
function mycallback(success,time)
	TriggerEvent("mhacking:hide")
	DeleteObject(laptop)
	vRP._stopAnim(false)
	TriggerEvent('cancelando',false)
	if success then	
		emP.checkPayment(locais[lastSelected].vestPoint, locais[lastSelected].fifith)
	else
		emP.MarcarOcorrencia()
        SetPedComponentVariation(PlayerPedId(),5,45,0,0)
	end
end

function leaveService()
    emservico = false
    RemoveBlip(blips)
    TriggerEvent("Notify","aviso","Você saiu de serviço.")
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local kswait = 1000
        if emservico then
            kswait = 4
			if IsControlJustPressed(0,121) then
			    TriggerEvent("Notify","importante","Vá até o próximo local para invadir o sistema.")
			elseif IsControlJustPressed(0,168) then
				emservico = false
				RemoveBlip(blips)
				TriggerEvent("Notify","aviso","Você saiu de serviço.")
			end
        end
        Citizen.Wait(kswait)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function CriandoBlip(locais,selecionado)
	blips = AddBlipForCoord(locais[selecionado].x,locais[selecionado].y,locais[selecionado].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Hacker")
	EndTextCommandSetBlipName(blips)
end

function IsInVehicle()
	local ply = PlayerPedId()
	if IsPedSittingInAnyVehicle(ply) then
		return true
	else
		return false
	end
end


RegisterNetEvent("iniciarhacker")
AddEventHandler("iniciarhacker",function()
	FreezeEntityPosition(PlayerPedId(),true)
	scaleform = Initialize("HACKING_PC")
    UsingComputer = true
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3Ds(x,y,z,text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.34, 0.34)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.001+ factor, 0.028, 0, 0, 0, 78)
end

function loadAnimDict( dict )  
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

local PalavrasSenha = {
	[1] = "ILHANOVA",
	[2] = "HACKERSK",
	[3] = "PMHACKED",
	[4] = "KEYCARDS",
	[5] = "KHRTPSLO",
	[6] = "AGTRDNSK",
	[7] = "AGAROMEU",
	[8] = "HENRIQUE",
	[9] = "XDANIELX"
}
--local PalavrasSenha = "ILHANOVA"
local Ipfinished = false

Citizen.CreateThread(function()
    function Initialize(scaleform)
        local scaleform = RequestScaleformMovieInteractive(scaleform)
        while not HasScaleformMovieLoaded(scaleform) do
            Citizen.Wait(0)
        end
        
        local CAT = 'hack'
        local CurrentSlot = 0
        while HasAdditionalTextLoaded(CurrentSlot) and not HasThisAdditionalTextLoaded(CAT, CurrentSlot) do
            Citizen.Wait(0)
            CurrentSlot = CurrentSlot + 1
        end
        
        if not HasThisAdditionalTextLoaded(CAT, CurrentSlot) then
            ClearAdditionalText(CurrentSlot, true)
            RequestAdditionalText(CAT, CurrentSlot)
            while not HasThisAdditionalTextLoaded(CAT, CurrentSlot) do
                Citizen.Wait(0)
            end
        end

        PushScaleformMovieFunction(scaleform, "SET_LABELS")
        ScaleformLabel("H_ICON_1")
        ScaleformLabel("H_ICON_2")
        ScaleformLabel("H_ICON_3")
        ScaleformLabel("H_ICON_4")
        ScaleformLabel("H_ICON_5")
        ScaleformLabel("H_ICON_6")
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_BACKGROUND")
        PushScaleformMovieFunctionParameterInt(1)
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "ADD_PROGRAM")
        PushScaleformMovieFunctionParameterFloat(1.0)
        PushScaleformMovieFunctionParameterFloat(4.0)
        PushScaleformMovieFunctionParameterString("Meu Computador")
        PopScaleformMovieFunctionVoid()
        
        PushScaleformMovieFunction(scaleform, "ADD_PROGRAM")
        PushScaleformMovieFunctionParameterFloat(6.0)
        PushScaleformMovieFunctionParameterFloat(6.0)
        PushScaleformMovieFunctionParameterString("Desligar")
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_LIVES")
        PushScaleformMovieFunctionParameterInt(lives)
        PushScaleformMovieFunctionParameterInt(5)
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_LIVES")
        PushScaleformMovieFunctionParameterInt(lives)
        PushScaleformMovieFunctionParameterInt(5)
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(1)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(2)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(3)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(4)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(5)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(6)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(7)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()
        

        return scaleform
    end
    scaleform = Initialize("HACKING_PC")
    while true do
        Citizen.Wait(0)
        if UsingComputer then
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
            PushScaleformMovieFunction(scaleform, "SET_CURSOR")
            PushScaleformMovieFunctionParameterFloat(GetControlNormal(0, 239))
            PushScaleformMovieFunctionParameterFloat(GetControlNormal(0, 240))
            PopScaleformMovieFunctionVoid()
            if IsDisabledControlJustPressed(0,24) and not SorF then
                PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT_SELECT")
                ClickReturn = PopScaleformMovieFunction()
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
            elseif IsDisabledControlJustPressed(0, 176) and Hacking then
                PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT_SELECT")
                ClickReturn = PopScaleformMovieFunction()
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
            elseif IsDisabledControlJustPressed(0, 25) and not Hacking and not SorF then
                PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT_BACK")
                PopScaleformMovieFunctionVoid()
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
            elseif IsDisabledControlJustPressed(0, 172) and Hacking then
                PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT")
                PushScaleformMovieFunctionParameterInt(8)
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
            elseif IsDisabledControlJustPressed(0, 173) and Hacking then
                PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT")
                PushScaleformMovieFunctionParameterInt(9)
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
            elseif IsDisabledControlJustPressed(0, 174) and Hacking then
                PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT")
                PushScaleformMovieFunctionParameterInt(10)
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
            elseif IsDisabledControlJustPressed(0, 175) and Hacking then
                PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT")
                PushScaleformMovieFunctionParameterInt(11)
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
		    end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local kswait = 500
        if HasScaleformMovieLoaded(scaleform) and UsingComputer then
            kswait = 0
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            if GetScaleformMovieFunctionReturnBool(ClickReturn) then
                ProgramID = GetScaleformMovieFunctionReturnInt(ClickReturn)
                if ProgramID == 83 and not Hacking and Ipfinished then
                    chanceshack = 1
                    
                    PushScaleformMovieFunction(scaleform, "SET_LIVES")
                    PushScaleformMovieFunctionParameterInt(chanceshack)
                    PushScaleformMovieFunctionParameterInt(5)
                    PopScaleformMovieFunctionVoid()

                    PushScaleformMovieFunction(scaleform, "OPEN_APP")
                    PushScaleformMovieFunctionParameterFloat(1.0)
                    PopScaleformMovieFunctionVoid()
                    
                    PushScaleformMovieFunction(scaleform, "SET_ROULETTE_WORD")
					local aleato = math.random(9)
                    PushScaleformMovieFunctionParameterString(PalavrasSenha[aleato])
                    PopScaleformMovieFunctionVoid()

                    Hacking = true
                elseif ProgramID == 82 and not Hacking and not Ipfinished then
                    chanceshack = 1

                    PushScaleformMovieFunction(scaleform, "SET_LIVES")
                    PushScaleformMovieFunctionParameterInt(chanceshack)
                    PushScaleformMovieFunctionParameterInt(5)
                    PopScaleformMovieFunctionVoid()

                    PushScaleformMovieFunction(scaleform, "OPEN_APP")
                    PushScaleformMovieFunctionParameterFloat(0.0)
                    PopScaleformMovieFunctionVoid()

                    Hacking = true
                elseif Hacking and ProgramID == 87 then
                    chanceshack = chanceshack - 1
                    PushScaleformMovieFunction(scaleform, "SET_LIVES")
                    PushScaleformMovieFunctionParameterInt(chanceshack)
                    PushScaleformMovieFunctionParameterInt(5)
                    PopScaleformMovieFunctionVoid()
                    PlaySoundFrontend(-1, "HACKING_CLICK_BAD", "", false)
                elseif Hacking and ProgramID == 84 then
                	Ipfinished = true
                    PlaySoundFrontend(-1, "HACKING_CLICK_GOOD", "", false)
                    PushScaleformMovieFunction(scaleform, "SET_IP_OUTCOME")
                    PushScaleformMovieFunctionParameterBool(true)
                    ScaleformLabel(0x18EBB648)
                    PopScaleformMovieFunctionVoid()
                    PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                    PopScaleformMovieFunctionVoid()
                    Hacking = false
                elseif Hacking and ProgramID == 85 then
                    PlaySoundFrontend(-1, "HACKING_CLICK_BAD", "", false)
                    PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                    PopScaleformMovieFunctionVoid()
                    Hacking = false
                    SorF = false
                elseif Hacking and ProgramID == 92 then
                    PlaySoundFrontend(-1, "HACKING_CLICK_GOOD", "", false)
                elseif Hacking and ProgramID == 86 then
                    SorF = true
                    PlaySoundFrontend(-1, "HACKING_SUCCESS", "", true)
                    PushScaleformMovieFunction(scaleform, "SET_ROULETTE_OUTCOME")
                    PushScaleformMovieFunctionParameterBool(true)
                    ScaleformLabel("WINBRUTE")
                    PopScaleformMovieFunctionVoid()
                    Wait(0)
                    PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                    PopScaleformMovieFunctionVoid()
                    Hacking = false
                    SorF = false    
                    mHacking = false
                    Ipfinished = false
                    FreezeEntityPosition(PlayerPedId(), false)
                    TriggerEvent("Notify","sucesso","Hackeado com sucesso!")                                    
                    emP.checkPayment(locais[lastSelected].vestPoint, locais[lastSelected].fifith)
					DeleteObject(laptop)
					vRP._stopAnim(false)
                    UsingComputer = false
					TriggerEvent('cancelando',false)
                    Wait(1000)
                elseif ProgramID == 6 then
                    UsingComputer = false
                    SetScaleformMovieAsNoLongerNeeded(scaleform)
                    DisableControlAction(0, 24, false)
                    DisableControlAction(0, 25, false)
                    FreezeEntityPosition(PlayerPedId(), false)
                    Ipfinished = false
                    Hacking = false
                    SorF = false    
                    mHacking = false
                    TriggerEvent('cancelando',false)
                end
                
                if Hacking then
                    PushScaleformMovieFunction(scaleform, "SHOW_LIVES")
                    PushScaleformMovieFunctionParameterBool(true)
                    PopScaleformMovieFunctionVoid()
                    if chanceshack <= 0 then
                        SorF = true
                        PlaySoundFrontend(-1, "HACKING_FAILURE", "", true)
                        PushScaleformMovieFunction(scaleform, "SET_ROULETTE_OUTCOME")
                        PushScaleformMovieFunctionParameterBool(false)
                        ScaleformLabel("LOSEBRUTE")
                        PopScaleformMovieFunctionVoid()
                        Wait(300)
                        ClearPedTasks(PlayerPedId())
                        PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                        PopScaleformMovieFunctionVoid()
                        SetScaleformMovieAsNoLongerNeeded(scaleform)
                        Hacking = false
                        SorF = false
                        mHacking = false
                        Ipfinished = false
                        TriggerEvent('cancelando',false)
                        TriggerEvent("Notify","aviso","Voce falhou ao tentar acessar o <b>sistema</b>.")
                        SetPedComponentVariation(PlayerPedId(),5,45,0,0)  
                        FreezeEntityPosition(PlayerPedId(),false)
                        UsingComputer = false
                        emP.MarcarOcorrencia()
						DeleteObject(laptop)
						vRP._stopAnim(false)
						TriggerEvent('cancelando',false)  
						FreezeEntityPosition(PlayerPedId(),false)
                    end
                end
            end
        else
            Wait(250)
        end
        Citizen.Wait(kswait)
    end
end)

function ScaleformLabel(label)
    BeginTextCommandScaleformString(label)
    EndTextCommandScaleformString()
end