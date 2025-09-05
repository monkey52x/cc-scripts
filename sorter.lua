-- Configuration
local inputChest = peripheral.wrap("right")  -- Chest with input items
local matchChest = peripheral.wrap("top")    -- Chest for items matching tags from tags.txt
local noMatchChest = peripheral.wrap("left") -- Chest for items not matching tags
local tagFile = "tags.txt"                  -- File for both filter tags and storing unique tags

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
local function appendTagsToFile(tags, fileName)
    -- Read existing tags from file
    local existingTags = {}
    local file = fs.open(fileName, "r")
    if file then
        while true do
            local line = file.readLine()
            if not line then break end
            existingTags[line] = true
        end
        file.close()
    end

    -- Open file in append mode to add new tags
    file = fs.open(fileName, "a")
    if not file then
        print("Error: Could not open " .. fileName .. " for writing!")
        return
    end

    -- Write new tags if they don't already exist
    for tag, _ in pairs(tags) do
        if not existingTags[tag] then
            file.writeLine(tag)
            existingTags[tag] = true
        end
    end
    file.close()
end

-- Get list of items in the input chest
local items = inputChest.list()

-- Process each item in the input chest
for slot, item in pairs(items) do
    local itemDetail = inputChest.getItemDetail(slot)
    if itemDetail then
        -- Save new tags to tags.txt
        if itemDetail.tags then
            appendTagsToFile(itemDetail.tags, tagFile)
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

-- Final message
print("Sorting complete. Tags updated in " .. tagFile)
