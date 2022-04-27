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

        printList = function (list, headers, trimNamespaces)
            trimNamespaces = trimNamespaces or false
            table.insert(headers, 1, "#")
            list = self.prepareTable(list, trimNamespaces)
            local columnWidths = self.getColumnWidths(list)

            local totalLineWidth = -1

            for _, width in pairs(columnWidths) do
                totalLineWidth = totalLineWidth + width + 3
            end

            self.printTableRow(headers, headers, columnWidths, totalLineWidth)

            for _, row in pairs(list) do
                self.printTableRow(headers, row, columnWidths, totalLineWidth)
            end

            self.printTableRowSeparator(totalLineWidth)
        end,

        printTableRowSeparator = function (totalLineWidth)
            self.writeLn("|" .. string.rep("-", totalLineWidth) .. "|")
        end,

        printTableRow = function (headers, tableRow, columnWidths, totalLineWidth)
            local currentX, _ = self.getCursorPos()
            local notFirst = false

            self.printTableRowSeparator(totalLineWidth)

            for key, header in pairs(headers) do
                value = tableRow[header] or tableRow[key] or nil

                if notFirst then
                    self.write(" | ")
                else
                    self.write("| ")
                    notFirst = true
                end

                local leftAlign = type(value) ~= "number"

                self.write(string.format("%" .. (leftAlign and "-" or "") .. columnWidths[header] .. "s", value))
            end

            self.write(" |")

            -- Jump to next line
            local _, currentY = self.getCursorPos()
            self.setCursorPos(currentX, currentY + 1)
        end,

        prepareTable = function (table, trimNamespaces)
            local resultTable = {}

            for tableKey, row in pairs(table) do
                local resultRow = {}

                row["#"] = tableKey;

                for rowKey, value in pairs(row) do
                    -- Only prepare string value
                    if type(value) ~= "string" then
                        resultRow[rowKey] = value
                    else
                        if trimNamespaces then
                            value = self.stripNamespace(value)
                        end

                        resultRow[rowKey] = self.snakeCaseToHumanCase(value)
                    end
                end

                resultTable[tableKey] = resultRow
            end

            return resultTable
        end,

        stripNamespace = function (text)
            local nameSpacePos = string.find(text, ':')

            if (nameSpacePos == nil) then
                return text
            end

            return string.sub(text, nameSpacePos + 1)
        end,

        snakeCaseToHumanCase = function (text)
            local splits = self.stringExplode(text, '_')
            local ucfirst = function (value) return string.upper(string.sub(value, 1, 1)) .. string.sub(value, 2) end

            splits = self.tableMap(splits, ucfirst)

            return self.stringImplode(splits, ' ')
        end,

        stringExplode = function (inputString, separator)
            if separator == nil then
                separator = "%s"
            end

            local t={}

            for str in string.gmatch(inputString, "([^".. separator .."]+)") do
                table.insert(t, str)
            end

            return t
        end,

        tableMap = function (values, map)
            local result = {}

            for key, value in pairs(values) do
                result[key] = map(value, key)
            end

            return result
        end,

        stringImplode = function (strings, glue)
            local result = ""

            for _, string in pairs(strings) do
                result = result .. glue .. string
            end

            return string.sub(result, string.len(glue) + 1)
        end,

        getColumnWidths = function (table)
            local widths = {}

            for _, row in pairs(table) do
                for key, value in pairs(row) do
                    local width = widths[key] or 0
                    local strLen = string.len(value)
                    local headerLen = string.len(key)

                    if (strLen > width) or (headerLen > width) then
                        widths[key] = (strLen > headerLen) and strLen or headerLen
                    end
                end
            end

            return widths
        end,

        writeLn = function (text)
            local currentX, currentY = self.getCursorPos()

            self.write(text)
            self.setCursorPos(currentX, currentY + 1)
        end,
    }

    --- Make it possible to access public/private api from self
    setmetatable(self, {__index = public})

    --- Pass any unknown function calls to the underlying terminal
    return setmetatable(public, {__index = self.parent})
end

return {new = new}