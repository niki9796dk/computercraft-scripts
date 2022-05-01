--- @type PlayerDetector
pd = peripheral.find("playerDetector")

lastPlayerStates = {}

--- @return PlayerPos
function getLastPlayerState(playerName, currentPlayerState)
    return lastPlayerStates[playerName] or currentPlayerState
end

while true do
    for _, playerName in pairs(pd.getOnlinePlayers()) do
        currentPlayerState = pd.getPlayerPos(playerName)
        lastPlayerState = getLastPlayerState(playerName, currentPlayerState)

        if currentPlayerState.dimension ~= lastPlayerStates.dimension then
            print("[BigBrother] " .. playerName .. " welcome to [%s]!")
        end
    end

    sleep(1)
end

