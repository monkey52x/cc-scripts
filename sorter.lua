-- config: заменяй на свои стороны (или peripheral.getName(...))
local inputSide = "right"      -- буферный сундук
local swordSide = "left"       -- сундук для мечей (на нём Storage Bus)
local importSide = "bottom"    -- сундук для остальных (на нём Import Bus)

local input = peripheral.wrap(inputSide)
local sword = peripheral.wrap(swordSide)
local imp = peripheral.wrap(importSide)
local swordName = peripheral.getName(sword)
local impName = peripheral.getName(imp)

for slot=1, input.size() do
  local item = input.getItemDetail(slot)
  if item then
    local nm = (item.name or ""):lower()
    if string.find(nm, "sword") then
      input.pushItems(swordName, slot)   -- переместить мечи в chest со Storage Bus
    else
      input.pushItems(impName, slot)     -- остальное — в import-сундук
    end
  end
end
