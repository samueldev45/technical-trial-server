local config = {
    power = 7
}

-- Creating the table with the spells area.
local areas = {
    [1] = {
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 1, 0, 0, 0, 0, 0},
        {1, 0, 0, 2, 0, 0, 1},
        {0, 1, 0, 0, 0, 0, 0},
        {0, 0, 1, 0, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0}
    },
    [2] = {
        {0, 0, 1, 0, 1, 0, 0},
        {0, 0, 0, 0, 0, 1, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 2, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0},
        {0, 1, 0, 0, 0, 1, 0},
        {0, 0, 0, 0, 0, 0, 0}
    },
    [3] = {
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 1, 0, 1, 0, 0},
        {0, 0, 0, 1, 0, 0, 0},
        {1, 0, 1, 2, 1, 0, 1},
        {0, 1, 0, 0, 0, 0, 0},
        {0, 0, 1, 0, 1, 0, 0},
        {0, 0, 0, 0, 0, 0, 0}
    },
    [4] = {
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 1, 0, 1, 0, 0},
        {0, 0, 0, 0, 1, 0, 0},
        {1, 0, 1, 2, 1, 0, 1},
        {0, 1, 0, 0, 0, 1, 0},
        {0, 0, 1, 0, 1, 0, 0},
        {0, 0, 0, 0, 0, 0, 0}
    },
    [5] = {
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 1, 0, 1, 0, 0},
        {0, 0, 1, 0, 0, 0, 0},
        {1, 0, 1, 2, 1, 0, 1},
        {0, 0, 0, 0, 0, 1, 0},
        {0, 1, 1, 0, 1, 0, 0},
        {0, 0, 0, 0, 0, 0, 0}
    },
    [6] = {
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 1, 0, 1, 0, 0},
        {0, 0, 0, 0, 0, 1, 0},
        {1, 0, 1, 2, 1, 0, 1},
        {0, 0, 0, 1, 0, 0, 0},
        {0, 1, 1, 0, 1, 0, 0},
        {0, 0, 0, 0, 0, 0, 0}
    },
    [7] = {
        {0, 0, 0, 0, 0, 0, 0},
        {0, 1, 1, 0, 1, 0, 0},
        {0, 0, 0, 1, 0, 0, 0},
        {1, 0, 1, 2, 1, 0, 1},
        {0, 0, 0, 0, 1, 0, 0},
        {0, 0, 1, 0, 1, 0, 0},
        {0, 0, 0, 0, 0, 0, 0}
    },
    [8] = {
        {0, 0, 1, 0, 0, 1, 0},
        {0, 0, 1, 0, 1, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {1, 0, 1, 2, 1, 0, 1},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 1, 0, 1, 1, 0},
        {0, 1, 1, 0, 0, 0, 0}
    }
}

local combats = {}

-- Scrolling through the table with the areas to create a Combat and add it to the "combats" table.
for k, area in pairs(areas) do
    function onGetFormulaValues(player, level, magicLevel)
        local min = (level / 5) + (magicLevel * 1.8) + config.power
        local max = (level / 5) + (magicLevel * 3) + (config.power * 2)
        return -min, -max
    end

    local combat = Combat()
    combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
    combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
    combat:setArea(createCombatArea(area))

    combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")
    combats[k] = combat
end

function onCastSpell(creature, variant)
    local player = Player(creature)

    for k, combat in pairs(combats) do
        addEvent(function(playerId)
            local player = Player(playerId)
            if player then
                combat:execute(player, variant)
            end
        end, k * 300, player:getId(), variant)
    end
    return true
end