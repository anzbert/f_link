# The Flutter tooling requires that developers have a version of Visual Studio
# installed that includes CMake 3.14 or later. You should not increase this
# version, as doing so will cause the plugin to fail to compile for some
# customers of the plugin.
cmake_minimum_required(VERSION 3.14)

# Project-level configuration.
set(PROJECT_NAME "f_link")
project(${PROJECT_NAME} LANGUAGES CXX)

# Make symbols discoverable when compiled on windows
set (CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS 1) 

# Invoke the build for native code shared with the other target platforms.
# This can be changed to accomodate different builds.
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/../src" "${CMAKE_CURRENT_BINARY_DIR}/shared")

# List of absolute paths to libraries that should be bundled with the plugin.
# This list could contain prebuilt libraries, or libraries created by an
# external build triggered from this build file.
set(f_link_bundled_libraries
  # Defined in ../src/CMakeLists.txt.
  # This can be changed to accomodate different builds.
  $<TARGET_FILE:abl_link>
  PARENT_SCOPE
)


