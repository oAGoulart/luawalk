local parse = function(stream)
  local f = Format.new(stream)
  f:Get(Typedef.char[2], "e_magic")
  f:Get(Typedef.ushort, "e_cblp")
  f:Get(Typedef.ushort, "e_cp")
  stream:Move(#Typedef.ushort)
  f:Get(Typedef.ushort, "e_cparhdr")
  --! TODO: finish format
  return f
end

return parse
