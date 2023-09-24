# Example for creating a test for CTest 
# to execute the `IAR C-SPY Command-line Utility (cspybat.exe)`

function(iar_test_init)
  include(CTest)
  message(STATUS "Enabling IAR C-SPY tests - done")
endfunction()

function(iar_test_add TARGET TEST_NAME TEST_VAR TEST_EXPECTED)
  if (BUILD_TESTING)
    find_program(CSPY_BAT
      NAMES cspybat CSpyBat
      PATHS ${COMMON_DIR}
      PATH_SUFFIXES bin)
  
    find_file(LIB_PROC
      NAMES ${CMAKE_SYSTEM_PROCESSOR}proc.dll
            lib${CMAKE_SYSTEM_PROCESSOR}PROC.so
      PATHS ${TOOLKIT_DIR}
      PATH_SUFFIXES bin)
  
    find_file(LIB_SIM
      NAMES ${CMAKE_SYSTEM_PROCESSOR}sim2.dll
            lib${CMAKE_SYSTEM_PROCESSOR}SIM2.so
      PATHS ${TOOLKIT_DIR}
      PATH_SUFFIXES bin)
  
    find_file(LIB_BAT
      NAMES ${CMAKE_SYSTEM_PROCESSOR}bat.dll
            lib${CMAKE_SYSTEM_PROCESSOR}Bat.so
      PATHS ${TOOLKIT_DIR}
      PATH_SUFFIXES bin)
  
    # Add a test for CTest
    add_test(NAME ${TEST_NAME}
             COMMAND ${CSPY_BAT} --silent
             # C-SPY drivers for the Arm simulator via command line interface
             ${LIB_PROC}
             ${LIB_SIM}
             --plugin=${LIB_BAT}
             --debug_file=$<TARGET_FILE:${TARGET}>
             $<IF:$<BOOL:$<TARGET_PROPERTY:${TARGET},DMAC>>,--device_macro=$<TARGET_PROPERTY:${TARGET},DMAC>,>
             # C-SPY macros settings
             "--macro=${CMAKE_MODULE_PATH}/iar-cspy-test.mac"
             "--macro_param=testVar=\"${TEST_VAR}\""
             "--macro_param=testExpected=${TEST_EXPECTED}"
             # C-SPY driver options
             --backend
             --cpu=$<IF:$<BOOL:$<TARGET_PROPERTY:${TARGET},CPU>>,$<TARGET_PROPERTY:${TARGET},CPU>,Cortex-M3>
             --fpu=$<IF:$<BOOL:$<TARGET_PROPERTY:${TARGET},FPU>>,$<TARGET_PROPERTY:${TARGET},FPU>,None>
             $<IF:$<BOOL:$<TARGET_PROPERTY:${TARGET},DEVICE>>,--device=$<TARGET_PROPERTY:${TARGET},DEVICE>,>
             --semihosting
             --endian=little
             $<IF:$<BOOL:$<TARGET_PROPERTY:${TARGET},DDF>>,-p,>
             $<IF:$<BOOL:$<TARGET_PROPERTY:${TARGET},DDF>>,$<TARGET_PROPERTY:${TARGET},DDF>,> )
  
    # Set test condition to pass
    set_tests_properties(${TEST_NAME} PROPERTIES PASS_REGULAR_EXPRESSION "Got: ${TEST_EXPECTED}")
  else()
    message(STATUS "iar_add_test(): ${TEST_NAME} was added to the project\n   however iar_test_init() was not initialized once\n")
    return()
  endif()
endfunction()
