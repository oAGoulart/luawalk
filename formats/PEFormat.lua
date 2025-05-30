local parse = function(stream)
  local f = Format.new(stream)
  f:Get(Typedef.char[2], "e_magic")
  assert(f.e_magic.value[1] == 77 and f.e_magic.value[2] == 90,
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
  local SIZEOF_DOSHEADER = 64

  f:Jump(f.e_lfanew.value)
  f:Get(Typedef.char[4], "Signature")
  assert(f.Signature.value[1] == 80 and f.Signature.value[2] == 69 and
         f.Signature.value[3] == 0 and f.Signature.value[4] == 0,
         "Invalid file header signature.")
  --! TODO: finish format
  return f
end

return parse
