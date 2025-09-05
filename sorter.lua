-- Загружаем список тегов из файла tags.txt
local swordTags = {}
if fs.exists("tags.txt") then
  local f = fs.open("tags.txt", "r")
  while true do
    local line = f.readLine()
    if not line then break end
    table.insert(swordTags, line:lower())
  end
  f.close()
else
  print("Файл tags.txt не найден! Создайте его и добавьте теги.")
  return
end

-- Подключаем сундуки
local input  = peripheral.wrap("right")   -- правый сундук (вход)
local pass   = peripheral.wrap("left")    -- левый сундук (прошли сортировку)
local reject = peripheral.wrap("top")     -- верхний сундук (не прошли)

if not input or not pass or not reject then
  print("Ошибка: не все сундуки найдены. Проверь расположение.")
  return
end

-- Проверка: подходит ли предмет по тегам
local function matchesTag(itemName)
  local name = itemName:lower()
  for _, tag in ipairs(swordTags) do
    if string.find(name, tag) then
      return true
    end
  end
  return false
end

print("Сортировщик запущен.")

-- Основной цикл
while true do
  for slot=1, input.size() do
    local item = input.getItemDetail(slot)
    if item then
      if matchesTag(item.name) then
        input.pushItems(peripheral.getName(pass), slot)
      else
        input.pushItems(peripheral.getName(reject), slot)
      end
    end
  end
end
