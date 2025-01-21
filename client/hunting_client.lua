local QBCore = exports['qb-core']:GetCoreObject()

-- Переменные для отслеживания
local spawnedAnimals = {}
local deadAnimals = {}
local isHunting = false
local huntingZoneBlip = nil

-- Вспомогательная функция для отображения 3D текста
local function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end

-- Функция создания блипа зоны охоты
local function CreateHuntingZoneBlip()
    huntingZoneBlip = AddBlipForRadius(Config.HuntingZone.x, Config.HuntingZone.y, Config.HuntingZone.z, Config.SpawnRadius)
    SetBlipRotation(huntingZoneBlip, 0)
    SetBlipColour(huntingZoneBlip, 69) -- Светло-зеленый цвет
    SetBlipAlpha(huntingZoneBlip, 100)
end

-- Функция удаления блипа зоны охоты
local function RemoveHuntingZoneBlip()
    if huntingZoneBlip then
        RemoveBlip(huntingZoneBlip)
        huntingZoneBlip = nil
    end
end

-- Функция спавна случайного животного
local function SpawnRandomAnimal()
    if not isHunting then return end
    
    -- Выбор животного на основе вероятности
    local rand = math.random(100)
    local currentProb = 0
    local selectedAnimal = nil
    
    for _, animal in pairs(Config.Animals) do
        currentProb = currentProb + Config.SpawnChance[animal.model]
        if rand <= currentProb then
            selectedAnimal = animal
            break
        end
    end
    
    if not selectedAnimal then return end
    
    local randomAngle = math.random() * 2 * math.pi
    local randomRadius = math.random() * Config.SpawnRadius
    
    local spawnX = Config.HuntingZone.x + math.cos(randomAngle) * randomRadius
    local spawnY = Config.HuntingZone.y + math.sin(randomAngle) * randomRadius
    local spawnZ = Config.HuntingZone.z
    
    -- Загрузка модели
    RequestModel(GetHashKey(selectedAnimal.model))
    while not HasModelLoaded(GetHashKey(selectedAnimal.model)) do
        Wait(1)
    end
    
    -- Создание животного
    local ped = CreatePed(28, GetHashKey(selectedAnimal.model), spawnX, spawnY, spawnZ, 0.0, true, false)
    SetEntityAsMissionEntity(ped, true, true)
    
    -- Настройка поведения
    TaskWanderStandard(ped, 10.0, 10)
    SetPedFleeAttributes(ped, 0, false)
    
    -- Добавление в таблицу отслеживания
    table.insert(spawnedAnimals, {
        entity = ped,
        model = selectedAnimal.model,
        reward = selectedAnimal.reward
    })
    
    SetModelAsNoLongerNeeded(GetHashKey(selectedAnimal.model))
end

-- Функция сбора добычи
local function HarvestAnimal(entity, reward)
    if deadAnimals[entity] then
        QBCore.Functions.Progressbar("harvest_animal", Lang:t("info.harvesting"), 5000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "amb@world_human_gardener_plant@male@base",
            anim = "base",
            flags = 1,
        }, {}, {}, function() -- Done
            TriggerServerEvent('hunting:harvestAnimal', reward)
            DeleteEntity(entity)
            deadAnimals[entity] = nil
            
            for k, v in pairs(spawnedAnimals) do
                if v.entity == entity then
                    table.remove(spawnedAnimals, k)
                    break
                end
            end
            
            QBCore.Functions.Notify(Lang:t("success.animal_harvested"), "success")
        end)
    end
end

