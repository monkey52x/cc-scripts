-- Подключаем инвентарь компьютера
local chest = peripheral.wrap("left")  -- сундук слева

-- Функция, которая переносит все предметы из инвентаря компьютера в сундук
function transferAll()
    for slot = 1, 16 do  -- у компьютера 16 слотов
        local item = turtle.getItemDetail(slot)
        if item then
            turtle.select(slot)
            -- Пробуем положить предметы в сундук слева
            turtle.drop()
        end
    end
end

-- Основной цикл
while true do
    transferAll()
    sleep(1)  -- пауза 1 секунда, чтобы не нагружать процессор
end
