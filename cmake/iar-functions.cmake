# IAR Functions
# These functions extend the CMake usability for use with the IAR Build Tools

include(iar-cspy-${CMAKE_SYSTEM_PROCESSOR})

# Convert the ELF output to .hex
function(iar_elf_tool_hex TARGET)
  add_custom_command(TARGET ${TARGET} POST_BUILD COMMAND ${CMAKE_IAR_ELFTOOL} --silent --ihex $<TARGET_FILE:${TARGET}> $<IF:$<BOOL:$<TARGET_PROPERTY:${TARGET},OUTPUT_NAME>>,$<TARGET_PROPERTY:${TARGET},OUTPUT_NAME>,$<TARGET_PROPERTY:${TARGET},NAME>>.hex)
endfunction()

# Convert the ELF output to .srec
function(iar_elf_tool_srec TARGET)
  add_custom_command(TARGET ${TARGET} POST_BUILD COMMAND ${CMAKE_IAR_ELFTOOL} --silent --srec $<TARGET_FILE:${TARGET}> $<IF:$<BOOL:$<TARGET_PROPERTY:${TARGET},OUTPUT_NAME>>,$<TARGET_PROPERTY:${TARGET},OUTPUT_NAME>,$<TARGET_PROPERTY:${TARGET},NAME>>.srec)
endfunction()

# Convert the ELF output to .bin
function(iar_elf_tool_bin TARGET)
  add_custom_command(TARGET ${TARGET} POST_BUILD COMMAND ${CMAKE_IAR_ELFTOOL} --silent --bin $<TARGET_FILE:${TARGET}> $<IF:$<BOOL:$<TARGET_PROPERTY:${TARGET},OUTPUT_NAME>>,$<TARGET_PROPERTY:${TARGET},OUTPUT_NAME>,$<TARGET_PROPERTY:${TARGET},NAME>>.bin)
endfunction()

# Provides an additional checkpoint
# with a message regarding the compiler license
# Typically used from the toolchain file
function(iar_check_license)
  if(NOT LICENSE_CHECKED_YET)
    execute_process(COMMAND ${CMAKE_C_COMPILER} --version
                    OUTPUT_QUIET
                    RESULT_VARIABLE ret)
    if(NOT ret EQUAL 0)
      message(FATAL_ERROR "FATAL ERROR:Found the IAR compiler but failed to execute.\n*** Check your compiler license ***\n")
    endif()
    unset(ret)
    set(LICENSE_CHECKED_YET 1)
  endif()
endfunction()

# Provides a fallback option for CMAKE_MAKE_PROGRAM
# for Ninja users on {EW|BX}ARM v9+
function(iar_find_ninja)
  if(CMAKE_GENERATOR MATCHES "^Ninja.*$")
    find_program(CMAKE_MAKE_PROGRAM
      NAMES ninja ninja.exe
      PATHS $ENV{PATH}
            ${COMMON_DIR}
      PATH_SUFFIXES bin
      REQUIRED)
  endif()
endfunction()
