---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Niki Zakariassen.
--- DateTime: 26-04-2022 22:34
---

function new (direction)
    --- @class table : EnhancedTerminal
    local self = {
        --- @type term
        parent = peripheral.wrap(direction),
    }

    --- Define public API
    --- @class EnhancedTerminal : term
    local public = {
        helloWorld = function ()
            self.write("Hello World!")
        end,

        clear = function ()
            self.setBackgroundColor(colors.black)
            self.parent.clear()
            self.setCursorPos(1,1)
        end,

        printProgressBar = function (width, progress, x, y)
            self.printBar(width, colors.lightGray, 1, 1)
            self.printBar(math.floor(progress * width), colors.red, x, y)
        end,

        printBar = function (width, color, x, y)
            --- Save current state
            local currentX, currentY = self.getCursorPos();
            local currentColor = self.getBackgroundColor(),

            --- Print bar at pos
            self.setCursorPos(x, y)
            self.setBackgroundColor(color)

            for i = 1, width do
                self.write(" ")
            end

            --- Revert state
            self.setBackgroundColor(currentColor)
            self.setCursorPos(currentX, currentY)
        end,

        printList = function (table)
            for i, v in pairs(table) do
                self.writeNewLine(v)
            end
        end,

        writeNewLine = function (text)
            local x, y = self.getCursorPos();
            self.write(text)
            self.setCursorPos(x, y + 1)
        end,
    }

    --- Make it possible to access public/private api from self
    setmetatable(self, {__index = public})

    --- Pass any unknown function calls to the underlying terminal
    return setmetatable(public, {__index = self.parent})
end

return {new = new}