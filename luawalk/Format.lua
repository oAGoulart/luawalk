assert(_G._VERSION == "Lua 5.4")

if String == nil then
  require("luawalk.String")
end

local Field_ = {}
Field_.new = function(index, typedef, value)
  local self = {}

  self.index = index
  self.typedef = typedef
  self.value = value

  return setmetatable(self, self)
end

local Format_ = {}
Format_.new = function(stream)
  local self = {}
  local stream_ = stream

  function self:Get(typedef, name)
    local attr = String.split(name, ".", true)
    local key = self
    if #attr > 0 then
      for i = 1, #attr - 1, 1 do
        key = key[attr[i]]
      end
      name = attr[#attr]
    end
    key[name] = Field_.new(
      stream_:Index(),
      typedef,
      stream_:Read(typedef))
  end

  function self:Iterate(iterator)
    for name, field in pairs(self) do
      if type(field) == "table" then
        iterator(name, field)
      end
    end
  end

  function self:Jump(offset)
    stream_:Seek("set", offset)
  end

  function self:Skip(amount)
    stream_:Seek("cur", amount)
  end

  return setmetatable(self, self)
end

if _REQUIREDNAME == nil then
  Format = Format_
else
  _G[_REQUIREDNAME] = Format_
end
