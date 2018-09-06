# -------------------------------------------------------
# util cmake build script for sgffabric.
# Written by: Salvatore
# -------------------------------------------------------

# -------------------------------------------------------
# Source directories containing all the necessary .cpp files
# -------------------------------------------------------
set(7ZIP_SRC
7zAlloc.c
7zBuf.c
7zBuf2.c
7zCrc.c
7zCrcOpt.c
7zDec.c
7zIn.c
CpuArch.c
LzmaDec.c
Lzma2Dec.c
Bra.c
Bra86.c
Bcj2.c
7zFile.c
7zStream.c)

# -------------------------------------------------------
# Include directory
# -------------------------------------------------------

# -------------------------------------------------------
# module
# -------------------------------------------------------
#add_library (7zip_module ${7ZIP_SRC})
