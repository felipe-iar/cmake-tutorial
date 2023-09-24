# CMake requires to set its minimum required version
cmake_minimum_required(VERSION 3.20)

# Set the project name and version
project(simpleProject VERSION 1.0)

# Add a executable target named "hello-world"
add_executable(hello-world)

# Add target sources
target_sources(hello-world PRIVATE main.c)
   
# Set the target's compiler options
target_compile_options(hello-world PRIVATE --cpu=Cortex-M4 --fpu=VFPv4_sp --dlib_config normal)   
   
# Set the target's linker options
target_link_options(hello-world PRIVATE --semihosting --config ${TOOLKIT_DIR}/config/linker/ST/stm32f407xG.icf)

