cmake_minimum_required(VERSION 3.20)

project(analysis)

add_executable(analysis)

target_sources(analysis PRIVATE
  main.c
  stack.c
)

target_compile_definitions(analysis PRIVATE
  A=1
  B=2
  C=3
)

target_compile_options(analysis PRIVATE
  --cpu=cortex-m4
  --no_wrap_diagnostics
)


target_link_options(analysis PRIVATE
  --cpu=cortex-m4
  --semihosting
)

include(./cstat.cmake)
iar_cstat(analysis misrac2012)
