--- @type PlayerDetector
pd = peripheral.find("playerDetector")
--- @type ChatBox
cb = peripheral.find("chatBox")

playerStateManager = {
    previousStates = {},
    currentStates = {},
    onDistrictEnterFunctions = {},
    onDistrictLeaveFunctions = {},
}

districts = {
    {
        --- The bois
        name = "District 1",
        area = {
            {x = -752, z = 591},
            {x = -553, z = 802}
        }
    },

    {
        --- I am the bait
        name = "District 2",
        area = {
            {x = -322, z = 718},
            {x = -250, z = 842}
        }
    },

    {
        --- Malthe
        name = "District 3",
        area = {
            {x = -174, z = 693},
            {x = -36, z = 536}
        }
    },

    {
        --- Mikkel Borg
        name = "District 4",
        area = {
            {x = 853, z = 0},
            {x = 1077, z = 297}
        }
    },

    {
        --- Molitany
        name = "District 5",
        area = {
            {x = 1120, z = -514},
            {x = 893, z = -712}
        }
    },
}

--- @return PlayerPos
function playerStateManager.getCurrentState(playerName)
    return playerStateManager.currentStates[playerName]
end

--- @return PlayerPos
function playerStateManager.getPreviousState(playerName)
    return playerStateManager.previousStates[playerName]
end

function playerStateManager.hasLeft(playerName)
    return playerStateManager.getCurrentState(playerName) == nil and playerStateManager.getPreviousState(playerName) ~= nil
end

function playerStateManager.isBack(playerName)
    return playerStateManager.getCurrentState(playerName) ~= nil and playerStateManager.getPreviousState(playerName) == nil
end

function isInBox(pos, box)
    boxMinX = math.min(box[1].x, box[2].x)
    boxMaxX = math.max(box[1].x, box[2].x)

    boxMinZ = math.min(box[1].z, box[2].z)
    boxMaxZ = math.max(box[1].z, box[2].z)

    local withinX = boxMinX <= pos.x and pos.x <= boxMaxX
    local withinZ = boxMinY <= pos.z and pos.z <= boxMaxY

    return withinX and withinZ
end

function playerStateManager.getDistrict(state)
    if state == nil then
        return nil
    end

    for _, district in pairs(districts) do
        if isInBox(state, district.area) then
            return district
        end
    end

    return nil
end

function playerStateManager.onDistrictEnter(func)
    table.insert(playerStateManager.onDistrictEnterFunctions, func)
end

function playerStateManager.onDistrictLeave(func)
    table.insert(playerStateManager.onDistrictLeaveFunctions, func)
end

function playerStateManager.updateStateMap()
    for _, playerName in pairs(pd.getOnlinePlayers()) do
        playerStateManager.previousStates[playerName] = playerStateManager.currentStates[playerName]
        playerStateManager.currentStates[playerName] = pd.getPlayerPos(playerName)

        previousDistrict = playerStateManager.getDistrict(playerStateManager.previousStates[playerName])
        currentDistrict = playerStateManager.getDistrict(playerStateManager.currentStates[playerName])

        if previousDistrict == nil and currentDistrict ~= nil then
            for _, func in pairs(playerStateManager.onDistrictEnterFunctions) do
                func(playerName, currentDistrict)
            end
        elseif previousDistrict ~= nil and currentDistrict == nil then
            for _, func in pairs(playerStateManager.onDistrictLeaveFunctions) do
                func(playerName, previousDistrict)
            end
        end
    end

end

function playerStateManager.forEachPlayer(func)
    for _, playerName in pairs(pd.getOnlinePlayers()) do
        func(playerName, playerStateManager.getCurrentState(playerName),  playerStateManager.getPreviousState(playerName))
    end
end

-- Initialize player state maps both current and previous states
playerStateManager.updateStateMap()
playerStateManager.updateStateMap()

playerStateManager.onDistrictEnter(function (playerName, district) cb.sendMessage("§2§l" .. playerName .. "§r has entered §n" .. district.name .. "§r!", 'BigBrother') end)
playerStateManager.onDistrictLeave(function (playerName, district) cb.sendMessage("§2§l" .. playerName .. "§r has left §n" .. district.name .. "§r!", 'BigBrother') end)

while true do
    playerStateManager.updateStateMap()

    ---@param currentState PlayerPos
    ---@param previousState PlayerPos
    playerStateManager.forEachPlayer(function (playerName, currentState, previousState)
        if playerStateManager.hasLeft(playerName) then
            cb.sendMessage("§2§l" .. playerName .. "§r has left the §nOverworld§r!", 'BigBrother')
        end

        if playerStateManager.isBack(playerName) then
            cb.sendMessage(playerName .. " has returned to the §nOverworld§r!", 'BigBrother')
        end
    end)

    sleep(1)
end

