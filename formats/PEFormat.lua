local parse = function(stream)
  local f = Format.new(stream)
  f:Get(Typedef.char[2], "e_magic")
  local magic = f:Value(1)
  assert(magic.value[1] == 77 and magic.value[2] == 90,
         "Invalid PE file magic.")

  f:Get(Typedef.ushort, "e_cblp")
  f:Get(Typedef.ushort, "e_cp")
  f:Get(Typedef.ushort, "e_crlc")
  f:Get(Typedef.ushort, "e_cparhdr")
  f:Get(Typedef.ushort, "e_minalloc")
  f:Get(Typedef.ushort, "e_maxalloc")
  f:Get(Typedef.ushort, "e_ss")
  f:Get(Typedef.ushort, "e_sp")
  f:Get(Typedef.ushort, "e_csum")
  f:Get(Typedef.ushort, "e_ip")
  f:Get(Typedef.ushort, "e_cs")
  f:Get(Typedef.ushort, "e_lfarlc")
  f:Get(Typedef.ushort, "e_ovno")
  f:Get(Typedef.ushort[4], "e_res1")
  f:Get(Typedef.ushort, "e_oemid")
  f:Get(Typedef.ushort, "e_oeminfo")
  f:Get(Typedef.ushort[10], "e_res2")
  f:Get(Typedef.ulong, "e_lfanew")
  --! TODO: finish format
  return f
end

return parse
