require("server")

monitor = peripheral.wrap("monitor_0")
draverss = peripheral.wrap("extended_drawers:access_point_0")
chest = peripheral.wrap("minecraft:chest_1")
turtle = peripheral.wrap("turtle_1")

barnum = 0
tur = { 1, 2, 3, 5, 6, 7, 9, 10, 11 }
turtleId = 2

local function gripCraft2(craft)
    local filtered = {}
    for _, item in pairs(craft) do
        if item ~= "" then
            local found = false
            for _, f in ipairs(filtered) do
                if f.name == item then
                    f.count = f.count + 1
                    found = true
                    break
                end
            end
            if not found then
                table.insert(filtered, { name = item, count = 1 })
            end
        end
    end
    return filtered
end

function splitCraftBatches(craftLadder)
    local newLadder = {}
    for k, v in pairs(craftLadder) do
        newLadder[k] = {}
        for _, item in ipairs(v) do
            local fullStacks = math.floor(item.count / 64)
            local remainder = item.count % 64

            for i = 1, fullStacks do
                table.insert(newLadder[k], { name = item.name, count = 64 })
            end
            if remainder > 0 then
                table.insert(newLadder[k], { name = item.name, count = remainder })
            end
        end
    end
    return newLadder
end

function compressCraftLadder(craftLadder)
    local maxStep = 0
    for k in pairs(craftLadder) do
        local num = tonumber(k:match("on(%d+)"))
        if num and num > maxStep then
            maxStep = num
        end
    end

    for step = maxStep, 2, -1 do
        local current = craftLadder["on" .. step]
        for prev = step - 1, 1, -1 do
            local prevList = craftLadder["on" .. prev]
            for i = #prevList, 1, -1 do
                local prevItem = prevList[i]
                for _, curItem in ipairs(current) do
                    if curItem.name == prevItem.name then
                        curItem.count = curItem.count + prevItem.count
                        table.remove(prevList, i)
                        break
                    end
                end
            end
        end
    end

    return craftLadder
end

function bar(value)
    monitor.setBackgroundColor(colors.blue)
    if barnum <= 30 then
        for i = 1, value do
            monitor.write(' ')
        end
    end
    monitor.setBackgroundColor(colors.black)
    barnum = barnum + value
end

function craftAll(craftladderr)
    barnum = 0
    rednet.open("right")
    allCrafts = getData()
    dravItems = draverss.items()

    monitor.setBackgroundColor(colors.black)
    monitor.setCursorPos(9, 15)
    monitor.write('[                              ]')
    monitor.setCursorPos(10, 15)
    filtered = compressCraftLadder(craftladderr)
    filtered = splitCraftBatches(filtered)

    num = 0
    num2 = 0
    missingitemsFor={}
    for key, value in pairs(filtered) do
        for _, value1 in pairs(value) do
            crrr = true
            for _, crvalue in pairs(allCrafts) do
                if crrr then
                    if value1.name == crvalue.name then
                        crrr = false

                        for _, ff in pairs(gripCraft2(crvalue.craft)) do
                            goof = true
                            dravItems = draverss.items()
                            goofcount = 0
                            for _, draritremvalue in pairs(dravItems) do
                                if draritremvalue.name == ff.name then
                                    goofcount = draritremvalue.count
                                    if draritremvalue.count >= ff.count * value1.count then
                                        goof = false
                                        draverss.pushItem('minecraft:chest_1', ff.name, ff.count * value1.count)
                                    end
                                    if goof then
                                        table.insert(missingitemsFor, {name=ff.name, count=ff.count * value1.count - goofcount})
                                    end
                                end
                            end
                        end
                    end
                end
            end
            num = num + 1
        end
        num2 = num2 + 1
    end
    if #missingitemsFor ~= 0 then
        dravers.pullItem("minecraft:chest_1")
        return missingitemsFor
    end
    

    items = chest.list()
    gripbar = math.ceil(30 / num)

    for i = num2, 1, -1 do
        for _, value in pairs(filtered['on' .. i]) do
            local crafttttt = true
            local countCraf = 0
            for _, craftvalue in pairs(allCrafts) do
                if crafttttt and craftvalue.name == value.name then
                    for crkey, crvalue in pairs(craftvalue.craft) do
                        if crvalue ~= '' then
                            crafttttt = false
                            countCraf = value.count
                            for slot, item in pairs(items) do
                                if item.name == crvalue then
                                    items = chest.list()
                                    chest.pushItems('turtle_1', slot, value.count, tur[crkey])
                                end
                            end
                        end
                    end
                end
            end
            if i == 1 then
                rednet.send(turtleId, "goCraft:" .. countCraf .. ":main")
            else
                rednet.send(turtleId, "goCraft:" .. countCraf .. ":chest")
            end
            bar(gripbar)
            local rtIs = true
            while rtIs do
                local id, message = rednet.receive()
                local command = message:match("([^:]+)")
                if command == 'goCraft' then
                    rtIs = false
                end
            end
        end
    end
    dravers.pullItem("minecraft:chest_1")
end
