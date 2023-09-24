# The top-level CMakeLists.txt add this subdirectory
# This CMakeLists.txt builds the target "mathLib" library
add_library(mathLib STATIC)

target_sources(mathLib PRIVATE
  add.c
  sub.c
  mul.c )

# Set the compiler flags for the library 
target_compile_options(mathLib PRIVATE 
  $<$<COMPILE_LANGUAGE:C>:-Oh
                          --cpu Cortex-M4
                          --dlib_config normal> )

# Define headers for the target
# PUBLIC headers are used for building the library
# PRIVATE sources, only used in this target
target_include_directories(mathLib PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/.> )
