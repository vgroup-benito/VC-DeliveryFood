ESX = exports['es_extended']:getSharedObject()

RegisterServerEvent('vlore:server:uczesracpsadokuwetyichujmnietoobchodzicosemysliszdumperze', function (moni, value)

    if value == 420 then 

        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
    
            xPlayer.addInventoryItem('money', moni)

    else

        print('test')

    end 
end)