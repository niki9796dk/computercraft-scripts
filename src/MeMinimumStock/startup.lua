EnhancedTerminal = require("api/EnhanceedTerminal")

me = peripheral.wrap("left")
monitor = EnhancedTerminal.new("top")

function load(name)
    local file = fs.open(name, "r")
    local data = file.readAll()
    file.close()

    return textutils.unserialize(data)
end

function printScreen()
    monitor.clear()
    monitor.printList(items, true)
end

-- get items in chest
items = load("stock")

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
        items[key] = value

        if (count < value.count) then
            -- if not crafting, craft
            isCrafting = me.isItemCrafting({ name = value.name })

            if (isCrafting == false) then
                local toCraft = value.count - count
                print("Crafting " .. toCraft .. " " .. value.name)
                me.craftItem({ name = value.name, count = toCraft })
            end
        end
    end

    -- sleep for 1 second
    os.sleep(1)
end