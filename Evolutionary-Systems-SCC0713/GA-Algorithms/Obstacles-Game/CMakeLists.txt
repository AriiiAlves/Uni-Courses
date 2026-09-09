cmake_minimum_required(VERSION 3.16)
project(RobotsEvolution LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set Debug mode
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
endif()

# Find system SDL2 package
find_package(SDL2 REQUIRED)

# Executable target
add_executable(run 
    src/main.cpp
    src/Player.cpp
    src/Graphic.cpp
    src/Game.cpp
    src/EvolutionTools.cpp
    src/Utils.cpp
)

# Link SDL2 to the target
target_include_directories(run PRIVATE ${SDL2_INCLUDE_DIRS} include)
target_link_libraries(run PRIVATE ${SDL2_LIBRARIES})
