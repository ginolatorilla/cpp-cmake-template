# Copyright (c) 2019 Gino Latorilla.

cmake_minimum_required(VERSION 3.0)
project(yourproject
    VERSION 0.9.0
    DESCRIPTION "A C++ project"
)

option(${PROJECT_NAME}_BUILD_SHARED "Builds shared (*.so) libraries.")
option(${PROJECT_NAME}_ENABLE_TESTING "Enable testing of this project.")
option(${PROJECT_NAME}_USE_LATEST_GTEST "Download Google Test from GitHub, then build it and use it.")
option(${PROJECT_NAME}_SKIP_GTEST_UPDATE "Skip updating of Google Test during build step.")

# Makes include() statements cleaner
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

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

if(${PROJECT_NAME}_ENABLE_TESTING)
    enable_testing()
    include(PrepareGoogleTest)

    # Integrate with CTest so you can run GTests with `cmake --build . -- test`
    macro(add_gtest test_name)
        add_executable(${test_name} "test/${test_name}.cpp")
        if (TARGET googletest)
            add_dependencies(${test_name} googletest)
        endif()
        target_link_libraries(${test_name} ${PROJECT_NAME} ${GTEST_BOTH_LIBRARIES} pthread)
        add_test(NAME ${test_name} COMMAND ${test_name})
    endmacro()

    add_gtest(impl_test)
endif()
