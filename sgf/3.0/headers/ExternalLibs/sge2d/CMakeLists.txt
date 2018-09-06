# -------------------------------------------------------
# util cmake build script for sgffabric.
# Written by: Salvatore
# Modified by: Salvatore
# -------------------------------------------------------

# -------------------------------------------------------
# Source directories containing all the necessary .cpp files
# -------------------------------------------------------
set(SGE_SRC
src/sge_bm_text.cpp
src/sgearray.c
src/sgegfx.c
src/sgeresource.c
src/sgesprite.c
src/sgespriteimage.c
)

# -------------------------------------------------------
# Include directory
# -------------------------------------------------------

# -------------------------------------------------------
# module
# -------------------------------------------------------
#add_library (sge_module ${SGE_SRC})
