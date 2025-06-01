assert(_G._VERSION == "Lua 5.4")

local Stream_ = {}
Stream_.new = function(source)
  local self = {}

  local file_ = nil
  if type(source) == "string" then
    if string.match(source, "[\\/]") ~= nil then
      self.file_ = assert(io.open(source, "r+b"))
    else
      local path = os.tmpname()
      self.file_ = assert(io.open(path, "r+b"))
      self.file_:write(source)
      self.file_:seek("set", 0)
    end
  elseif io.type(source) == "file" then
    self.file_ = source
  else
    error("Stream source is neither a string nor a file", 2)
  end

  function self:Index()
    return self.file_:seek()
  end

  function self:Size()
    return self.file_:seek("end")
  end

  function self:Move(offset)
    return self.file_:seek("cur", offset)
  end

  function self:Seek(whence, offset)
    return self.file_:seek(whence, offset)
  end

  function self:Read(typedef)
    if typedef.size == nil then
      local t = {}
      while true do
        local c = assert(self.file_:read(1))
        if c == "\x00" then break end
        table.insert(t, c)
      end
      return table.concat(t)
    end
    if typedef.count > 1 then
      local t = {}
      for i = 1, typedef.count, 1 do
        local v = assert(self.file_:read(typedef.size))
        t[i] = string.unpack(typedef.fmt, v)
      end
      return t
    end
    local v = assert(self.file_:read(typedef.size))
    return string.unpack(typedef.fmt, v)
  end

  function self:Write(value)
    if type(value) == "number" or type(value) == "string" then
      self.file_:write(value)
    elseif type(value) == "table" then
      for _, v in ipairs(value) do
        self:Write(v)
      end
    else
      error("Cannot write this value type to stream", 2)
    end
  end

  function self:__gc()
    self.file_:close()
  end

  return setmetatable(self, self)
end

if _REQUIREDNAME == nil then
  Stream = Stream_
else
  _G[_REQUIREDNAME] = Stream_
end
