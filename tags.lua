-- Connect to the peripheral (chest on the right)
local chest = peripheral.wrap("right")

-- Check if the chest is connected
if chest == nil then
    print("Error: Chest on the right not found!")
    return
end

-- Get the list of items in the chest
local items = chest.list()

-- Check if the first slot has an item
if items[1] == nil then
    print("First slot of the chest is empty!")
    return
end

-- Get detailed information about the first item
local itemDetail = chest.getItemDetail(1)

-- Check if item information was retrieved
if itemDetail == nil then
    print("Failed to retrieve information about the item in the first slot!")
    return
end

-- Output item information
print("Information about the item in the first slot:")
print("Name: " .. (itemDetail.displayName or "Unknown"))
print("ID: " .. (itemDetail.name or "Unknown"))
print("Count: " .. (itemDetail.count or "Unknown"))

-- Check and output tags if they exist
if itemDetail.tags then
    print("Tags:")
    for tag, _ in pairs(itemDetail.tags) do
        print("  - " .. tag)
    end
else
    print("Tags: None")
end

-- Output additional information if available
print("Additional information:")
for key, value in pairs(itemDetail) do
    if key ~= "displayName" and key ~= "name" and key ~= "count" and key ~= "tags" then
        print("  " .. key .. ": " .. tostring(value))
    end
end
