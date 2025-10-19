require("server")

trtll = 'turtle_1'
chestCraftTable = peripheral.wrap("minecraft:crafting_table_1")

turtleIdd = 1
craft = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }
tur = { 1, 2, 3, 5, 6, 7, 9, 10, 11 }
function checkChestCraft()
    craftmaybe = {}
    for key, value in pairs(craft) do
        if chestCraftTable.getItemDetail(value) == nil then
            table.insert(craftmaybe, '')
        else
            table.insert(craftmaybe, chestCraftTable.getItemDetail(value)['name'])
            chestCraftTable.pushItems(trtll, value, 1, tur[key])
        end
    end
    rednet.open("right")
    rednet.send(turtleIdd, "CheckCraft:1:0")
    is = true
    crufterDetails = {}
    retu = false
    while is do
        local id, message = rednet.receive()
        local command, arg = message:match("([^:]+):?(.*)")
        if command == "craft" then
            if arg == 'false' then
                for key, value in pairs(tur) do
                    chestCraftTable.pullItems(trtll, value, 1, craft[key])
                end
            else
                crufterDetails = textutils.unserialiseJSON(arg)
                retu = true
            end
            is = false
        end
    end

    jsondata = getData()
    if jsondata then
        for _, item in pairs(jsondata) do
            if item.name == crufterDetails['name'] then
                if textutils.serialiseJSON(item.craft) == textutils.serialiseJSON(craftmaybe) then
                    return 'ok'
                end
            end
        end
    end
    crufterDetails['craft'] = craftmaybe
    if retu then
        wrigthData(crufterDetails)
    end
    return retu
end
