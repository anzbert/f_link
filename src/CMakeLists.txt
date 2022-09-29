# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

# Build a library that includes the official C-Extension as a shared library called 'f_link'
project(link-with-c-extension)
set (LINK_DIR ./link)

add_library(f_link SHARED ${LINK_DIR}/extensions/abl_link/src/abl_link.cpp ${LINK_DIR}/extensions/abl_link/include/abl_link.h)

include(${LINK_DIR}/AbletonLinkConfig.cmake)
include(${LINK_DIR}/extensions/abl_link/abl_link.cmake)

target_link_libraries(f_link abl_link)

# not sure about this apple specific public_header ?!
set_target_properties(f_link PROPERTIES
  PUBLIC_HEADER f_link.h
  OUTPUT_NAME "f_link"
)

target_compile_definitions(f_link PUBLIC DART_SHARED_LIB)