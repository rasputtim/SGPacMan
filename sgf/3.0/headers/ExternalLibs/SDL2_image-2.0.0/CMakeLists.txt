# -------------------------------------------------------
# util cmake build script for sgffabric.
# Written by: Salvatore
# Modified by: Salvatore
# -------------------------------------------------------


# -------------------------------------------------------
# MSVC FLAGS
# -------------------------------------------------------
if(NOT MSVC)
	set(CFLAGS "-W -O2 -Wwrite-strings -Wstrict-prototypes -Wall -funroll-loops -Wmissing-declarations -fomit-frame-pointer -Wno-missing-declarations")
else(NOT MSVC)
	set(CFLAGS "-O2")
endif(NOT MSVC)


#remove_definitions(${CXXFLAGS})
#add_definitions(${CFLAGS} -DLOAD_PNG -DLOAD_PCX -DLOAD_GIF)

# -------------------------------------------------------
# Source directories containing all the necessary .cpp files
# -------------------------------------------------------
set(SDLIMAGE_SRC
IMG.c
IMG_bmp.c
IMG_gif.c
IMG_jpg.c
IMG_lbm.c
IMG_pcx.c
IMG_png.c
IMG_pnm.c
IMG_tga.c
IMG_tif.c
IMG_webp.c
IMG_xcf.c
IMG_xpm.c
IMG_xv.c
IMG_xxx.c)

# -------------------------------------------------------
# Include directory
# -------------------------------------------------------

# -------------------------------------------------------
# module
# -------------------------------------------------------
#add_library (sdlimage_module ${SDLIMAGE_SRC})
