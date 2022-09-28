# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(f_link_library VERSION 0.0.1 LANGUAGES C)

add_library(f_link SHARED
  "f_link.c"
)

set_target_properties(f_link PROPERTIES
  PUBLIC_HEADER f_link.h
  OUTPUT_NAME "f_link"
)

target_compile_definitions(f_link PUBLIC DART_SHARED_LIB)
