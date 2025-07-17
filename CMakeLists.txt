cmake_minimum_required(VERSION 3.15)
project(MGL LANGUAGES C CXX OBJC OBJCXX)

execute_process(COMMAND "bash" "clone_external.sh" WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/external" COMMAND_ECHO STDOUT)
execute_process(COMMAND "bash" "build_external.sh" WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/external" COMMAND_ECHO STDOUT)

# Compiler flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O2 -g -fsanitize=address -arch ${CMAKE_SYSTEM_PROCESSOR}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O2 -g -fsanitize=address -arch ${CMAKE_SYSTEM_PROCESSOR}")
set(CMAKE_OBJC_FLAGS "${CMAKE_OBJC_FLAGS} -O2 -g -fsanitize=address -arch ${CMAKE_SYSTEM_PROCESSOR}")
set(CMAKE_OBJCXX_FLAGS "${CMAKE_OBJCXX_FLAGS} -O2 -g -fsanitize=address -arch ${CMAKE_SYSTEM_PROCESSOR}")

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
	src/*.c
	src/*.cpp
	src/*.m
	src/*.mm
)

# Static library target
add_library(mgl STATIC ${MGL_SOURCES})

# Link directories
target_link_directories(mgl PRIVATE
	external/SPIRV-Cross/build
	external/glslang/build/SPIRV
	external/glslang/build/glslang
	external/glslang/build/glslang/OSDependent/Unix
)

# Link libraries
target_link_libraries(mgl PRIVATE
	GenericCodeGen
	MachineIndependent
	OSDependent
	SPIRV
	glslang
	glslang-default-resource-limits
	spirv-cross-c
	spirv-cross-core
	spirv-cross-cpp
	spirv-cross-glsl
	spirv-cross-hlsl
	spirv-cross-msl
	spirv-cross-reflect
)

# macOS Frameworks
target_link_options(mgl PRIVATE
	"-framework" "Foundation"
	"-framework" "Metal"
	"-framework" "OpenGL"
)
