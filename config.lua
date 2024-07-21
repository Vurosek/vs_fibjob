Config = {}
-- Model Pojazdu Oraz Jego Opisy {title - Tytuł w Menu} {description - Opis W menu} {icon - ikona (https://fontawesome.com/icons)}{model - Spawn Name Pojazdu }
Config.Vehicles = {
    {title = '**Comet**', description = 'Szybki sportowy pojazd', icon = 'fas fa-car', disabled = false, model = 'comet2'},
    {title = '**Elegy**', description = 'Elegancki samochód sportowy', icon = 'fas fa-car', disabled = false, model = 'elegy2'},
    {title = '**Sandking**', description = 'Potężny terenowy pojazd', icon = 'fas fa-truck-monster', disabled = false, model = 'sandking'},
    {title = '**Rebel**', description = 'Solidny terenowy pojazd', icon = 'fas fa-car', disabled = false, model = 'rebel'}
}
Config.SpawnPoint = {
    coords = vector3(57.83, -742.03, 44.12),
    heading = 358.6
}

Config.Outfits = {
    {
        label = 'Strój 1',
        components = {
            shirt = {componentId = 11, drawableId = 15, textureId = 0},
            pants = {componentId = 4, drawableId = 15, textureId = 0},
            shoes = {componentId = 6, drawableId = 15, textureId = 0},
            arms = {componentId = 3, drawableId = 15, textureId = 0},
            hat = {componentId = 0, drawableId = -1, textureId = 0},
            glasses = {componentId = 1, drawableId = -1, textureId = 0},
            accessories = {componentId = 7, drawableId = -1, textureId = 0}
        }
    },
    {
        label = 'Strój 2',
        components = {
            shirt = {componentId = 11, drawableId = 14, textureId = 0},
            pants = {componentId = 4, drawableId = 14, textureId = 0},
            shoes = {componentId = 6, drawableId = 14, textureId = 0},
            arms = {componentId = 3, drawableId = 14, textureId = 0},
            hat = {componentId = 0, drawableId = -1, textureId = 0},
            glasses = {componentId = 1, drawableId = -1, textureId = 0},
            accessories = {componentId = 7, drawableId = -1, textureId = 0}
        }
    },
    {
        label = 'Strój 3',
        components = {
            shirt = {componentId = 11, drawableId = 13, textureId = 0},
            pants = {componentId = 4, drawableId = 13, textureId = 0},
            shoes = {componentId = 6, drawableId = 13, textureId = 0},
            arms = {componentId = 3, drawableId = 13, textureId = 0},
            hat = {componentId = 0, drawableId = -1, textureId = 0},
            glasses = {componentId = 1, drawableId = -1, textureId = 0},
            accessories = {componentId = 7, drawableId = -1, textureId = 0}
        }
    }
}


Config.Przebieralnia = 126.69, -760.49, 45.76
Config.Przeb = {
    {
        coords = vec3(126.69, -760.49, 45.76),
        radius = 1.5,
        options = {
            {
                name = 'Przebieralnia',
                icon = 'fa-solid fa-dove',
                label = 'Otwórz Przebieralnie',
                event = 'vs_menuciuchy',
                groups = {["fib"] = 0,},
                distance = 2,
            },
            {
                name = 'Przebieralniapowrót',
                icon = 'fa-solid fa-dove',
                label = 'Powrót do poprzedniego stroju',
                event = 'vs_menuciuchypowrot',
                groups = {["fib"] = 0,},
                distance = 2,
            },

        }
    }

}

Config.GarazX = 60.89
Config.GarazY = -743.69
Config.GarazZ = 44.22
Config.GarazR = 1.5

Config.Peds = {
    {model = "a_m_m_og_boss_01", coords = vector3(61.60, -744.16, 43.22), heading = 73.50, scenario = "WORLD_HUMAN_DRUG_DEALER_HARD"}, -- weed sprzedaz
}

Config.SzafkaPrivLabel = 'Szafka Prywatna'
Config.SzafkaPrivSlots = 25
Config.SzafkaPrivWeight = 5000

Config.Szafki = {
    {
        coords = vec3(128.18, -766.88, 45.76),  -- 
        radius = 1.5,
        options = {
            {
                name = 'szafkaprywatna1',
                icon = 'fas fa-lock',
                label = 'Prywatna Szafka',
                event = 'vs_fibjob:storagepriv',
                groups = {["fib"] = 0,},
                distance = 2,
            },
            {
                name = 'szafkafirmowa1',
                icon = 'fas fa-briefcase',
                label = 'Firmowa Szafka',
                event = 'vs_fibjob:storagecompany',
                groups = {["fib"] = 0,},
                distance = 2,
            }
        }
    }
}

Config.Kasa = 500 -- Ustaw wynagrodzenie za misje