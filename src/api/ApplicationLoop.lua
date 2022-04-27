ApplicationLoop = {
    terminate = false,
    listeners = {
        timers = {}
    },
}

function ApplicationLoop.run(main)
    main()

    -- Application loop
    while not terminate do
        -- Keep pulling events
        local event = {os.pullEvent()}

        if event[1] == "timer" then
            local listener = ApplicationLoop.findTimerListener(event[2])

            listener.func()
        end
    end
end

function ApplicationLoop.findTimerListener(timer)
    for key, listener in pairs(ApplicationLoop.listeners.timers) do
        if listener.timer == timer then
            return key, listener
        end
    end

    assert(false, "Could not locate timer listener")
end

function ApplicationLoop.timeout(time, func)
    table.insert(ApplicationLoop.listeners.timers, {
        timer = os.startTimer(time),
        func = func,
    })
end
