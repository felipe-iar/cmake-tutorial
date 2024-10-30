# cstat.cmake
#   A simple CLI-driven implementation for IAR C-STAT support

# Arguments
## ARGV1 (optional): coding standard
# Function: iar_cstat()
# Syntax:
#   iar_cstat(<TARGET> [<coding-standard[,coding-standard,...]>]   
# Example:
#   include (./cstat.cmake)
#   iar_cstat(myTarget misrac2012)
#
function(iar_cstat TARGET)
  if (ARGC EQUAL 1)
    set(_stdgroups stdchecks)
  elseif(ARGC EQUAL 2)
    set(_stdgroups ${ARGV1})
  else()
    message(FATAL_ERROR "Invalid parameters for iar_cstat()")
  endif()

  # Get the path to the compiler
  cmake_path(GET CMAKE_C_COMPILER PARENT_PATH COMPILER_PATH)

  # Collect source files eligible for C-STAT analysis
  get_target_property(_src_dir ${TARGET} SOURCE_DIR)
  get_target_property(_srcs ${TARGET} SOURCES)
  list(FILTER _srcs INCLUDE REGEX ".*\.(c|cpp|cc|h|hpp)$")

  # Forward target definitions
  get_target_property(_defs ${TARGET} COMPILE_DEFINITIONS)
  if(_defs)
    foreach(_def IN LISTS _defs)
      list(APPEND _target_defs "-D${_def}")
    endforeach()
  endif()

  # Forward target header directories
  get_target_property(_hdrs ${TARGET} INCLUDE_DIRECTORIES)
  if(_hdrs)
    foreach(_hdr IN LISTS _hdrs)
      list(APPEND _target_hdrs "-I${_hdr}")
    endforeach()
  endif()

  # Forward target compiler options 
  get_target_property(_opts ${TARGET} COMPILE_OPTIONS)
  if(_opts)
    foreach(_opt IN LISTS _opts)
      list(APPEND _target_opts "${_opt}")
    endforeach()
  endif()

  # Create a custom target, prefixing the actual target name
  add_custom_target(cstat-${TARGET})

  # Create the C-STAT manifest file
  add_custom_command(TARGET cstat-${TARGET}
                     POST_BUILD
                     COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --yellow "-- Performing IAR C-STAT Static Analysis..."
                     COMMAND ${COMPILER_PATH}/ichecks --default ${_stdgroups} --output cstat-${TARGET}.manifest
                     BYPRODUCTS cstat-${TARGET}.manifest
                   )

  # Perform `icstat` on the target sources
  foreach(_src IN LISTS _srcs)
    add_custom_command(TARGET cstat-${TARGET}
                       POST_BUILD
                       COMMAND ${COMPILER_PATH}/icstat
                         --checks cstat-${TARGET}.manifest 
                         --db ${TARGET}.db
                         analyze -- ${CMAKE_C_COMPILER} ${_target_defs} ${_target_hdrs} ${_target_opts} ${_src_dir}/${_src})
  endforeach()
endfunction()
