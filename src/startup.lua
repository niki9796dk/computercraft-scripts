--require("mocks/init");

EnhancedTerminal = require("api/EnhancedTerminal");

et = EnhancedTerminal.new("right");

et.printList({
    {"Dirt", 25},
    {"Glass", 100},
    {"Oak Planks", 1234},
})

et.setCursorPos(1, 10)
et.write("55555")

et.setCursorPos(3, 10)
et.write("22")

--et.dump()