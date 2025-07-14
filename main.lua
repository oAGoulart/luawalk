assert(_G._VERSION == "Lua 5.4")

local num_args = 2
if #arg < num_args then
  error("not enough arguments.")
end

if Stream == nil then
  require("luawalk.Stream")
end
if Typedef == nil then
  require("luawalk.Typedef")
end
if Format == nil then
  require("luawalk.Format")
end

local s = Stream.new(arg[2])
local f
if arg[1] == "pe" then
  local PEFile = require("formats.PEFormat")
  f = PEFile(s)
else
  error("unsupported format.")
end

f:Iterate(function(name, field)
  print(name, "index:", field.index, "value:", field.value)
  if type(field.value) == "table" then
    for _, v in ipairs(field.value) do
      print(v)
    end
  end
end)
