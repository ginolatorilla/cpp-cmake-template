# Copyright (c) 2019 Gino Latorilla.
#
# Declare all build options here.

macro(add_build_option _name _description)
    option(${PROJECT_NAME}_${_name} ${_description})
endmacro()

add_build_option(BUILD_SHARED "Builds shared (*.so) libraries.")
add_build_option(ENABLE_TESTING "Enable testing of this project.")
add_build_option(USE_LATEST_GTEST "Download Google Test from GitHub, then build it and use it.")
add_build_option(SKIP_GTEST_UPDATE "Skip updating of Google Test during build step.")
