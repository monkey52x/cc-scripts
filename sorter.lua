-- Configuration
local inputChest = peripheral.wrap("right")  -- Chest with input items
local matchChest = peripheral.wrap("left")   -- Chest for items matching tags from tags.txt
local noMatchChest = peripheral.wrap("top")  -- Chest for items not matching tags
local tagFile = "tags.txt"                  -- File with filter tags
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
    print("Error: " .. tagFile .. " not found!")
    return
end

-- Check if any tags were loaded
if next(filterTags) == nil then
    print("Error: No tags found in " .. tagFile .. "!")
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
            -- Check if the item has any of the filter tags
            local hasFilterTag = false
            if itemDetail.tags then
                for tag, _ in pairs(itemDetail.tags) do
                    if filterTags[tag] then
                        hasFilterTag = true
                        break
                    end
                end
            end

            -- Move item to the appropriate chest
            local targetChest = hasFilterTag and matchChest or noMatchChest
            local targetChestName = hasFilterTag and "left" or "top"
            local itemId = itemDetail.name or "Unknown"

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
