# -------------------------------------------------------
# cmake build script for sgffabric.
# Written by: Salvatore
# -------------------------------------------------------

# -------------------------------------------------------
# Source directories containing all the necessary .cpp files
# -------------------------------------------------------
set(TIMIDITY_SRC
common.c
ctrlmode.c
filter.c
instrum.c
mix.c
output.c
playmidi.c
readmidi.c
resample.c
sdl_a.c
sdl_c.c
tables.c
timidity.c
)


# -------------------------------------------------------
# module
# -------------------------------------------------------
#add_library (timidity_module ${TIMIDITY_SRC})

# -------------------------------------------------------
#add_excutable (playmus.c )
#add_excutable (playwave.c)

