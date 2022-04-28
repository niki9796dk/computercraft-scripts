EnhancedTerminal = require("api/EnhancedTerminal");
require("api/ApplicationLoop");

ApplicationLoop.run(function ()
    -- Wrap the application in coroutine
    local MeMinimumStock = coroutine.wrap(function () require("MeMinimumStock/startup")  end)
    local terminal = EnhancedTerminal.new("top")

    ApplicationLoop.interval(1, MeMinimumStock)

    ---@param event MonitorTouchEvent
    ApplicationLoop.on("touch_event", function (event)
        terminal.setCursorPos(event.x, event.y)
        terminal.write("#")
    end)
end)