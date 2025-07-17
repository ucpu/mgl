#!/bin/bash

# Optional: for macOS SDK if you're using system frameworks
# export SDKROOT=$(xcrun --show-sdk-path)

# Clone only the required repositories
git clone https://github.com/KhronosGroup/glslang.git --depth 1
git clone https://github.com/r58Playz/SPIRV-Cross.git -b uniform-constants

# === Build SPIRV-Cross ===
cd SPIRV-Cross
mkdir -p build && cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j4
cd ../..

# === Build glslang ===
cd glslang
./update_glslang_sources.py
mkdir -p build && cd build
cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_OPT=ON ..
make -j4
cd ../..

# === Build glfw ===
cp ../MGL/include/MGLContext.h glfw/src
cp ../MGL/include/MGLRenderer.h glfw/src
cd glfw
mkdir -p build && cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j4
cd ../..
