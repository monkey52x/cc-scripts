-- Функция для добавления предмета в слот с проверкой
function acceptItem(slot)
    local item = turtle.getItemDetail(slot)
    if item and item.name == "minecraft:dirt" then
        return true  -- принимаем только землю
    else
        return false -- игнорируем все остальное
    end
end

-- Основной цикл
while true do
    for slot = 1, 16 do
        local item = turtle.getItemDetail(slot)
        if item then
            if acceptItem(slot) then
                -- Можно, например, положить в сундук слева
                turtle.select(slot)
                turtle.drop()  -- выбрасываем в сундук слева
            else
                print("Предмет не разрешен: "..item.name)
                -- можно выбросить в пустоту или оставить в слоте
            end
        end
    end
    sleep(0.5)
end
