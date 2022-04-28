EnhancedTerminal = require("api/EnhancedTerminal")
require("api/Serializer")

me = peripheral.wrap("left")
monitor = EnhancedTerminal.new("top")

function printScreen()
    monitor.clear()
    monitor.printList(items, {"name", "count", "stock", "status"}, true)
end

-- get items in chest
items = Serializer.load("stock")

-- while true
while true do
    printScreen()

    -- go through each item check if stock is met or is crafting, otherwise craft
    for key, value in pairs(items) do
        local item = me.getItem({ name = value.name })

        -- if nil then count is 0
        local count = 0

        if (item ~= nil) then
            count = item.amount
        end

        value.stock = count

        if (count < value.count) then
            -- if not crafting, craft
            isCrafting = me.isItemCrafting({ name = value.name })
            value.status = 'CRAFTING'

            if (isCrafting == false) then
                local toCraft = value.count - count
                print("Crafting " .. toCraft .. " " .. value.name)
                me.craftItem({ name = value.name, count = toCraft })
            end
        else
            value.status = 'OK'
        end

        items[key] = value
    end

    coroutine.yield()
end