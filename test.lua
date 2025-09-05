
local chest = peripheral.wrap("left")

function transferAll()
    for slot = 1, 16 do
        local item = commands.getItemDetail(slot)
        if item then
            chest.pullItems(peripheral.getName(peripheral.find("inventory")), slot)
        end
    end
end

while true do
    transferAll()
    sleep(0.5)
end
