dravers = peripheral.wrap("extended_drawers:access_point_0")
cccggg = peripheral.wrap("extended_drawers:access_point_0")
-- chestffffffffff = peripheral.wrap("extended_drawers:access_point_0")
require("server")
require("gocraft")

craftLadder = {}


local function gripCraft(craft)
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


local function findItem(tab, name)
    for i, v in ipairs(tab) do
        if v.name == name then
            return i
        end
    end
    return nil
end

local function findRecipe(allCrafts, name)
    for _, r in pairs(allCrafts) do
        if r.name == name then return r end
    end
    return nil
end

function prepairCraft(craft, howMuch)
    craftLadder = {}
    local allCrafts = getData()
    local drawersItems = dravers.items()
    local stepNum = 1

    craftLadder["on" .. stepNum] = { { name = craft.name, count = howMuch } }

    local isRunning = true

    while isRunning do
        local itemsNeedLader = {}

        for _, currentItem in pairs(craftLadder["on" .. stepNum]) do
            local matchedRecipe = findRecipe(allCrafts, currentItem.name)

            if matchedRecipe then
                local craftsNeeded = math.ceil(currentItem.count / matchedRecipe.count)

                local ingredients = gripCraft(matchedRecipe.craft)

                for _, ing in ipairs(ingredients) do
                    local totalNeededItems = ing.count * craftsNeeded
                    local remainingItems = totalNeededItems

                    for _, d in pairs(drawersItems) do
                        if d.name == ing.name then
                            local used = math.min(d.count, remainingItems)
                            d.count = d.count - used
                            -- chestffffffffff.pushItem('minecraft:chest_1', d.name , used)
                            remainingItems = remainingItems - used
                            if remainingItems <= 0 then break end
                        end
                    end

                    if remainingItems > 0 then
                        local ingRecipe = findRecipe(allCrafts, ing.name)
                        if ingRecipe then
                            local craftsForIng = math.ceil(remainingItems / ingRecipe.count)

                            local idx = findItem(itemsNeedLader, ing.name)
                            if idx then
                                itemsNeedLader[idx].count = itemsNeedLader[idx].count + craftsForIng
                            else
                                table.insert(itemsNeedLader, { name = ing.name, count = craftsForIng })
                            end
                        else
                            local idx = findItem(itemsNeedLader, ing.name)
                            if idx then
                                itemsNeedLader[idx].count = itemsNeedLader[idx].count + remainingItems
                            else
                                table.insert(itemsNeedLader, { name = ing.name, count = remainingItems })
                            end
                        end
                    end
                end
            end
        end

        if #itemsNeedLader > 0 then
            stepNum = stepNum + 1
            craftLadder["on" .. stepNum] = {}
            for _, v in ipairs(itemsNeedLader) do
                table.insert(craftLadder["on" .. stepNum], v)
            end
        else
            isRunning = false
        end
    end


    local allneedsToCrafts = {}
    for _, ingSet in pairs(craftLadder) do
        for _, ding in pairs(ingSet) do
            local recipe = findRecipe(allCrafts, ding.name)
            if not recipe then
                local idx = findItem(allneedsToCrafts, ding.name)
                if idx then
                    allneedsToCrafts[idx].count = allneedsToCrafts[idx].count + ding.count
                else
                    table.insert(allneedsToCrafts, { name = ding.name, count = ding.count })
                end
            end
        end
    end

    if #allneedsToCrafts == 0 then
        craftAll(craftLadder)
    else
        print(textutils.serialiseJSON(allneedsToCrafts))
    end

    return allneedsToCrafts
end
