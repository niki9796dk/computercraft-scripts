ApplicationLoop = {
    terminated = false,
    listeners = {
        timers = {}
    },
}

function ApplicationLoop.run(main)
    main()

    -- Application loop
    while not ApplicationLoop.terminated do
        -- Keep pulling events
        local event = {os.pullEvent()}

        if event[1] == "timer" then
            local key, listener = ApplicationLoop.findTimerListener(event)

            if (key ~= nil and listener ~= nil) then
                listener.func()
                table.remove(ApplicationLoop.listeners.timers, key)

                if listener.endless then
                    ApplicationLoop.refreshTimer(listener)
                end
            end
        end
    end
end

function ApplicationLoop.findTimerListener(event)
    for key, listener in pairs(ApplicationLoop.listeners.timers) do
        if listener.timer == event[2] then
            return key, listener
        end
    end

    return nil, nil
end

function ApplicationLoop.timeout(time, func)
    table.insert(ApplicationLoop.listeners.timers, {
        timer = os.startTimer(time),
        time = time,
        func = func,
        endless = false
    })
end

function ApplicationLoop.interval(time, func)
    table.insert(ApplicationLoop.listeners.timers, {
        timer = os.startTimer(time),
        time = time,
        func = func,
        endless = true
    })
end

function ApplicationLoop.refreshTimer(listener)
    ApplicationLoop.timeout(listener.time, listener.func)
end

function ApplicationLoop.terminate()
    ApplicationLoop.terminated = true
end
