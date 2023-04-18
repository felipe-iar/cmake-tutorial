# CMake functions for the IAR Build Tools

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

# Display the resource usage from the summary in the map file at executable POST_BUILD
function(iar_linker_summary TARGET)
  find_program(TAIL_COMMAND
               NAMES tail
               REQUIRED)
  get_target_property(target_type ${TARGET} TYPE)
  if (target_type STREQUAL "EXECUTABLE")
    add_custom_command(TARGET ${TARGET} POST_BUILD COMMAND ${CMAKE_COMMAND} -E echo "-------------------------------------------------")
    add_custom_command(TARGET ${TARGET} POST_BUILD COMMAND ${TAIL_COMMAND} -n6 $<TARGET_PROPERTY:NAME>.map)
    add_custom_command(TARGET ${TARGET} POST_BUILD COMMAND ${CMAKE_COMMAND} -E echo "-------------------------------------------------")
  else()
    add_custom_command(TARGET ${TARGET} POST_BUILD COMMAND ${CMAKE_COMMAND} -E echo "iar_summary: this option is only available for executable targets.")
  endif()
endfunction()
