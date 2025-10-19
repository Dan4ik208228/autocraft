local function matchScore(text, query)
    text = text:lower()
    query = query:lower()

    local score = 0
    local lastIndex = 0

    for c in query:gmatch(".") do
        local i = text:find(c, lastIndex + 1, true)
        if i then
            score = score + 1
            lastIndex = i
        end
    end

    return score
end

function fuzzySort(array, query)
    local scored = {}

    for _, item in ipairs(array) do
        local name = item.name or tostring(item)
        local score = matchScore(name, query)
        table.insert(scored, { data = item, score = score })
    end

    table.sort(scored, function(a, b)
        return a.score > b.score
    end)

    local sorted = {}
    for _, s in ipairs(scored) do
        table.insert(sorted, s.data)
    end
    return sorted
end