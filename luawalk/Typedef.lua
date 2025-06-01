assert(_G._VERSION == "Lua 5.4")

local Typedef_ = {}
Typedef_.new = function(fmt, size, name, count)
  assert(name)
  local self = {}

  self.fmt = fmt or ("c" .. size)
  self.size = size
  self.name = name
  self.count = count or 1

  function self:__index(key)
    if math.type(key) == "integer" then
      return Typedef_.new(
        self.fmt,
        self.size,
        self.name .. "[" .. key .. "]",
        key)
    end
    return rawget(self, key)
  end

  function self:__len()
    return self.size * self.count
  end

  return setmetatable(self, self)
end

Typedef_.char = Typedef_.new("b", 1, "char")
Typedef_.ubyte = Typedef_.new("I1", 1, "ubyte")
Typedef_.byte = Typedef_.new("i1", 1, "byte")
Typedef_.ushort = Typedef_.new("<I2", 2, "ushort")
Typedef_.short = Typedef_.new("<i2", 2, "short")
Typedef_.ulong = Typedef_.new("<I4", 4, "ulong")
Typedef_.long = Typedef_.new("<i4", 4, "long")
Typedef_.uquad = Typedef_.new("<I8", 8, "uquad")
Typedef_.quad = Typedef_.new("<i8", 8, "quad")
Typedef_.float = Typedef_.new("<f", 4, "float")
Typedef_.double = Typedef_.new("<d", 8, "double")
Typedef_.cstr = Typedef_.new("z", nil, "cstr")

if _REQUIREDNAME == nil then
  Typedef = Typedef_
else
  _G[_REQUIREDNAME] = Typedef_
end
