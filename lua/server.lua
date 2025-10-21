local dataDir = "/data"
local dataFile = dataDir .. "/data.json"

if not fs.exists(dataDir) then
    fs.makeDir(dataDir)
end

function getData(where)
    if fs.exists(dataFile) then
        local file = fs.open(dataFile, "r")
        local json = file.readAll()
        file.close()

        local data = textutils.unserialiseJSON(json)
        if not data then return {} end

        if where then
            local filtered = {}
            for _, item in pairs(data) do
                if item.where and item.where[1] == where[2] then
                    table.insert(filtered, item)
                end
            end
            return filtered
        end

        return data
    else
        return {}
    end
end

function wrigthData(json)
    local data = getData() or {}

    table.insert(data, json)
    local file = fs.open(dataFile, "w")
    file.write(textutils.serialiseJSON(data))
    file.close()
end
