# Add the executable target,
add_executable (using-libs)

target_sources(using-libs PRIVATE
  main.c )

# Set the properties for the "using-libs" target
set_target_properties(using-libs PROPERTIES
  DEVICE        STM32F407VG
  CPU           Cortex-M4
  FPU           VFPv4_sp
  ICF           "${TOOLKIT_DIR}/config/linker/ST/stm32f407xG.icf"
  # C-SPY-related properties
  DDF           "${TOOLKIT_DIR}/config/debugger/ST/STM32F407VG.ddf"
  DMAC          "${TOOLKIT_DIR}/config/debugger/ST/STM32F4xx.dmac" )

# Set compile options for the target
target_compile_options(using-libs PRIVATE
  $<$<COMPILE_LANGUAGE:C,CXX>:--dlib_config normal>
  --cpu $<TARGET_PROPERTY:CPU> --fpu $<TARGET_PROPERTY:FPU> )

# Set the link options for the target
target_link_options(using-libs PRIVATE
  # Genex evaluates if we are using the `Debug` configuration
  $<$<CONFIG:Debug>:--semihosting --redirect ___write=___write_buffered>
  # Create a map file from the target's ELF
  --map $<TARGET_PROPERTY:NAME>.map
  # Set the linker script
  --config $<TARGET_PROPERTY:ICF> )

# Link "using-libs" against the "myMath" library
target_link_libraries(using-libs LINK_PUBLIC mathLib)

# Optional: convert the output to .hex format
iar_elf_tool_hex(using-libs)

# Optional: test the project with CTest and IAR C-SPY
iar_test_init()
iar_test_add(using-libs testAdd addResult 42)
iar_test_add(using-libs testSub subResult 38)
iar_test_add(using-libs testMul mulResult 80)

