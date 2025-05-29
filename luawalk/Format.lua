local Field_ = {}
Field_.new = function(index, typedef, name, value, display)
  local self = {}

  self.index = index
  self.typedef = typedef
  self.name = name
  self.value = value
  self.display = display

  return setmetatable(self, self)
end

local Format_ = {}
Format_.new = function(stream)
  local self = {}

  self.stream = stream
  local values_ = {}

  function self:Get(typedef, name)
    table.insert(values_, Field_.new(
      self.stream:Index(),
      typedef,
      name,
      self.stream:Read(typedef)))
  end

  function self:Value(index)
    return values_[index]
  end

  function self:Iterate(iterator)
    for _, field in ipairs(values_) do
      iterator(field)
    end
  end

  return setmetatable(self, self)
end

if _REQUIREDNAME == nil then
  Format = Format_
else
  _G[_REQUIREDNAME] = Format_
end
