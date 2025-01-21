local Translations = {
    error = {
        already_hunting = "You are already hunting!",
        not_hunting = "You are not hunting!",
        too_far = "You are too far from the hunting zone!",
        no_weapon_license = "You need a weapon license to hunt!",
    },
    success = {
        hunting_started = "Hunting started! Be careful!",
        hunting_ended = "Hunting ended!",
        animal_harvested = "Animal harvested successfully!",
    },
    info = {
        press_to_start = "Press ~g~E~w~ to start hunting",
        press_to_end = "Press ~g~E~w~ to end hunting",
        press_to_harvest = "Press ~g~E~w~ to harvest animal",
        harvesting = "Harvesting animal...",
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})