-- Создание метки сбора добычи
local function CreateHarvestPrompt(entity, reward)
    local coords = GetEntityCoords(entity)
    
    CreateThread(function()
        while deadAnimals[entity] and isHunting do
            DrawMarker(2, coords.x, coords.y, coords.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 100, false, true, 2, nil, nil, false)
            
            local playerCoords = GetEntityCoords(PlayerPedId())
            local dist = #(playerCoords - coords)
            
            if dist < 2.0 then
                DrawText3D(coords.x, coords.y, coords.z + 1.2, Lang:t("info.press_to_harvest"))
                
                if IsControlJustPressed(0, 38) then -- E key
                    HarvestAnimal(entity, reward)
                end
            end
            Wait(0)
        end
    end)
end

-- Функция для проверки мертвых животных
local function CheckDeadAnimals()
    if not isHunting then return end
    
    for k, v in pairs(spawnedAnimals) do
        if IsEntityDead(v.entity) and not deadAnimals[v.entity] then
            deadAnimals[v.entity] = true
            CreateHarvestPrompt(v.entity, v.reward)
        end
    end
end



-- Функция очистки охоты
local function CleanupHunting()
    for _, animal in pairs(spawnedAnimals) do
        if DoesEntityExist(animal.entity) then
            DeleteEntity(animal.entity)
        end
    end
    spawnedAnimals = {}
    deadAnimals = {}
    isHunting = false
    RemoveHuntingZoneBlip()
end

-- Проверка лицензии на оружие
local function CheckWeaponLicense(cb)
    QBCore.Functions.TriggerCallback('hunting:checkWeaponLicense', function(hasLicense)
        cb(hasLicense)
    end)
end

-- Основной цикл
CreateThread(function()
    while true do
        local sleep = 1000
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        -- Метка начала охоты
        local distToStart = #(playerCoords - Config.Markers.Start)
        if distToStart < 10.0 then
            sleep = 0
            DrawMarker(1, Config.Markers.Start.x, Config.Markers.Start.y, Config.Markers.Start.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.0, 50, 157, 50, 100, false, true, 2, false, nil, nil, false)
            
            if distToStart < 1.5 then
                DrawText3D(Config.Markers.Start.x, Config.Markers.Start.y, Config.Markers.Start.z, Lang:t("info.press_to_start"))
                if IsControlJustPressed(0, 38) then -- E key
                    if not isHunting then
                        CheckWeaponLicense(function(hasLicense)
                            if hasLicense then
                                isHunting = true
                                CreateHuntingZoneBlip()
                                QBCore.Functions.Notify(Lang:t("success.hunting_started"), "success")
                            else
                                QBCore.Functions.Notify(Lang:t("error.no_weapon_license"), "error")
                            end
                        end)
                    else
                        QBCore.Functions.Notify(Lang:t("error.already_hunting"), "error")
                    end
                end
            end
        end
        
        -- Метка завершения охоты
        local distToEnd = #(playerCoords - Config.Markers.End)
        if distToEnd < 10.0 then
            sleep = 0
            DrawMarker(1, Config.Markers.End.x, Config.Markers.End.y, Config.Markers.End.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.0, 157, 50, 50, 100, false, true, 2, false, nil, nil, false)
            
            if distToEnd < 1.5 then
                DrawText3D(Config.Markers.End.x, Config.Markers.End.y, Config.Markers.End.z, Lang:t("info.press_to_end"))
                if IsControlJustPressed(0, 38) then -- E key
                    if isHunting then
                        CleanupHunting()
                        QBCore.Functions.Notify(Lang:t("success.hunting_ended"), "success")
                    else
                        QBCore.Functions.Notify(Lang:t("error.not_hunting"), "error")
                    end
                end
            end
        end
        
        -- Спавн и проверка животных
        if isHunting then
            local distToHuntingZone = #(playerCoords - Config.HuntingZone)
            if distToHuntingZone < Config.ZoneCheckRadius then
                if #spawnedAnimals < Config.MaxAnimals then
                    SpawnRandomAnimal()
                end
                CheckDeadAnimals()
            else
                QBCore.Functions.Notify(Lang:t("error.too_far"), "error")
                CleanupHunting()
            end
        end
        
        Wait(sleep)
    end
end)