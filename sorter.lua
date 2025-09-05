-- Configuration
local inputChest = peripheral.wrap("right")  -- Chest with input items
local matchChest = peripheral.wrap("top")    -- Chest for items matching tags from tags.txt
local noMatchChest = peripheral.wrap("left") -- Chest for items not matching tags
local tagFile = "tags.txt"                  -- File for both filter tags and storing unique tags
local checkInterval = 0.1                   -- Interval between checks (in seconds)

-- Check if all chests are connected
if inputChest == nil then
    print("Error: Input chest (right) not found!")
    return
end
if matchChest == nil then
    print("Error: Match chest (top) not found!")
    return
end
if noMatchChest == nil then
    print("Error: No-match chest (left) not found!")
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
    print("Warning: " .. tagFile .. " not found, creating an empty one")
    file = fs.open(tagFile, "w")
    file.close()
end

-- Function to append new tags to tags.txt
local function appendTagsToFile(tags)
    -- Read existing tags from file
    local existingTags = {}
    for tag, _ in pairs(filterTags) do
        existingTags[tag] = true
    end

    -- Check for new tags
    local newTags = {}
    for tag, _ in pairs(tags) do
        if not existingTags[tag] then
            newTags[tag] = true
            filterTags[tag] = true  -- Update filterTags for future checks
        end
    end

    -- If there are new tags, append them to file
    if next(newTags) then
        file = fs.open(tagFile, "a")
        if not file then
            print("Error: Could not open " .. tagFile .. " for writing!")
            return
        end
        for tag, _ in pairs(newTags) do
            file.writeLine(tag)
        end
        file.close()
    end
end

-- Main loop
print("Sorting started. Press Ctrl+C to stop.")
while true do
    -- Get list of items in the input chest
    local items = inputChest.list()

    -- Process each item in the input chest
    for slot, item in pairs(items) do
        local itemDetail = inputChest.getItemDetail(slot)
        if itemDetail then
            -- Save new tags to tags.txt
            if itemDetail.tags then
                appendTagsToFile(itemDetail.tags)
            end

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
            local targetChestName = hasFilterTag and "top" or "left"
            local itemName = itemDetail.displayName or itemDetail.name or "Unknown"

            -- Attempt to push the item
            local moved = inputChest.pushItems(peripheral.getName(targetChest), slot, item.count)
            if moved > 0 then
                print("Moved " .. moved .. "x " .. itemName .. " to " .. targetChestName .. " chest")
            else
                print("Failed to move " .. itemName .. " to " .. targetChestName .. " chest")
            end
        else
            print("Failed to get details for item in slot " .. slot)
        end
    end

    -- Short sleep to prevent game lag
    os.sleep(checkInterval)
end
