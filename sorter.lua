local input = peripheral.wrap("right")       -- буферный сундук
local sword = peripheral.wrap("left")        -- сундук для мечей
local other = peripheral.wrap("bottom")      -- сундук для остальных

while true do
  for slot=1, input.size() do
    local item = input.getItemDetail(slot)
    if item then
      local nm = (item.name or ""):lower()
      if string.find(nm, "sword") then
        input.pushItems("left", slot)   -- если сундук слева
      else
        input.pushItems("bottom", slot) -- если сундук снизу
      end
    end
  end
  sleep(1)
end
