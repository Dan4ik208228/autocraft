function getData(where)
    if fs.exists("data.json") then
        file = fs.open("data.json", "r")
        json = file.readAll()
        file.close()
        data = textutils.unserialiseJSON(json)
        filtered = {}
        if where then
            for _, item in pairs(data) do
                if item.where[1] == where[2] then
                    table.insert(filtered, item)
                end
            end
            return filtered
        end
        return data
    end
end

function wrigthData(json)
    data = getData()
    all={}
    local file = fs.open("data.json", "w")
    if data then
        all=data
    end
    table.insert(all, json)
    file.write(textutils.serialiseJSON(all))
    file.close()
end
