-- Проверяем периферию на наличие модема
local sides = {"top","bottom","left","right","front","back"}
local modemSide = nil

for _, side in ipairs(sides) do
  if peripheral.getType(side) == "modem" then
    modemSide = side
    break
  end
end

if not modemSide then
  print("No modem found.")
  return
end

print("Modem found on side: "..modemSide)

-- Проверка, есть ли проводные или беспроводные подключения
local modem = peripheral.wrap(modemSide)

if modem.isWireless and modem.isWireless() then
  print("This is a wireless modem.")
else
  print("This is a wired modem.")
end

-- Список подключённых периферий через модем (только wired)
if not modem.isWireless or not modem.isWireless() then
  local connected = modem.getNamesRemote()
  if #connected == 0 then
    print("No peripherals connected to this modem.")
  else
    print("Peripherals connected via modem:")
    for i, name in ipairs(connected) do
      print(i..". "..name.." ("..peripheral.getType(name)..")")
    end
  end
end
