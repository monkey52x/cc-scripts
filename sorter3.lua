-- Configuration
local inputChest = peripheral.wrap("right")  -- Chest with input items
local matchChest = peripheral.wrap("left")   -- Chest for items matching tags or IDs
local noMatchChest = peripheral.wrap("top")  -- Chest for items not matching tags or IDs
local tagFile = "tags.txt"                  -- File with filter tags
local idFile = "ids.txt"                    -- File with filter item IDs
local checkInterval = 0.1                   -- Interval between checks (in seconds)

-- Check if all chests are connected
if inputChest == nil then
    print("Error: Input chest (right) not found!")
    return
end
if matchChest == nil then
    print("Error: Match chest (left) not found!")
    return
end
if noMatchChest == nil then
    print("Error: No-match chest (top) not found!")
    return
end

-- Read tags from tags.txt
local filterTags = {}
local file = fs.open(tagFile, "r")
if file then
    while true do
        local line = file.readLine()
        if not line then break end
        if line ~= "" then
            filterTags[line] = true
        end
    end
    file.close()
else
    print("Warning: " .. tagFile .. " not found! Tags filter will be ignored.")
end

-- Read item IDs from ids.txt
local filterIds = {}
file = fs.open(idFile, "r")
if file then
    while true do
        local line = file.readLine()
        if not line then break end
        if line ~= "" then
            filterIds[line] = true
        end
    end
    file.close()
else
    print("Warning: " .. idFile .. " not found! IDs filter will be ignored.")
end

-- Check if any filters were loaded
if next(filterTags) == nil and next(filterIds) == nil then
    print("Error: No tags or IDs found in " .. tagFile .. " or " .. idFile .. "!")
    return
end

-- Main loop
while true do
    -- Get list of items in the input chest
    local items = inputChest.list()

    -- Process each item in the input chest
    for slot, item in pairs(items) do
        local itemDetail = inputChest.getItemDetail(slot)
        if itemDetail then
            -- Check if the item matches any filter (tags or IDs)
            local isMatch = false
            local itemId = itemDetail.name or "Unknown"

            -- Check tags
            if itemDetail.tags then
                for tag, _ in pairs(itemDetail.tags) do
                    if filterTags[tag] then
                        isMatch = true
                        break
                    end
                end
            end

            -- Check item ID
            if filterIds[itemId] then
                isMatch = true
            end

            -- Move item to the appropriate chest
            local targetChest = isMatch and matchChest or noMatchChest
            local targetChestName = isMatch and "left" or "top"

            -- Attempt to push the item
            local moved = inputChest.pushItems(peripheral.getName(targetChest), slot, item.count)
            if moved > 0 then
                print("Moved " .. moved .. "x " .. itemId .. " to " .. targetChestName .. " chest")
            else
                print("Failed to move " .. itemId .. " to " .. targetChestName .. " chest")
            end
        else
            print("Failed to get details for item in slot " .. slot)
        end
    end

    -- Short sleep to prevent game lag
    os.sleep(checkInterval)
end
