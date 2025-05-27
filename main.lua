assert(_G._VERSION == "Lua 5.4")

if Stream == nil then
  require("luawalk.Stream")
end
if Typedef == nil then
  require("luawalk.Typedef")
end
if Format == nil then
  require("luawalk.Format")
end

local s = Stream.new("./main.exe")

local PEFile = require("formats.PEFormat")

local d = PEFile(s)

d:Iterate(function(field)
  print(field.name, "index:", field.index, "value:", field.value)
  if type(field.value) == "table" then
    for _, v in ipairs(field.value) do
      print(v)
    end
  end
end)
