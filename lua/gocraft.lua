require("server")

monitor = peripheral.wrap("monitor_0")
draverss = peripheral.wrap("extended_drawers:access_point_0")
chest = peripheral.wrap("minecraft:chest_1")
turtle = peripheral.wrap("turtle_1")

barnum = 0
tur = { 1, 2, 3, 5, 6, 7, 9, 10, 11 }
turtleId = 1

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

    -- print(textutils.serialiseJSON(filtered))

    num = 0
    num2 = 0
    for key, value in pairs(filtered) do
        for _, value1 in pairs(value) do
            
            crrr = true
            for _, crvalue in pairs(allCrafts) do
                if crrr then
                    if value1.name == crvalue.name then
                        print(crvalue.name)
                        crrr=false
                        for _, ff in pairs(gripCraft2(crvalue.craft)) do
                            print('ff.name')
                            draverss.pushItem('minecraft:chest_1', ff.name , ff.count*value1.count)
                        end
                    end
                end
            end
            num = num + 1
        end
        num2 = num2 + 1
    end

    items = chest.list()
    gripbar = math.ceil(30/num)
    -- print("g2gh")
    for i = num2, 1, -1 do
        -- sleep(1)
        -- print("gg", textutils.serialiseJSON(filtered['on' .. i]))
        for _, value in pairs(filtered['on' .. i]) do
            local crafttttt = true
            local countCraf = 0
            for _, craftvalue in pairs(allCrafts) do
                if crafttttt and craftvalue.name == value.name then
                    -- print("g2g", craftvalue.name)
                    for crkey, crvalue in pairs(craftvalue.craft) do
                        if crvalue ~= '' then
                            crafttttt = false
                            countCraf = value.count
                            for slot, item in pairs(items) do
                                if item.name == crvalue then
                                    -- sleep(0.2)
                                    items = chest.list()
                                    chest.pushItems('turtle_1', slot, value.count, tur[crkey])
                                end
                            end
                        end
                    end
                end
            end
            -- print(countCraf)
            -- sleep(1)
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
    -- print(111111111)
    dravers.pullItem("minecraft:chest_1")
end
