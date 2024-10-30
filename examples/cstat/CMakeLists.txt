cmake_minimum_required(VERSION 3.20)

project(analysis C ASM)

add_executable(analysis)

target_sources(analysis PRIVATE
  delay.s
  stack.c
  main.c
)

target_compile_definitions(analysis PRIVATE
  A=1
  B=2
)

target_include_directories(analysis PRIVATE
  inc
)

target_compile_options(analysis PRIVATE
  --cpu=cortex-m4
)

target_link_options(analysis PRIVATE
  --cpu=cortex-m4
  --semihosting
)

include(./cstat.cmake)
iar_cstat(analysis misrac2012)
