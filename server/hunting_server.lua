local QBCore = exports['qb-core']:GetCoreObject()

-- Награды за добычу
local rewards = {
    deer_carcass = {
        items = {
            {name = "meat", amount = 4},
            {name = "leather", amount = 2}
        },
        money = 25
    },
    rabbit_carcass = {
        items = {
            {name = "meat", amount = 1},
            {name = "leather", amount = 1}
        },
        money = 15
    },
    mtlion_carcass = {
        items = {
            {name = "meat", amount = 3},
            {name = "leather", amount = 3}
        },
        money = 50
    },
    bird_carcass = {
        items = {
            {name = "meat", amount = 1},
            {name = "feathers", amount = 2}
        },
        money = 5
    }
}

-- Проверка лицензии на оружие
QBCore.Functions.CreateCallback('hunting:checkWeaponLicense', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local licenseTable = Player.PlayerData.metadata["licences"]
    
    if licenseTable.weapon then
        cb(true)
    else
        cb(false)
    end
end)

-- Обработчик события сбора добычи
RegisterNetEvent('hunting:harvestAnimal')
AddEventHandler('hunting:harvestAnimal', function(rewardType)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    local reward = rewards[rewardType]
    if not reward then return end
    
    -- Выдаем предметы
    for _, item in pairs(reward.items) do
        Player.Functions.AddItem(item.name, item.amount)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], "add")
    end
    
    -- Выдаем деньги
    Player.Functions.AddMoney("cash", reward.money)
    
    TriggerClientEvent('QBCore:Notify', src, 'Вы получили добычу и $' .. reward.money, 'success')
end)