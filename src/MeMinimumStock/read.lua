require("api/Serializer")
me = peripheral.wrap("left")
chest = peripheral.wrap("right")

-- get items in chest
local items = chest.list()

-- create function asking for number
local function ask(prompt)
    io.write(prompt)
    amount = tonumber(io.read())

    if (amount == nil) then
        error("Invalid number")
        ask(prompt)
    end

    return amount
end

-- loop through items in chest
for key, value in pairs(items) do
    print(key, " -- ", value.name)
    value.count = ask("Enter amount to keep in stock: ")
end

-- get items in file
local existing_items = Serializer.load("stock")

function merge(item, items)
    for key, value in pairs(items) do
        if (value.name == item.name) then
            value.count = item.count

            return
        end
    end

    table.insert(existing_items, item)
end

-- merge existing items with new items
for key, value in pairs(items) do
    merge(value, existing_items)
end

-- remove items that are not requested
for key, value in pairs(existing_items) do
    if (value.count == 0) then
        table.remove(existing_items, key)
    end
end

Serializer.save(existing_items, "stock")