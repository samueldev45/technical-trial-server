
local function canMoveCreature(tile, ignoreCreatures)
    ignoreCreatures = ignoreCreatures or false

    if not tile then
        return false
    end

    if not ignoreCreatures and tile:getTopCreature() then
        return false
    end

    if tile:hasFlag(TILESTATE_BLOCKSOLID) or tile:hasFlag(TILESTATE_PROTECTIONZONE) or tile:hasFlag(TILESTATE_TELEPORT) then
        return false
    end

    return true
end

local function movePlayer(playerId, direction)
    local player = Player(playerId)

    if not player then
        return
    end

    local position = player:getPosition()
    position:getNextPosition(direction)

    local tile = Tile(position)
    if not canMoveCreature(tile) then
        player:setShader("Default")
        return
    end

    player:teleportTo(position)
end

function onCastSpell(creature, variant)
    local sqms = 5
    local player = Player(creature)
    local direction = player:getDirection()
    local delay = 50
    
    player:setShader("Outfit - Red Outline")

    for i = 1, sqms, 1 do
        addEvent(movePlayer, delay * i, player:getId(), direction)
    end

    addEvent(function(playerId)
        local player = Player(playerId)
        if player then
            player:setShader("Default")
        end
    end, delay * sqms, player:getId())
    return false
end  