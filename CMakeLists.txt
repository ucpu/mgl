cmake_minimum_required(VERSION 3.31)
project(MGL LANGUAGES C CXX OBJC)

execute_process(COMMAND "python3" "update_glslang_sources.py" WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/external/glslang" COMMAND_ECHO STDOUT)

set(CMAKE_SKIP_INSTALL_RULES TRUE) # disable installs
set(CMAKE_POLICY_VERSION_MINIMUM 3.31) # override cmake minimum version for dependencies
set(CMAKE_C_STANDARD 17)
set(CMAKE_CXX_STANDARD 20)
set(SPIRV_CROSS_CLI OFF CACHE INTERNAL "Build the CLI binary. Requires SPIRV_CROSS_STATIC.")
set(SPIRV_CROSS_ENABLE_TESTS OFF CACHE INTERNAL "Enable SPIRV-Cross tests.")
set(SPIRV_CROSS_SKIP_INSTALL ON CACHE INTERNAL "Skips installation targets.")
set(ENABLE_OPT ON CACHE INTERNAL "use spirv-tools inside glslang")

add_subdirectory(external/SPIRV-Cross)
add_subdirectory(external/glslang)
add_subdirectory(external/glfw)

file(GLOB_RECURSE MGL_SOURCES
	MGL/spirv_cross_c.cpp
	MGL/src/*.c
	MGL/src/*.cpp
	MGL/src/*.m
)
add_library(mgl_static STATIC ${MGL_SOURCES})
target_include_directories(mgl_static PUBLIC 
	MGL/SPIRV/SPIRV-Cross
	MGL/include
	MGL/include/GL
	external/SPIRV-Cross
	external/glslang/External/spirv-tools/include
	external/glslang/SPIRV
	external/glslang/glslang/Include
	external/glslang/glslang/Public
)
target_link_libraries(mgl_static PUBLIC
	glslang
	glslang-default-resource-limits
	spirv-cross-core
	spirv-cross-cpp
	spirv-cross-glsl
	spirv-cross-hlsl
	spirv-cross-msl
	spirv-cross-reflect
	spirv-cross-util
)
target_link_libraries(mgl_static PUBLIC
	"-framework AppKit"
	"-framework Cocoa"
	"-framework CoreFoundation"
	"-framework Foundation"
	"-framework IOKit"
	"-framework Metal"
	"-framework OpenGL"
	"-framework QuartzCore"
)

target_link_libraries(glfw PUBLIC mgl_static)

option(MGL_BUILD_TEST "Build mgl_test" OFF)
if(MGL_BUILD_TEST)
	add_executable(mgl_test mgl_test.cpp)
	target_link_libraries(mgl_test mgl_static glfw)
endif()
