# Collect all .cpp and .h files in this directory (non-recursive)
file(GLOB SRC_FILES "${CMAKE_CURRENT_SOURCE_DIR}/*.cpp" 
                   "${CMAKE_CURRENT_SOURCE_DIR}/*.c")
file(GLOB HDR_FILES "${CMAKE_CURRENT_SOURCE_DIR}/*.h"
                   "${CMAKE_CURRENT_SOURCE_DIR}/*.hpp")

add_executable(myapp ${SRC_FILES} ${HDR_FILES})
