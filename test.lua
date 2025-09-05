local chest = peripheral.wrap("left")  -- сундук слева

while true do
    for slot = 1, 16 do
        local item = turtle.getItemDetail(slot)
        if item then
            if item.name == "minecraft:dirt" then
                turtle.select(slot)
                turtle.drop()  -- отправляем землю в сундук
            else
                -- Любой другой предмет сразу возвращаем в сундук
                turtle.select(slot)
                turtle.drop(64)  -- сбрасываем в сундук слева
            end
        end
    end
    sleep(0.2)  -- проверяем часто, чтобы трубами ничего не задержалось
end
