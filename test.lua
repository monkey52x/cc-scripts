-- Get all connected peripherals
local peripherals = peripheral.getNames()

if #peripherals == 0 then
  print("No peripherals connected.")
else
  print("Connected peripherals:")
  for i, name in ipairs(peripherals) do
    print(i..". "..name.." ("..tostring(peripheral.getType(name))..")")
  end
end

-- Optionally, check sides explicitly
local sides = {"top", "bottom", "left", "right", "front", "back"}
print("\nPeripherals by side:")
for _, side in ipairs(sides) do
  if peripheral.isPresent(side) then
    print(side..": "..peripheral.getType(side))
  else
    print(side..": none")
  end
end
