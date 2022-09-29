cmake_minimum_required(VERSION 3.14)

# Project-level configuration.
set(PROJECT_NAME "f_link")
project(${PROJECT_NAME} LANGUAGES CXX)

set (LINK_DIR ../src/link)

add_library(abl_link SHARED ${LINK_DIR}/extensions/abl_link/src/abl_link.cpp)

include(${LINK_DIR}/AbletonLinkConfig.cmake)
target_include_directories(abl_link PUBLIC ${LINK_DIR}/extensions/abl_link/include)
set_property(TARGET abl_link PROPERTY C_STANDARD 11)

# /// Android specific:
target_compile_definitions(abl_link PRIVATE ANDROID=1 LINK_PLATFORM_LINUX=1 PD=1 ABL_LINK_OFFSET_MS=23)
if(CMAKE_SYSTEM_NAME MATCHES "Linux|kFreeBSD|GNU")
  target_link_libraries(abl_link atomic pthread)
endif()
# ///

target_compile_definitions(abl_link PUBLIC DART_SHARED_LIB)
target_link_libraries(abl_link Ableton::Link)