cmake_minimum_required(VERSION 3.20)

# TODO 1: enable C-STAT
#option(USE_CSTAT "Use C-STAT" ON)

set(CMAKE_C_CPPCHECK /opt/iarsystems/bxarm/arm/bin/icstat)

project(C-STAT LANGUAGES C)

add_executable(c-stat)

target_sources(c-stat PRIVATE 
  c-stat1.c
  c-stat2.c
)

target_compile_options(c-stat PRIVATE
  --no_wrap_diagnostics
)

target_link_options(c-stat PRIVATE
  --semihosting
)

# TODO 2: include the `c-stat.cmake` module to the project
#include(./c-stat.cmake)
