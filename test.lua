-- Find all connected peripherals
local peripherals = peripheral.getNames()
if #peripherals == 0 then
    print("No peripherals connected.")
else
    print("Connected peripherals:")
    for i, name in ipairs(peripherals) do
        local pType = peripheral.getType(name)
        print(i..". "..name.." ("..tostring(pType)..")")
    end
end

print("\nScanning containers...\n")

-- Function to print items in a container
local function printContainer(name)
    if not peripheral.hasType(name, "inventory") and not peripheral.hasType(name, "chest") then
        return
    end

    local container = peripheral.wrap(name)
    if not container then return end

    local size = container.size and container.size() or 0
    if size == 0 then
        print(name.." is empty or not a container.")
        return
    end

    print("Items in "..name..":")
    for slot=1,size do
        local item = container.getItemDetail(slot)
        if item then
            print(" Slot "..slot..": "..item.count.."x "..item.name)
            if item.damage then print("   Damage: "..item.damage) end
            if item.nbt then print("   NBT: "..textutils.serialize(item.nbt)) end
            if item.tags then
                print("   Tags: "..table.concat(item.tags,", "))
            end
        end
    end
end

-- Scan all peripherals for containers
for _, name in ipairs(peripherals) do
    printContainer(name)
end
