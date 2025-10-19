require("analysate")
require("main")
require("prepair")

mon1 = 'monitor_0'
mon2 = 'monitor_1'

peripheral.find("modem", rednet.open)
monitor = peripheral.wrap(mon1)
klava = peripheral.wrap(mon2)
klava.setBackgroundColor(colors.blue)
klava.clear()
klava.setTextScale(2)
klava.setCursorPos(3, 3)
klava.write('Daniell')
klava.setCursorPos(3, 4)
klava.write('AutoCraft')
monitor.setBackgroundColor(colors.black)
monitor.setBackgroundColor(colors.blue)
monitor.clear()
monitor.setTextScale(1)
monitor.setBackgroundColor(colors.blue)
monitor.setCursorPos(17, 10)
monitor.write('Daniell AutoCraft')
icoSl = false
for i = 1,4 do
    monitor.setCursorPos(34, 10)
    klava.setCursorPos(12, 4)
    if icoSl then
        monitor.write('|')
        klava.write('|')
        icoSl=false
    else
        monitor.write(' ')
        klava.write(' ')
        icoSl=true
    end
  sleep(0.5)
end
sleep(0.5)
monitor.setBackgroundColor(colors.black)
monitor.clear()

klava.setBackgroundColor(colors.black)
klava.clear()
listData = {}
page = 1
pagesof = 0
nextBackPadding = 0
CurrentButtonClick = ''
search = ''

craftinput = true
craftCount = '1'
craftSettings = {}

buttons = {
    Add_Craft = { 42, 19, 9 },
    Mods = { 1, 1, 4 },
    All = { 6, 1, 3 },
    Search = { 10, 1, 6 }
}


ico = {
    AutoCraft_Made_by_Daniell = { 12, 10, 25, 'blue' }
}

btnRoll = {
    Next = { 21 + nextBackPadding, 19, 4, 'green' },
    Back = { 10, 19, 4, 'red' },
}

btnPrepair = {
    Craft = { 17, 9, 5, 'green' },
    Delete = { 29, 9, 6, 'red' }
}


function drawButtons(rtbut)
    for key, value in pairs(rtbut) do
        if value[4] then
            monitor.setBackgroundColor(colors[value[4]])
        end
        monitor.setCursorPos(value[1], value[2])
        monitor.write(key)
        monitor.setBackgroundColor(colors.black)
    end
end

drawButtons(buttons)
drawButtons(ico)

function klavaActivate()
    klava.clear()
    klava.setBackgroundColor(colors.black)
    textKlava = { 'qwertyuiop', 'asdfghjkl', 'zxcvbnm' }
    for key, value in ipairs(textKlava) do
        if key == 3 then
            klava.setCursorPos(4, key + 2)
        else
            klava.setCursorPos(3, key + 2)
        end

        klava.write(value)
    end
    klava.setBackgroundColor(colors.blue)
end

