# Copyright (c) 2019 Gino Latorilla.

cmake_minimum_required(VERSION 3.0)
project(yourproject
    VERSION 0.9.0
    DESCRIPTION "A C++ project"
)

# Makes include() statements cleaner
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include(_section_options)
include(_section_targets)


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
