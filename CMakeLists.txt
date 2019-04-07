# Copyright (c) 2019 Gino Latorilla.

cmake_minimum_required(VERSION 3.0)
project(yourproject
    VERSION 0.9.0
    DESCRIPTION "A C++ project"
)

option(${PROJECT_NAME}_BUILD_SHARED "Builds shared (*.so) libraries.")

set(${PROJECT_NAME}_SOURCES src/impl.cpp)
if(${PROJECT_NAME}_BUILD_SHARED)
    add_library(${PROJECT_NAME} SHARED ${${PROJECT_NAME}_SOURCES})
else(${PROJECT_NAME}_BUILD_SHARED)
    add_library(${PROJECT_NAME} STATIC ${${PROJECT_NAME}_SOURCES})
endif(${PROJECT_NAME}_BUILD_SHARED)

target_include_directories(${PROJECT_NAME}
    INTERFACE
        include
)

add_executable(${PROJECT_NAME}_exe src/main.cpp)
set_target_properties(${PROJECT_NAME}_exe
    PROPERTIES
        OUTPUT_NAME ${PROJECT_NAME}
)