assert(_G._VERSION == "Lua 5.4")

local String_ = {}
String_.split = function(str, substr, plain)
  local result = {}
  local first = 1
  local last = nil
  while true do
    last = string.find(str, substr, first, plain)
    if last == nil then
      break
    else
      table.insert(result, string.sub(str, first, last - 1))
      first = last + 1
    end
  end
  if first > 1 then
    table.insert(result, string.sub(str, first))
  end
  return result
end

if _REQUIREDNAME == nil then
  String = String_
else
  _G[_REQUIREDNAME] = String_
end
