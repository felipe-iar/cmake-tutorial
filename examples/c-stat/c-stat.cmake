#
# Copyright (C) 2024 IAR Systems AB
#

macro(get_all_targets_recursive targets dir)
    get_property(subdirectories DIRECTORY ${dir} PROPERTY SUBDIRECTORIES)
    foreach(subdir ${subdirectories})
        get_all_targets_recursive(${targets} ${subdir})
    endforeach()

    get_property(current_targets DIRECTORY ${dir} PROPERTY BUILDSYSTEM_TARGETS)
    list(APPEND ${targets} ${current_targets})
endmacro()

function(get_all_targets var)
    set(targets)
    get_all_targets_recursive(targets ${CMAKE_CURRENT_SOURCE_DIR})
    set(${var} ${targets} PARENT_SCOPE)
endfunction()

function(analyze TARGET)
  set(CSTAT_DB "${CMAKE_BINARY_DIR}/${TARGET}.db")
  set(CHECKS "${CMAKE_BINARY_DIR}/${TARGET}.checks")
  get_target_property(sources ${TARGET} SOURCES)
  get_target_property(compile_options ${TARGET} COMPILE_OPTIONS)
  get_target_property(compile_definitions ${TARGET} COMPILE_DEFINITIONS)
  get_target_property(link_options ${TARGET} LINK_OPTIONS)
  get_target_property(target_type ${TARGET} TYPE)

  get_filename_component(BIN_DIR ${CMAKE_C_COMPILER} DIRECTORY)
  find_program(ICSTAT 
    NAMES icstat icstat.exe
    PATHS ${BIN_DIR}
  )
  find_program(ICHECKS
    NAMES ichecks ichecks.exe
    PATHS ${BIN_DIR}
  )

  execute_process(
    COMMAND ${ICHECKS} --package stdchecks --output ${CHECKS}
  )

  if (${compile_definitions} STREQUAL "compile_definitions-NOTFOUND")
    set(compile_definitions "")
  endif()

  foreach(source IN ITEMS ${sources})
    add_custom_command(
      TARGET ${TARGET}
      COMMAND ${ICSTAT} --db ${CSTAT_DB} --checks ${CHECKS} analyze -- ${CMAKE_C_COMPILER} ${compile_options} ${compile_definitions} ${CMAKE_CURRENT_SOURCE_DIR}/${source}
      DEPENDS ${TARGET}
      POST_BUILD
      COMMENT "Analyzing ${source}..."
    )
  endforeach()
  if(target_type STREQUAL "EXECUTABLE")
    foreach(obj IN LISTS $<TARGET_OBJECTS:${TARGET}>)
      message(STATUS "obj: ${obj}")
      string(APPEND target_objects "${obj} ")
    endforeach()
    add_custom_command(
      TARGET ${TARGET}
      COMMAND ${ICSTAT} --db ${CSTAT_DB} --checks ${CHECKS} link_analyze -- ${LINKER} ${link_options} ${target_objects} -o $<TARGET_FILE:${TARGET}>
      DEPENDS ${TARGET}
      POST_BUILD
      COMMENT "Link-analyzing..."
    )
  endif()
  message(STATUS "linker is: ${LINKER}" )
endfunction()

if(USE_CSTAT)
  get_all_targets(all_targets)
  foreach(tgt IN ITEMS ${all_targets})
    analyze(${tgt})
  endforeach()
endif()
