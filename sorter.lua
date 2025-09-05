-- читаем список тегов из файла
local swordTags = {}
if fs.exists("tags.txt") then
  local f = fs.open("tags.txt", "r")
  while true do
    local line = f.readLine()
    if not line then break end
    table.insert(swordTags, line)
  end
  f.close()
else
  print("Файл tags.txt не найден!")
end

local input = peripheral.wrap("right")
local sword = peripheral.wrap("left")
local other = peripheral.wrap("bottom")

local function isSword(itemName)
  local name = itemName:lower()
  for _, tag in ipairs(swordTags) do
    if string.find(name, tag) then
      return true
    end
  end
  return false
end

while true do
  for slot=1, input.size() do
    local item = input.getItemDetail(slot)
    if item then
      if isSword(item.name) then
        input.pushItems("left", slot)
      else
        input.pushItems("bottom", slot)
      end
    end
  end
  sleep(1)
end
