--- @class termMock : term
termMock = {
    buffer = {},
    x = 1,
    y = 1,
}

function termMock.write(text)
    local currentLine = termMock.buffer[termMock.y] or ""
    local currentLineLen = string.len(currentLine)
    local result = ""

    -- If the current line is not as long, then left pad it
    if currentLineLen < (termMock.x - 1) then
        result = currentLine .. string.rep(" ", termMock.x - currentLineLen) .. text

    -- Otherwise inject the string at x, and potentially overwrite any existing text
    else
        local leftOffset = string.sub(currentLine, 0, termMock.x)
        local rightOffset = string.sub(currentLine, termMock.x + string.len(text))

        result = leftOffset .. text .. rightOffset
    end

    termMock.x = string.len(result) + 1

    termMock.buffer[termMock.y] = result
end

function termMock.getCursorPos()
    return termMock.x, termMock.y
end
function termMock.setCursorPos(x, y)
    termMock.x = x
    termMock.y = y
end

function termMock.blit(text, textColors, backgroundColors) end
function termMock.clear()
    termMock.buffer = {}
end
function termMock.clearLine()
    termMock.remove(termMock.buffer, termMock.y)
    termMock.insert(termMock.buffer, termMock.y, "")
end
function termMock.setCursorBlink(bool) end
function termMock.isColor() end
function termMock.getSize() end
function termMock.scroll(n) end
function termMock.redirect(target) end
function termMock.current() end
function termMock.native() end
function termMock.setTextColor(color) end
function termMock.getTextColor() end
function termMock.setBackgroundColor(color) end
function termMock.getBackgroundColor() end
function termMock.dump()
    local maxLine = 1;

    for lineNumber, _ in pairs(termMock.buffer) do
        if lineNumber > maxLine then
            maxLine = lineNumber
        end
    end

    for i = 1, maxLine do
        print(termMock.buffer[i] or "")
    end
end
