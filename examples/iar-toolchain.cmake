# Toolchain File for the IAR C/C++ Compiler

# Set CMake for cross-compiling
set(CMAKE_SYSTEM_NAME Generic)

# `TOOLKIT` variable
#  Used by find_program() for compiler detection.
#
#  When the installation can be found in a default install location, use the target architecture
#  - examples: arm (*default), riscv, rh850, rl78, rx, stm8, 430, 8051, avr or v850
#
#  For *custom* install locations, set it to the TOOLKIT_DIR for the target architecture
#  - example: 
#    - Tools installed at D:/IAR/ARM/9.40.1 needs to
#    - set(TOOLKIT "D:/IAR/ARM/9.40.1/arm")
set(TOOLKIT arm)

# Get the toolchain target from the TOOLKIT
get_filename_component(CMAKE_SYSTEM_PROCESSOR ${TOOLKIT} NAME)

# IAR C Compiler
find_program(CMAKE_C_COMPILER
  NAMES icc${CMAKE_SYSTEM_PROCESSOR}
  PATHS ${TOOLKIT}
        "$ENV{ProgramFiles}/IAR Systems/*"
        "$ENV{ProgramFiles\(x86\)}/IAR Systems/*"
        /opt/iarsystems/bx${CMAKE_SYSTEM_PROCESSOR}
  PATH_SUFFIXES bin ${CMAKE_SYSTEM_PROCESSOR}/bin
  REQUIRED )

# IAR C++ Compiler
find_program(CMAKE_CXX_COMPILER
  NAMES icc${CMAKE_SYSTEM_PROCESSOR}
  PATHS ${TOOLKIT}
        "$ENV{PROGRAMFILES}/IAR Systems/*"
        "$ENV{ProgramFiles\(x86\)}/IAR Systems/*"
        /opt/iarsystems/bx${CMAKE_SYSTEM_PROCESSOR}-
  PATH_SUFFIXES bin ${CMAKE_SYSTEM_PROCESSOR}/bin
  REQUIRED )

# IAR Assembler
find_program(CMAKE_ASM_COMPILER
  NAMES iasm${CMAKE_SYSTEM_PROCESSOR} a${CMAKE_SYSTEM_PROCESSOR}
  PATHS ${TOOLKIT}
        "$ENV{PROGRAMFILES}/IAR Systems/*"
        "$ENV{ProgramFiles\(x86\)}/IAR Systems/*"
        /opt/iarsystems/bx${CMAKE_SYSTEM_PROCESSOR}
  PATH_SUFFIXES bin ${CMAKE_SYSTEM_PROCESSOR}/bin
  REQUIRED )

# Avoids running the linker during try_compile()
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# Set the TOOLKIT_DIR variable for the CMakeLists
get_filename_component(BIN_DIR ${CMAKE_C_COMPILER} DIRECTORY)
get_filename_component(TOOLKIT_DIR ${BIN_DIR} PATH)
unset(BIN_DIR)
