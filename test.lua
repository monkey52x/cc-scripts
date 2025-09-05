-- Configuration
local inputInventory = peripheral.wrap("right")  -- Any inventory for input items (right, optional)
local matchInventory = peripheral.wrap("left")   -- Output for items matching tags
local noMatchInventory = peripheral.wrap("top")  -- Optional output for non-matching items
local tagFile = "tags.txt"                      -- File with filter tags
local checkInterval = 0.1                       -- Interval between checks (in seconds)

-- Check if required output inventory is connected
if matchInventory == nil then
    print("Error: Output inventory (left) not found!")
    return
end

-- Check if no-match inventory (top) is connected and set mode
local useTopInventory = noMatchInventory ~= nil
if useTopInventory then
    print("Started in full filter mode: Matching items go to left, others to top")
else
    print("Started in pass-only mode: Matching items go to left, others stay in input")
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
    -- Check for input inventory dynamically
    inputInventory = peripheral.wrap("right")
    if inputInventory == nil then
        print("No input inventory (right) detected, waiting...")
    else
        -- Get list of items in the input inventory
        local items = inputInventory.list()

        -- Process each item in the input inventory
        for slot, item in pairs(items) do
            local itemDetail = inputInventory.getItemDetail(slot)
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

                -- Move only if it matches or if top inventory exists for non-matching
                if hasFilterTag or useTopInventory then
                    local targetInventory = hasFilterTag and matchInventory or noMatchInventory
                    local targetInventoryName = hasFilterTag and "left" or "top"
                    local itemId = itemDetail.name or "Unknown"

                    -- Attempt to push the item
                    local moved = inputInventory.pushItems(peripheral.getName(targetInventory), slot, item.count)
                    if moved > 0 then
                        print("Moved " .. moved .. "x " .. itemId .. " to " .. targetInventoryName)
                    else
                        print("Failed to move " .. itemId .. " to " .. targetInventoryName)
                    end
                end
            else
                print("Failed to get details for item in slot " .. slot)
            end
        end
    end

    -- Short sleep to prevent game lag
    os.sleep(checkInterval)
end
