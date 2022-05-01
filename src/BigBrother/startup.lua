--- @type PlayerDetector
pd = peripheral.find("playerDetector")

playerStateManager = {
    previousStates = {},
    currentStates = {},
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
    return playerStateManager.getCurrentState(playerName) == nil and playerStateManager.getPreviousState(playerStateManager) ~= nil
end

function playerStateManager.isBack(playerName)
    return playerStateManager.getCurrentState(playerName) ~= nil and playerStateManager.getPreviousState(playerStateManager) == nil
end

function playerStateManager.updateStateMap()
    for _, playerName in pairs(pd.getOnlinePlayers()) do
        playerStateManager.previousStates[playerName] = playerStateManager.currentStates[playerName]
        playerStateManager.currentStates[playerName] = pd.getPlayerPos(playerName)
    end
end

function playerStateManager.forEachPlayer(func)
    for _, playerName in pairs(pd.getOnlinePlayers()) do
        func(playerName, playerStateManager.getCurrentState(playerName),  playerStateManager.getPreviousState(playerName))
    end
end

while true do
    playerStateManager.updateStateMap()

    ---@param currentState PlayerPos
    ---@param previousState PlayerPos
    playerStateManager.forEachPlayer(function (playerName, currentState, previousState)
        if playerStateManager.hasLeft(playerName) then
            print("[BigBrother] " .. playerName .. " has left the Overworld!")
        end

        if playerStateManager.isBack(playerName) then
            print("[BigBrother] " .. playerName .. " has returned to the Overworld!")
        end
    end)

    sleep(1)
end

