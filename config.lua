Config = {}

Config.Lang="ru" --eng/ru

-- Основные настройки охоты
Config.HuntingZone = vector3(-1498.12, 4578.19, 35.36) -- Координаты зоны охоты
Config.SpawnRadius = 750.0 -- Радиус спавна животных
Config.ZoneCheckRadius = 800.0 -- Радиус проверки нахождения в зоне охоты


-- Метки на карте
Config.Markers = {
    Start = vector3(-1493.67, 4971.6, 63.91), -- Начало охоты
    End = vector3(-1491.92, 4975.19, 63.73), -- Завершение охоты
}

-- Настройки спавна животных
Config.MaxAnimals = 10 -- Максимальное количество животных в зоне
Config.SpawnChance = { -- Вероятность спавна каждого животного (в процентах)
    ["a_c_deer"] = 40,
    ["a_c_rabbit_01"] = 30,
    ["a_c_mtlion"] = 20,
    ["a_c_crow"] = 10,
}

-- Список животных
Config.Animals = {
    {
        name = "deer",
        model = "a_c_deer",
        reward = "deer_carcass"
    },
    {
        name = "rabbit",
        model = "a_c_rabbit_01",
        reward = "rabbit_carcass"
    },
    {
        name = "mtlion",
        model = "a_c_mtlion",
        reward = "mtlion_carcass"
    },
    {
        name = "crow",
        model = "a_c_crow",
        reward = "bird_carcass"
    }
}