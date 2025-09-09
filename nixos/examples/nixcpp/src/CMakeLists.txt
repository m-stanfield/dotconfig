# src/CMakeLists.txt

# executable
add_executable(main)
target_sources(main PRIVATE main.cpp)

# simple library
add_library(simple STATIC)  # or omit STATIC to use default
target_sources(simple
  PRIVATE simple.cpp
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/simple.h>
    $<INSTALL_INTERFACE:include/src/simple.h>
)
target_include_directories(simple
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}>
    $<INSTALL_INTERFACE:include>
)

# importtest library
add_library(importtest STATIC)
target_sources(importtest
  PRIVATE importtest.cpp
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/importtest.h>
    $<INSTALL_INTERFACE:include/src/importtest.h>
)
target_include_directories(importtest
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}>
    $<INSTALL_INTERFACE:include>
)

# link libraries to the executable
target_link_libraries(main PRIVATE simple importtest)

# make sure main can see headers from src/
target_include_directories(main PRIVATE ${CMAKE_CURRENT_LIST_DIR})
