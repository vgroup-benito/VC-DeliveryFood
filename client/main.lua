ESX = exports['es_extended']:getSharedObject()

local targets = {}
local start = false
local injob = false

RegisterCommand('food_start', function ()

    if not start then 

        start = true 

        lib.notify({
            description = Config.Lang.StartJob,
            type = 'inform',
            duration = 5000
        })

        lib.notify({
            description = Config.Lang.CancelSearch,
            type = 'inform',
            duration = 5000
        })

        Wait(20000)
        -- Wait(1000)
        TriggerEvent('vlore:fooddelivery:szukajmnicha')

    elseif not injob and start then

        start = false
        lib.notify({
            description = Config.Lang.FinishWork,
            type = 'inform',
            duration = 3000
        })

    else

        lib.notify({
            description = Config.Lang.YouCant,
            type = 'inform',
            duration = 3000
        })
        
    end
end)

RegisterNetEvent('vlore:fooddelivery:szukajmnicha', function ()

    if start and not injob then 

        injob = true

        local szukanie = math.random(30000,90000)

        -- local szukanie = math.random(3000, 5000)

        Wait(szukanie)
        local randomliczby = math.random(100, 9999)

        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local quests = {}
    
        for p, b in ipairs(Config.Restaurants) do
            table.insert(quests, {coords = b.coords, restaurantname = b.restaurantname, prop = b.prop})
        end
    
        local tasknumber = math.random(1, #quests)
        for a, c in ipairs(quests) do 
            if a == tasknumber then
                SetNewWaypoint(c.coords.x, c.coords.y, c.coords.z)

        -- print(resta)

            ESX.UI.Menu.CloseAll()
    
            ESX.UI.Menu.Open(
                'default', GetCurrentResourceName(), 'lucky_menu',
                {
                    title    = Config.Lang.Order  ..randomliczby.. ' | ' ..c.restaurantname,
                    align    = 'center',
                    elements = {
                        {label = '<span style="color:green;">Accept</span>', value = 'accept'},
                        {label = '<span style="color:red;">Reject</span>', value = 'reject'},
                    }
                },
                function(data, menu)
                    if data.current.value == 'accept' then
                        ESX.UI.Menu.CloseAll()


                        lib.notify({
                            description = Config.Lang.Goto  ..c.restaurantname..  Config.Lang.And,
                            type = 'inform',
                            duration = 5000
                        })


                        targets['luckysmiec'] = exports.ox_target:addBoxZone({
                            coords = vec3(c.coords.x, c.coords.y, c.coords.z),
                            size = vec3(2, 2, 2),
                            name = 'lucky',
                            rotation = 22.2791,
                            debug = drawZones,
                            options = {
                                {
                                    name = 'lucky',
                                    icon = 'fas fa-drumstick-bite',
                                    label = Config.Lang.PickUp,
                                    onSelect = function(data)
                                        exports.ox_target:removeZone(targets['luckysmiec'])

                                        playAnim(ped, 'random@domestic', 'pickup_low')
            
                                        Wait(1500)

                                        ClearPedTasks(ped)
            
                                        box = CreateObject(GetHashKey(c.prop), pos.x, pos.y, pos.z,  false,  true, true)    
                                        AttachEntityToEntity(box, ped, GetPedBoneIndex(ped, 57005), 0.3800, 0.0, -0.0300, 0.0017365, -79.9999997, 110.0651988, true, true, false, true, 1, true)      
                                        playAnim(ped, 'move_weapon@jerrycan@generic', 'idle')

                                        for p, b in ipairs(Config.Tasks) do
                                            table.insert(quests, {coords = b.coords, pay = b.pay, dodatek = b.dodatek})
                                        end
            
                                        local tasknumberr = math.random(1, #quests)
                                        for d, g in ipairs(quests) do 
                                            if d == tasknumberr then
                                                SetNewWaypoint(g.coords.x, g.coords.y, g.coords.z)
            
                                                lib.notify({
                                                    description = Config.Lang.Goto2,
                                                    type = 'inform',
                                                    duration = 5000
                                                })

                                                ESX.ShowAdvancedNotification(Config.Lang.Restaurant  ..c.restaurantname, Config.Lang.Info, g.dodatek, 'CHAR_CHAT_CALL', 1)

                                                targets['customer'] = exports.ox_target:addBoxZone({
                                                    coords = vec3(g.coords.x, g.coords.y, g.coords.z),
                                                    size = vec3(2, 2, 2),
                                                    name = 'customer',
                                                    rotation = g.coords.w,
                                                    debug = drawZones,
                                                    options = {
                                                        {
                                                            name = 'customer',
                                                            icon = 'fas fa-drumstick-bite',
                                                            label = Config.Lang.DeliverOrder,
                                                            onSelect = function(data)
                                                                exports.ox_target:removeZone(targets['customer'])
                                                                playAnim(ped, 'mp_common', 'givetake1_a')
                                                                Wait(1500)
                                                                DeleteObject(box)
                                                                ClearPedTasks(ped)
                                                                start = false 
                                                                injob = false
                                                                TriggerServerEvent('vlore:server:uczesracpsadokuwetyichujmnietoobchodzicosemysliszdumperze', g.pay, 420)
                                                            end
                                                            }
                                                        }
                                                    })
            
                                        end
                                    end
                                end
                                }
                            }
                        })
                    elseif data.current.value == 'reject' then
                        ESX.UI.Menu.CloseAll()

                        start = false
                        injob = false

                        lib.notify({
                            description = Config.Lang.Reject2,
                            type = 'inform',
                            duration = 5000
                        })

                    end
                end,
                function(data, menu)
                    menu.close()
                        start = false
                        injob = false

                        lib.notify({
                            description = Config.Lang.Reject2,
                            type = 'inform',
                            duration = 5000
                        })
                end
            )
    end
end
end
end)

function playAnim(ped, dictionary, anim)
	Citizen.CreateThread(function()
	  RequestAnimDict(dictionary)
	  while not HasAnimDictLoaded(dictionary) do
		Citizen.Wait(0)
	  end
		TaskPlayAnim(ped, dictionary, anim ,8.0, -8.0, -1, 49, 0, false, false, false)
	end)
end  