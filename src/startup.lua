require("mocks/init");

EnhancedTerminal = require("api/EnhancedTerminal");

et = EnhancedTerminal.new("right");

et.printList({
    {name = "minecraft:dirt", count = 25, stock = 354},
    {name = "minecraft:glass", count = 100, stock = 100},
    {name = "'mekanism:oak_planks", count = 1234, stock = 8942},
    {name = "'mekanism:oak_planks", count = 1234},
}, {"name", "count", "stock", "abekat"}, true)

et.dump()