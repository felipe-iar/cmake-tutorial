# cstat.cmake
##  Implements simple command-line CMake suppport for IAR C-STAT
##  Example:
###   include(./cmake.cmake)
###   iar_cstat(<TARGET> [<coding-standard[,coding-standard,...]>]   

# Arguments
## ARGV1 (optional): coding standard
function(iar_cstat TARGET)
  if (ARGC EQUAL 1)
    set(_stdgroups stdchecks)
  elseif(ARGC EQUAL 2)
    set(_stdgroups ${ARGV1})
  else()
    message(FATAL_ERROR "Invalid parameters for iar_cstat()")
  endif()
  cmake_path(GET CMAKE_C_COMPILER PARENT_PATH COMPILER_PATH)

  get_target_property(_srcs ${TARGET} SOURCES)
  get_target_property(_src_dir ${TARGET} SOURCE_DIR)

  get_target_property(_defs ${TARGET} COMPILE_DEFINITIONS)
  foreach(_def IN LISTS _defs)
    string(APPEND _compiler_defs "-D${_def} ")
  endforeach()

  get_target_property(_opts ${TARGET} COMPILE_OPTIONS)
  foreach(_opt IN LISTS _opts)
    string(APPEND _compiler_opts "${_opt} ")
  endforeach()

  add_custom_target(cstat-${TARGET}
  )
  #   DEPENDS ${TARGET})

  add_custom_command(TARGET cstat-${TARGET}
                     POST_BUILD
                     COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --yellow "-- Performing IAR C-STAT Static Analysis..."
                     COMMAND ichecks --default ${_stdgroups} --output cstat-${TARGET}.manifest
                     BYPRODUCTS cstat-${TARGET}.manifest
                   )

  foreach(_src IN LISTS _srcs)
    add_custom_command(TARGET cstat-${TARGET}
                       POST_BUILD
                       COMMAND ${COMPILER_PATH}/icstat
                         --checks cstat-${TARGET}.manifest 
                         --db ${TARGET}.db
                         analyze -- ${CMAKE_C_COMPILER} ${_compiler_defs}${_compiler_opts} ${_src_dir}/${_src})
  endforeach()
endfunction()
