local Stream_ = {}
Stream_.new = function(source)
  local self = {}

  local file_ = nil
  if type(source) == "string" then
    if string.match(source, "[\\/]") ~= nil then
      file_ = assert(io.open(source, "r+b"))
    else
      local path = os.tmpname()
      file_ = assert(io.open(path, "r+b"))
      file_:write(source)
      file_:seek("set", 0)
    end
  elseif io.type(source) == "file" then
    file_ = source
  else
    error("Stream source is neither a string nor a file", 2)
  end

  function self:Index()
    return file_:seek()
  end

  function self:Size()
    return file_:seek("end")
  end

  function self:Move(offset)
    return file_:seek("cur", offset)
  end

  function self:Seek(whence, offset)
    return file_:seek(whence, offset)
  end

  function self:Read(typedef)
    if typedef.size == nil then
      local t = {}
      while true do
        local c = assert(file_:read(1))
        if c == "\x00" then break end
        table.insert(t, c)
      end
      return table.concat(t)
    end
    if typedef.count > 1 then
      local t = {}
      for i = 1, typedef.count, 1 do
        local v = assert(file_:read(typedef.size))
        t[i] = string.unpack(typedef.fmt, v)
      end
      return t
    end
    local v = assert(file_:read(typedef.size))
    return string.unpack(typedef.fmt, v)
  end

  function self:Write(value)
    if type(value) == "number" or type(value) == "string" then
      file_:write(value)
    elseif type(value) == "table" then
      for _, v in ipairs(value) do
        self:Write(v)
      end
    else
      error("Cannot write this value type to stream", 2)
    end
  end

  function self:__gc()
    file_:close()
  end

  return setmetatable(self, self)
end

if _REQUIREDNAME == nil then
  Stream = Stream_
else
  _G[_REQUIREDNAME] = Stream_
end
