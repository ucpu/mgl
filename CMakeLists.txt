cmake_minimum_required(VERSION 3.15)
project(MGL LANGUAGES C CXX OBJC)

execute_process(COMMAND "bash" "build_external.sh" WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/external" COMMAND_ECHO STDOUT)

set(CMAKE_C_STANDARD 17)
set(CMAKE_CXX_STANDARD 20)

include_directories(
	MGL/SPIRV/SPIRV-Cross
	MGL/include
	MGL/include/GL
	external/SPIRV-Cross
	external/glslang/External/spirv-tools/include
	external/glslang/SPIRV
	external/glslang/glslang/Include
	external/glslang/glslang/Public
)

file(GLOB_RECURSE MGL_SOURCES
	MGL/src/*.c
	MGL/src/*.m
	MGL/spirv_cross_c.cpp
)

add_library(mgl STATIC ${MGL_SOURCES})

target_link_libraries(mgl PUBLIC
	"${CMAKE_CURRENT_SOURCE_DIR}/external/SPIRV-Cross/build/libspirv-cross-c.a"
	"${CMAKE_CURRENT_SOURCE_DIR}/external/SPIRV-Cross/build/libspirv-cross-core.a"
	"${CMAKE_CURRENT_SOURCE_DIR}/external/SPIRV-Cross/build/libspirv-cross-cpp.a"
	"${CMAKE_CURRENT_SOURCE_DIR}/external/SPIRV-Cross/build/libspirv-cross-glsl.a"
	"${CMAKE_CURRENT_SOURCE_DIR}/external/SPIRV-Cross/build/libspirv-cross-hlsl.a"
	"${CMAKE_CURRENT_SOURCE_DIR}/external/SPIRV-Cross/build/libspirv-cross-msl.a"
	"${CMAKE_CURRENT_SOURCE_DIR}/external/SPIRV-Cross/build/libspirv-cross-reflect.a"
	"${CMAKE_CURRENT_SOURCE_DIR}/external/SPIRV-Cross/build/libspirv-cross-util.a"
	"${CMAKE_CURRENT_SOURCE_DIR}/external/glslang/build/External/spirv-tools/source/diff/libSPIRV-Tools-diff.a"
	"${CMAKE_CURRENT_SOURCE_DIR}/external/glslang/build/External/spirv-tools/source/libSPIRV-Tools.a"
	"${CMAKE_CURRENT_SOURCE_DIR}/external/glslang/build/External/spirv-tools/source/link/libSPIRV-Tools-link.a"
	"${CMAKE_CURRENT_SOURCE_DIR}/external/glslang/build/External/spirv-tools/source/lint/libSPIRV-Tools-lint.a"
	"${CMAKE_CURRENT_SOURCE_DIR}/external/glslang/build/External/spirv-tools/source/opt/libSPIRV-Tools-opt.a"
	"${CMAKE_CURRENT_SOURCE_DIR}/external/glslang/build/External/spirv-tools/source/reduce/libSPIRV-Tools-reduce.a"
	"${CMAKE_CURRENT_SOURCE_DIR}/external/glslang/build/SPIRV/libSPIRV.a"
	"${CMAKE_CURRENT_SOURCE_DIR}/external/glslang/build/glslang/OSDependent/Unix/libOSDependent.a"
	"${CMAKE_CURRENT_SOURCE_DIR}/external/glslang/build/glslang/libGenericCodeGen.a"
	"${CMAKE_CURRENT_SOURCE_DIR}/external/glslang/build/glslang/libMachineIndependent.a"
	"${CMAKE_CURRENT_SOURCE_DIR}/external/glslang/build/glslang/libglslang-default-resource-limits.a"
	"${CMAKE_CURRENT_SOURCE_DIR}/external/glslang/build/glslang/libglslang.a"
)

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

if(MGL_BUILD_TEST)
	add_library(glfw-imp STATIC IMPORTED)
	set_target_properties(glfw-imp PROPERTIES IMPORTED_LOCATION "${CMAKE_CURRENT_SOURCE_DIR}/external/glfw/build/src/libglfw3.a")

	add_library(glfw INTERFACE)
	target_link_libraries(glfw INTERFACE glfw-imp mgl)
	target_include_directories(glfw INTERFACE "external/glfw/include")

	add_dependencies(glfw mgl)

	add_library(glm INTERFACE)
	target_include_directories(glm INTERFACE "mgl/MGL/include")

	add_executable(mgl_test mgl_test.cpp)
	target_link_libraries(mgl_test glfw glm)
endif()
