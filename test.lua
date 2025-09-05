-- Получаем сундук слева
local chest = peripheral.wrap("left")

-- Функция для передачи предметов из компьютера в сундук
function transferAll()
    local inv = peripheral.wrap("back") -- если нужен инвентарь за компьютером
    if not inv then
        print("Инвентаря нет")
        return
    end

    for slot = 1, inv.size() do
        local item = inv.getItemDetail(slot)
        if item then
            inv.pushItems(peripheral.getName(chest), slot)
        end
    end
end

-- Основной цикл
while true do
    transferAll()
    sleep(1)
end
