# -------------------------------------------------------
# cmake build script for sgffabric.
# Written by: Salvatore
# -------------------------------------------------------

# -------------------------------------------------------
# MSVC FLAGS
# -------------------------------------------------------
#if(NOT MSVC)
#    set(CFLAGS "-W -O2 -Wwrite-strings -Wstrict-prototypes -Wall -funroll-loops -Wmissing-declarations -fomit-frame-pointer -Wno-missing-declarations")
#else(NOT MSVC)
#	set(CFLAGS "-O2")
#endif(NOT MSVC)
#
#remove_definitions(${CXXFLAGS})
#add_definitions(${CFLAGS} -DLOAD_PNG -DLOAD_PCX -DLOAD_GIF)

# -------------------------------------------------------
# Source directories containing all the necessary .cpp files
# -------------------------------------------------------
set(SDLMIXER_SRC
music.c
mixer.c
music_ogg.c
music_flac.c
music_mad.c
dynamic_ogg.c
effect_position.c
effects_internal.c
effect_stereoreverse.c
load_voc.c
load_ogg.c
load_aiff.c
wavestream.c
fluidsynth.c
load_flac.c
music_cmd.c
music_mod.c
music_modplug.c
)

# -------------------------------------------------------
# Include directory
# -------------------------------------------------------
include_directories(include ./)

# -------------------------------------------------------
# module
# -------------------------------------------------------
#add_library (sdlmixer_module ${SDLMIXER_SRC})

# -------------------------------------------------------
#add_excutable (playmus.c )
#add_excutable (playwave.c)

