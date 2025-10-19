require("server")
require("serch")
function callSrarch(value, mods)
    if value == 'All' then
        data = getData()
        filtered = {}
        fil = 1
        count = 0
        filtered['on' .. fil] = {}
        for _, item in pairs(data) do
            if count == 15 then
                count = 1
                fil = fil + 1
                filtered['on' .. fil] = {}
            else
                count = count + 1
            end
            table.insert(filtered['on' .. fil], item)
        end
        return filtered
    end
    if value == 'Mods' then
        data = getData()
        filtered = {}
        fil = 1
        count = 0
        filtered['on' .. fil] = {}
        for _, item in pairs(data) do
            doInsert = true
            dTrick, darg = item.name:match("([^:]+):?(.*)")
            for keyFilter, itemFilter in pairs(filtered) do
                for keyFilter1, itemFilter1 in pairs(itemFilter) do
                    command, arg = itemFilter1.name:match("([^:]+):?(.*)")
                    if command == dTrick then
                        doInsert = false
                    end
                end
            end
            if doInsert then
                if count == 15 then
                    count = 1
                    fil = fil + 1
                    filtered['on' .. fil] = {}
                else
                    count = count + 1
                end
                table.insert(filtered['on' .. fil], item)
            end
        end
        return filtered
    end
    if value == 'GetAllFromMods' then
        dTrick, darg = mods.name:match("([^:]+):?(.*)")
        data = getData()
        filtered = {}
        fil = 1
        count = 0
        filtered['on' .. fil] = {}
        for _, item in pairs(data) do
            finder = false
            dcomp, arg = item.name:match("([^:]+):?(.*)")
            if dcomp == dTrick then
                finder = true
            end
            if finder then
                if count == 15 then
                    count = 1
                    fil = fil + 1
                    filtered['on' .. fil] = {}
                else
                    count = count + 1
                end
                table.insert(filtered['on' .. fil], item)
            end
        end
        return filtered
    end
    if value == 'Search' then
        data = fuzzySort(getData(), mods)
        filtered = {}
        fil = 1
        count = 0
        filtered['on' .. fil] = {}
        for _, item in pairs(data) do
            if count == 15 then
                count = 1
                fil = fil + 1
                filtered['on' .. fil] = {}
            else
                count = count + 1
            end
            table.insert(filtered['on' .. fil], item)
        end
        return filtered
    end
end
