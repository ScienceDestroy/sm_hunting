local Translations = {
    error = {
        already_hunting = "Вы уже на охоте!",
        not_hunting = "Вы не на охоте!",
        too_far = "Вы слишком далеко от зоны охоты!",
        no_weapon_license = "Для охоты необходима лицензия на оружие!",
    },
    success = {
        hunting_started = "Охота началась! Будьте осторожны!",
        hunting_ended = "Охота завершена!",
        animal_harvested = "Добыча успешно собрана!",
    },
    info = {
        press_to_start = "Нажмите ~g~E~w~ чтобы начать охоту",
        press_to_end = "Нажмите ~g~E~w~ чтобы завершить охоту",
        press_to_harvest = "Нажмите ~g~E~w~ чтобы собрать добычу",
        harvesting = "Разделка добычи...",
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})