rednet.open("left")
turllll = 'turtle_1'
cumputerId = 0
dravers = peripheral.wrap("extended_drawers:access_point_0")
chest = peripheral.wrap("minecraft:chest_1")
while true do
    local id, message = rednet.receive()
    local command, arg, parg = message:match("([^:]+):?([^:]*):?([^:]*)")
    if command == "CheckCraft" then
        qty = tonumber(arg) or 1
        detailsFirst = turtle.getItemDetail(1)
        first = ''
        if detailsFirst == nil then
        else
            first = detailsFirst['name']
        end
        turtle.craft(qty)
        second = ''
        details = turtle.getItemDetail(1)
        if details == nil then
        else
            second = details['name']
        end

        if first == second then
            rednet.send(cumputerId, "craft:false")
        else
            data = { name = turtle.getItemDetail(1)['name'], count = 0 }
            all = 0
            for i = 1, 16 do
                gg = turtle.getItemDetail(i)
                if gg == nil then
                else
                    all = all + gg['count']
                end
            end
            dravers.pullItem(turllll)
            data['count'] = all
            rednet.send(cumputerId,
                "craft:" .. textutils.serialiseJSON(data))
        end
    end
    if command == "goCraft" then
        qty = tonumber(arg) or 1
        if parg == 'chest' then
            turtle.craft(qty)
            for i = 1, 16, 1 do
                chest.pullItems(turllll,i)
            end
        elseif parg == 'main' then
            turtle.craft(qty)
            dravers.pullItem(turllll)
        end
        rednet.send(cumputerId, "goCraft")
    end
end
