# Copyright (c) 2019 Gino Latorilla.

cmake_minimum_required(VERSION 3.0)
project(yourproject
    VERSION 0.9.0
    DESCRIPTION "A C++ project"
)

add_library(${PROJECT_NAME} src/impl.cpp)
target_include_directories(${PROJECT_NAME}
    INTERFACE
        include
)

add_executable(${PROJECT_NAME}_exe src/main.cpp)
set_target_properties(${PROJECT_NAME}_exe
    PROPERTIES
        OUTPUT_NAME ${PROJECT_NAME}
)