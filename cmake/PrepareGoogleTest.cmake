# Copyright (c) 2019 Gino Latorilla.
#
# Finds Google Test and Mock libraries that are locally installed,
# or downloads them.
# Link your targets to ${GTEST_BOTH_LIBRARIES}; it will also export
# the header directories so you don't have to.
#
# Example:
# include(PrepareGoogleTest)
# add_executable(run_test ${run_test_SOURCES})
# target_link_libraries(run_test ${GTEST_BOTH_LIBRARIES} pthread)

# Respect the project's build type.
if ("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    set(_lib_suffix "d${CMAKE_STATIC_LIBRARY_SUFFIX}")
else()
    set(_lib_suffix "${CMAKE_STATIC_LIBRARY_SUFFIX}")
endif()

macro(download_and_build_gtest)
    # Get the latest release from GitHub.
    # Build a static library and pass our project's debug symbols.
    # Inspired by and referenced from Google Benchmark
    # https://github.com/google/benchmark.git
    include(ExternalProject)
    if (${CMAKE_VERSION} VERSION_GREATER "3.0.99")
        set(EXCLUDE_FROM_ALL_OPT "EXCLUDE_FROM_ALL")
        set(EXCLUDE_FROM_ALL_VALUE "ON")
    endif()

    # I need to spell-out all possible "by-product" libraries for Ninja.
    # See https://stackoverflow.com/questions/50400592/using-an-externalproject-download-step-with-ninja
    foreach(_byproduct gtest gmock gmock_main)
        list(APPEND _byproducts_of_googletest 
            "${CMAKE_BINARY_DIR}/googletest/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${_byproduct}${_lib_suffix}"
        )
    endforeach()

    ExternalProject_Add(googletest
        ${EXCLUDE_FROM_ALL_OPT} ${EXCLUDE_FROM_ALL_VALUE}
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG master
        PREFIX "${CMAKE_BINARY_DIR}/googletest"
        INSTALL_DIR "${CMAKE_BINARY_DIR}/googletest"
        CMAKE_CACHE_ARGS
            -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
            -DCMAKE_C_COMPILER:STRING=${CMAKE_C_COMPILER}
            -DCMAKE_CXX_COMPILER:STRING=${CMAKE_CXX_COMPILER}
            -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
            -DCMAKE_INSTALL_LIBDIR:PATH=<INSTALL_DIR>/lib
            -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
            -Dgtest_force_shared_crt:BOOL=ON
        BUILD_BYPRODUCTS
            ${_byproducts_of_googletest}
        UPDATE_DISCONNECTED ${${PROJECT_NAME}_SKIP_GTEST_UPDATE}
    )

    # After it's built, let's extract useful paths and assemble
    #   CMake-friendly library targets.
    ExternalProject_Get_Property(googletest install_dir)

    # I have to make this directory so CMake would shut up.
    file(MAKE_DIRECTORY "${install_dir}/include")

    foreach(_downloaded_lib gtest gmock gmock_main)
        add_library(${_downloaded_lib} UNKNOWN IMPORTED)
        set_target_properties(${_downloaded_lib} PROPERTIES
            IMPORTED_LOCATION "${install_dir}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${_downloaded_lib}${_lib_suffix}"
            INTERFACE_INCLUDE_DIRECTORIES "${install_dir}/include"
        )
        # Keep these downloaded libraries up-to-date
        add_dependencies(${_downloaded_lib} googletest)
    endforeach()
    set(GTEST_INCLUDE_DIRS "${install_dir}/include")
endmacro()

if(${PROJECT_NAME}_USE_LATEST_GTEST)
    download_and_build_gtest()
else()
    # Try to find GTest first in default installation directory.
    #   (i.e. /usr/local)
    find_package(GTest)
    if (GTEST_FOUND)
        # Create library targets.
        # This is the recommended order for proper linkage.
        get_filename_component(_gtest_lib_dir "${GTEST_LIBRARY}" DIRECTORY)
        foreach(_installed_lib gtest gmock gmock_main)
            add_library(${_installed_lib} UNKNOWN IMPORTED)
            set_target_properties(${_installed_lib} PROPERTIES
                IMPORTED_LOCATION "${_gtest_lib_dir}/${CMAKE_STATIC_LIBRARY_PREFIX}${_installed_lib}${_lib_suffix}"
                INTERFACE_INCLUDE_DIRECTORIES "${GTEST_INCLUDE_DIRS}"
            )
        endforeach()
    else()
        message(STATUS "But I will download it later from GitHub")
        download_and_build_gtest()
    endif()
endif()

# Expose everything to GTEST_BOTH_LIBRARIES
if (TARGET gmock_main)
    list(APPEND GTEST_BOTH_LIBRARIES gmock_main)
else()
    list(APPEND GTEST_BOTH_LIBRARIES gtest_main)
endif()
if (TARGET gmock)
    list(APPEND GTEST_BOTH_LIBRARIES gmock)
endif()
list(APPEND GTEST_BOTH_LIBRARIES gtest)
