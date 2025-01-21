-- Добавьте эти предметы в ваш shared/items.lua файл QB-Core
QBCore.Shared.Items = {
    -- Существующие предметы ...
    
    ["meat"] = {
        name = "meat",
        label = "Мясо",
        weight = 500,
        type = "item",
        image = "meat.png",
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
        description = "Свежее мясо"
    },
    ["leather"] = {
        name = "leather",
        label = "Кожа",
        weight = 500,
        type = "item",
        image = "leather.png",
        unique = false,
        useable = false,
        shouldClose = true,
        combinable = nil,
        description = "Кожа животного"
    },
    ["feathers"] = {
        name = "feathers",
        label = "Перья",
        weight = 100,
        type = "item",
        image = "feathers.png",
        unique = false,
        useable = false,
        shouldClose = true,
        combinable = nil,
        description = "Птичьи перья"
    }
}