# CMake References: https://github.com/Lectem/cpp-boilerplate/blob/master/CMakeLists.txt

cmake_minimum_required(VERSION 3.17)

project(cpp-example
    VERSION 0.1.0
    LANGUAGES  CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
# check if build type is debug, if so add compile options
if (CMAKE_BUILD_TYPE STREQUAL "Debug")
  message(STATUS "Debug build")
  add_compile_options(
    $<$<CXX_COMPILER_ID:GNU,Clang>:-g>
    $<$<CXX_COMPILER_ID:GNU,Clang>:-O0>
    $<$<CXX_COMPILER_ID:GNU,Clang>:-fno-inline>
    $<$<CXX_COMPILER_ID:GNU,Clang>:-fno-omit-frame-pointer>
  )
endif()

set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE INTERNAL "")
if(CMAKE_EXPORT_COMPILE_COMMANDS)
  set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES 
      ${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES})
endif()


add_subdirectory(src)

