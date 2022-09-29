# This CMakeLists.txt is invoked by the Windows and Linux builds. Android has its own build instructions at 'android/CMakeLists.txt'

# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

# Build a library that includes the official C-Extension as a shared library called 'abl_link'
project(abl_link_library)
set (LINK_DIR ${CMAKE_CURRENT_LIST_DIR}/link)

# For abl_link:
add_library(abl_link SHARED ${LINK_DIR}/extensions/abl_link/src/abl_link.cpp ${LINK_DIR}/extensions/abl_link/include/abl_link.h)
include(${LINK_DIR}/AbletonLinkConfig.cmake)
target_include_directories(abl_link PUBLIC ${LINK_DIR}/extensions/abl_link/include)
set_property(TARGET abl_link PROPERTY C_STANDARD 11)
target_link_libraries(abl_link Ableton::Link)

# Flutter specific:
target_compile_definitions(abl_link PUBLIC DART_SHARED_LIB)

# not sure about this apple specific public_header ?!
set_target_properties(abl_link PROPERTIES
  PUBLIC_HEADER abl_link.h
  OUTPUT_NAME "abl_link"
)
