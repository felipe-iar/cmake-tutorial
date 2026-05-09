cmake_minimum_required(VERSION 4.2)

project(Standards)

message(STATUS "Computed default: ${CMAKE_CXX_STANDARD_COMPUTED_DEFAULT}")

add_executable(app-cpp20 main.cpp)
set_target_properties(app-cpp20 PROPERTIES
  CXX_STANDARD_REQUIRED OFF
  CXX_STANDARD 20
  CXX_EXTENSIONS ON)
target_link_options(app-cpp20 PRIVATE --semihosting)


add_executable(app-cpp17 main.cpp)
set_target_properties(app-cpp17 PROPERTIES
  CXX_STANDARD_REQUIRED ON
  CXX_STANDARD 17
  CXX_EXTENSIONS ON)
target_link_options(app-cpp17 PRIVATE --semihosting)


add_executable(app-cpp14 main.cpp)
set_target_properties(app-cpp14 PROPERTIES
  CXX_STANDARD_REQUIRED OFF
  CXX_STANDARD 14
  CXX_EXTENSIONS ON)
target_link_options(app-cpp14 PRIVATE --semihosting)


add_executable(app-c11 main.c)
set_target_properties(app-c11 PROPERTIES
  C_STANDARD_REQUIRED OFF
  C_STANDARD 11
  C_EXTENSIONS ON)
target_link_options(app-c11 PRIVATE --semihosting)


add_executable(app-c90 main.c)
set_target_properties(app-c90 PROPERTIES
  C_STANDARD_REQUIRED OFF
  C_STANDARD 90
  C_EXTENSIONS ON)
target_link_options(app-c90 PRIVATE --semihosting)

