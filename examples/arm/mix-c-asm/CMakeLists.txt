cmake_minimum_required(VERSION 3.22)

# Set the project name, [description] and [version],
project(Example1 LANGUAGES C ASM)

enable_testing()

# Add the executable for the "mix-c-asm" target
add_executable(mix-c-asm)

# Source files
target_sources(mix-c-asm PRIVATE
  main.c
  foo_asm.s )

# Set a preprocessor symbol, usable from "mix-c-asm" target
target_compile_definitions(mix-c-asm PRIVATE
  USE_ASM=1 )

# Set compile options for the target
target_compile_options(mix-c-asm PRIVATE
  $<$<COMPILE_LANGUAGE:C,CXX>:--dlib_config normal -e>
  $<$<COMPILE_LANGUAGE:C,CXX,ASM>:--cpu Cortex-M3> )

# Set the link options for the target
target_link_options(mix-c-asm PRIVATE
  --semihosting
  --map .
  --config ${TOOLKIT_DIR}/config/generic.icf )

# Optional: test the project with IAR C-SPY
iar_test_init()
iar_test_add(mix-c-asm testAnswer answer 42)
