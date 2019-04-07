# Copyright (c) 2019 Gino Latorilla.
#
# Declare all test-related targets here.

include(IncludeMeOnce)
IncludeMeOnce()

enable_testing()
include(PrepareGoogleTest)

# Integrate with CTest so you can run GTests with `cmake --build . -- test`
# One test executable per CPP in the `test/` directory.
macro(add_gtest test_name)
    add_executable(${test_name} "test/${test_name}.cpp")
    if (TARGET googletest)
        add_dependencies(${test_name} googletest)
    endif()
    target_link_libraries(${test_name} ${PROJECT_NAME} ${GTEST_BOTH_LIBRARIES} pthread)
    add_test(NAME ${test_name} COMMAND ${test_name})
endmacro()

add_gtest(impl_test)
