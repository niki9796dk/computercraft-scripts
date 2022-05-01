--- @type PlayerDetector
pd = peripheral.find("playerDetector")

playerStateManager = {
    previousStates = {},
    currentStates = {},
}

--- @return PlayerPos
function playerStateManager.getCurrentState(playerName)
    return playerStateManager.currentStates[playerName] or error("No such player: " .. playerName)
end

--- @return PlayerPos
function playerStateManager.getPreviousState(playerName)
    return playerStateManager.previousStates[playerName] or error("No such player: " .. playerName)
end

function playerStateManager.hasChangedDimension(playerName)
    return playerStateManager.getCurrentState(playerName).dimension ~= playerStateManager.getPreviousState(playerName).dimension
end

function playerStateManager.updateStateMap()
    for _, playerName in pairs(pd.getOnlinePlayers()) do
        liveState = pd.getPlayerPos(playerName)

        playerStateManager.previousStates[playerName] = playerStateManager.currentStates[playerName] or liveState
        playerStateManager.currentStates = liveState
    end
end

function playerStateManager.forEachPlayer(func)
    for _, playerName in pairs(pd.getOnlinePlayers()) do
        func(playerName, playerStateManager.currentStates[playerName], playerStateManager.previousStates[playerName])
    end
end

while true do
    playerStateManager.updateStateMaps()

    ---@param currentState PlayerPos
    ---@param previousState PlayerPos
    playerStateManager.forEachPlayer(function (playerName, currentState, previousState)
        if playerStateManager.hasChangedDimension(playerName) then
            print("[BigBrother] " .. playerName .. " welcome to [" .. currentState.dimension .. "]!")
        end
    end)

    sleep(1)
end

