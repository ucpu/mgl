cmake_minimum_required(VERSION 3.15)
project(MGL LANGUAGES C CXX OBJC)

execute_process(COMMAND "bash" "clone_external.sh" WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/external" COMMAND_ECHO STDOUT)
execute_process(COMMAND "bash" "build_external.sh" WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/external" COMMAND_ECHO STDOUT)

set(CMAKE_C_STANDARD 17)
set(CMAKE_CXX_STANDARD 20)

# Include paths
include_directories(
	MGL/SPIRV/SPIRV-Cross
	MGL/include
	MGL/include/GL
	external/SPIRV-Cross
	external/SPIRV-Tools/include
	external/glslang/glslang/Include
)

# Gather all source files
file(GLOB_RECURSE MGL_SOURCES
	MGL/src/*.c
	MGL/src/*.m
	MGL/spirv_cross_c.cpp
)

# Static library target
add_library(mgl STATIC ${MGL_SOURCES})

# Link libraries
target_link_libraries(mgl PUBLIC
	"${CMAKE_CURRENT_LIST_DIR}/external/glslang/build/glslang/libGenericCodeGen.a"
	"${CMAKE_CURRENT_LIST_DIR}/external/glslang/build/glslang/libMachineIndependent.a"
	"${CMAKE_CURRENT_LIST_DIR}/external/glslang/build/glslang/libglslang-default-resource-limits.a"
	"${CMAKE_CURRENT_LIST_DIR}/external/glslang/build/glslang/libglslang.a"
	"${CMAKE_CURRENT_LIST_DIR}/external/glslang/build/glslang/OSDependent/Unix/libOSDependent.a"
	"${CMAKE_CURRENT_LIST_DIR}/external/glslang/build/SPIRV/libSPIRV.a"
	"${CMAKE_CURRENT_LIST_DIR}/external/SPIRV-Cross/build/libspirv-cross-c.a"
	"${CMAKE_CURRENT_LIST_DIR}/external/SPIRV-Cross/build/libspirv-cross-core.a"
	"${CMAKE_CURRENT_LIST_DIR}/external/SPIRV-Cross/build/libspirv-cross-cpp.a"
	"${CMAKE_CURRENT_LIST_DIR}/external/SPIRV-Cross/build/libspirv-cross-glsl.a"
	"${CMAKE_CURRENT_LIST_DIR}/external/SPIRV-Cross/build/libspirv-cross-hlsl.a"
	"${CMAKE_CURRENT_LIST_DIR}/external/SPIRV-Cross/build/libspirv-cross-msl.a"
	"${CMAKE_CURRENT_LIST_DIR}/external/SPIRV-Cross/build/libspirv-cross-reflect.a"
	"${CMAKE_CURRENT_LIST_DIR}/external/SPIRV-Cross/build/libspirv-cross-util.a"
)

# macOS Frameworks
target_link_libraries(mgl PUBLIC
	"-framework AppKit"
	"-framework Cocoa"
	"-framework CoreFoundation"
	"-framework Foundation"
	"-framework IOKit"
	"-framework Metal"
	"-framework OpenGL"
	"-framework QuartzCore"
)
