-- Подключаем сундук справа
local input = peripheral.wrap("right")
if not input then
  print("Сундук справа не найден!")
  return
end

-- Проверяем слоты сундука
for slot=1, input.size() do
  local item = input.getItemDetail(slot)
  if item then
    print("---- Slot "..slot.." ----")
    print("Name: "..tostring(item.name))
    print("Count: "..tostring(item.count))
    print("Damage: "..tostring(item.damage or 0))
    
    -- Проверка NBT
    if item.nbt then
      if type(item.nbt) == "table" then
        print("NBT (table):")
        for k,v in pairs(item.nbt) do
          print("  "..tostring(k)..": "..textutils.serialize(v))
        end
      else
        print("NBT (string): "..tostring(item.nbt))
      end
    else
      print("NBT: none")
    end

    -- Теги (если есть)
    if item.tags then
      print("Tags:")
      for i, tag in ipairs(item.tags) do
        print("  "..tag)
      end
    else
      print("Tags: none")
    end
  else
    print("Слот "..slot.." пуст")
  end
end