function settings(settingsData)
    monitor.clear()
    drawButtons(buttons)
    drawButtons(btnPrepair)
    dTrick, darg = settingsData.name:match("([^:]+):?(.*)")

    -- ex=50-#settingsData.name
    monitor.setCursorPos(math.floor((50 - #darg - 7) / 2), 2)
    monitor.setBackgroundColor(colors.blue)
    monitor.write('CRAFT: ' .. darg)
    monitor.setBackgroundColor(colors.black)
    monitor.setCursorPos(21, 4)
    monitor.write('AMOUNT: ' .. craftCount)
    monitor.setBackgroundColor(colors.blue)
    monitor.setCursorPos(23, 5)
    monitor.write('1 2 3')
    monitor.setCursorPos(23, 6)
    monitor.write('4 5 6')
    monitor.setCursorPos(23, 7)
    monitor.write('7 8 9')
    monitor.setCursorPos(25, 8)
    monitor.write('0')
    monitor.setBackgroundColor(colors.black)
end

function dravList(list, mod)
    num = 1
    if list['on' .. page] then
        for _, item in pairs(list['on' .. page]) do
            monitor.setCursorPos(2, 2 + num)
            if mod then
                dTrick, darg = item.name:match("([^:]+):?(.*)")
                monitor.write(dTrick)
            else
                monitor.write(item['name'])
            end
            num = num + 1
        end
    end
end

function pageRoll()
    monitor.setCursorPos(16, 19)
    p = page .. '/' .. pagesof
    nextBackPadding = #p - 3
    monitor.write(p)
end

function colourChange(clbut, collour)
    monitor.setBackgroundColor(colors[collour])
    monitor.setCursorPos(buttons[clbut][1], buttons[clbut][2])
    monitor.write(clbut)
    monitor.setBackgroundColor(colors.black)
end

function Click(key, value)
    if key == 'Add_Craft' then
        colourChange(key, 'blue')
        gg = checkChestCraft()
        if gg == 'ok' then
            colourChange(key, 'yellow')
        elseif gg then
            colourChange(key, 'green')
        else
            colourChange(key, 'red')
        end
        sleep(0.2)
        colourChange(key, 'black')
    end
    if key == 'All' then
        CurrentButtonClick = key
        for keyIt, item in pairs(buttons) do
            if keyIt == key then
                item[4] = 'purple'
            else
                table.remove(item, 4)
            end
        end
        page = 1
        pagesof = 0
        listData = callSrarch(key)
        for _, item in pairs(listData) do
            pagesof = pagesof + 1
        end
        monitor.clear()
        dravList(listData)
        drawButtons(buttons)
        pageRoll()
        drawButtons(btnRoll)
    end
    if key == 'Mods' then
        CurrentButtonClick = key
        for keyIt, item in pairs(buttons) do
            if keyIt == key then
                item[4] = 'purple'
            else
                table.remove(item, 4)
            end
        end
        page = 1
        pagesof = 0
        listData = callSrarch(key)
        for _, item in pairs(listData) do
            pagesof = pagesof + 1
        end
        monitor.clear()
        dravList(listData, true)
        drawButtons(buttons)
        pageRoll()
        drawButtons(btnRoll)
    end

    if key == 'Search' then
        CurrentButtonClick = key
        for keyIt, item in pairs(buttons) do
            if keyIt == key then
                item[4] = 'purple'
            else
                table.remove(item, 4)
            end
        end
        page = 1
        pagesof = 0
        listData = callSrarch(key, '')
        for _, item in pairs(listData) do
            pagesof = pagesof + 1
        end
        monitor.clear()
        klavaActivate()
        drawButtons(buttons)
        dravList(listData)
        pageRoll()
        drawButtons(btnRoll)
    end

    if key == 'Back' then
        if 1 < page then
            page = page - 1
            monitor.clear()
            dravList(listData)
            drawButtons(buttons)
            pageRoll()
            drawButtons(btnRoll)
        end
    end
    if key == 'Next' then
        if page < pagesof then
            page = page + 1
            monitor.clear()
            dravList(listData)
            drawButtons(buttons)
            pageRoll()
            drawButtons(btnRoll)
        end
    end
    if key == 'Delete' then
        craftinput = true
        craftCount = ''
        settings(craftSettings)
    end
    if key == 'Craft' then
        if #craftCount > 0 then
            if tonumber(craftCount) >= 1 then
                mainNeed = prepairCraft(craftSettings, math.ceil(tonumber(craftCount) / craftSettings.count))
                if #mainNeed > 0 then
                    for key, value in pairs(mainNeed) do
                        monitor.setBackgroundColor(colors.black)
                        monitor.setCursorPos(1, 9 + key)
                        monitor.write('                                                                               ')
                        monitor.setBackgroundColor(colors.red)
                        monitor.setCursorPos(1, 9 + key)
                        monitor.write(value.name .. ' ' .. value.count)
                        monitor.setBackgroundColor(colors.black)
                    end
                end
            end
        end
    end
end

while true do
    local event, side, x, y = os.pullEvent("monitor_touch")
    if side == mon1 then
        if listData then
            for key, value in pairs(btnRoll) do
                if x >= value[1] and x <= value[1] + value[3] and y == value[2] then
                    Click(key)
                end
            end
        end

        if CurrentButtonClick == 'GetAllFromMods' or CurrentButtonClick == 'All' or CurrentButtonClick == 'Search' then
            craftSettings = {}
            if listData['on' .. page][y - 2] then
                craftinput = true
                craftCount = '1'
                craftSettings = listData['on' .. page][y - 2]
                CurrentButtonClick = 'CraftSettings'
                settings(listData['on' .. page][y - 2])

                -- print(textutils.serialiseJSON(listData['on' .. page][y - 2]))
            end
        end
        if CurrentButtonClick == 'Mods' then
            craftSettings = {}
            if x >= 2 and x <= 60 and y >= 3 and y <= 18 then
                if listData['on' .. page][y - 2] then
                    page = 1
                    pagesof = 0
                    CurrentButtonClick = 'GetAllFromMods'
                    listData = callSrarch('GetAllFromMods', listData['on' .. page][y - 2])
                    for _, item in pairs(listData) do
                        pagesof = pagesof + 1
                    end
                    monitor.clear()
                    dravList(listData)
                    drawButtons(buttons)
                    pageRoll()
                    drawButtons(btnRoll)
                end
            end
        end

        for key, value in pairs(buttons) do
            if x >= value[1] and x <= value[1] + value[3] and y == value[2] then
                Click(key)
            end
        end
        if CurrentButtonClick == 'Search' then
            search = ''
        else
            klava.setBackgroundColor(colors.black)
            klava.clear()
            klava.setBackgroundColor(colors.blue)
        end
        if CurrentButtonClick == 'CraftSettings' then
            if y >= 5 and y <= 8 then
                if x >= 23 and x <= 27 then
                    numberis = 0
                    nuncheck = false
                    if y == 5 then
                        numberis = math.floor((x - 21) / 2)
                        nuncheck = true
                    elseif y == 6 then
                        numberis = math.floor((x - 21) / 2) + 3
                        nuncheck = true
                    elseif y == 7 then
                        numberis = math.floor((x - 21) / 2) + 6
                        nuncheck = true
                    elseif y == 8 and x == 25 then
                        nuncheck = true
                    end
                    if nuncheck then
                        if craftinput then
                            craftinput = false
                            craftCount = ''
                        end
                        craftCount = craftCount .. numberis
                        settings(craftSettings)
                    end
                end
            end
        end
        if craftSettings and CurrentButtonClick == 'CraftSettings' then
            for key, value in pairs(btnPrepair) do
                if x >= value[1] and x <= value[1] + value[3] and y == value[2] then
                    Click(key)
                end
            end
        end
    elseif side == mon2 then
        if CurrentButtonClick == 'Search' then
            letter = ''
            if y == 3 then
                letter = textKlava[1]:sub(x - 2, x - 2)
            elseif y == 4 then
                letter = textKlava[2]:sub(x - 2, x - 2)
            elseif y == 5 then
                letter = textKlava[3]:sub(x - 3, x - 3)
            end
            if letter then
                klava.setBackgroundColor(colors.blue)
                klava.setCursorPos(x, y)
                klava.write(letter)
                search = search .. letter
                klava.setCursorPos(1, 1)
                klava.write(search)
                sleep(0.2)
                klava.setCursorPos(x, y)
                klava.setBackgroundColor(colors.black)
                klava.write(letter)
                klava.setBackgroundColor(colors.blue)
                page = 1
                pagesof = 0
                listData = callSrarch('Search', search)
                for _, item in pairs(listData) do
                    pagesof = pagesof + 1
                end
                monitor.clear()
                drawButtons(buttons)
                dravList(listData)
                pageRoll()
                drawButtons(btnRoll)
            end
        else
            klava.setBackgroundColor(colors.black)
            klava.clear()
            klava.setBackgroundColor(colors.blue)
        end
    end
end
