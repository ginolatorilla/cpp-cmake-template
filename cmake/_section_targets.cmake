# Copyright (c) 2019 Gino Latorilla.
#
# Declare all build targets here.

include(IncludeMeOnce)
IncludeMeOnce()

set(${PROJECT_NAME}_SOURCES src/impl.cpp)

if(${PROJECT_NAME}_BUILD_SHARED)
    set(_library_target_type SHARED)
else()
    set(_library_target_type STATIC)
endif()

# This declares a library target (could be shared or static).
# Expose your API directories with the INTERFACE property.
add_library(${PROJECT_NAME} ${_library_target_type} ${${PROJECT_NAME}_SOURCES})
target_include_directories(${PROJECT_NAME}
    INTERFACE
        include
)

# This declares an executable target.
# But sometimes we want `libXYZ` and `XYZ.exe`, so we want the OUTPUT_NAME
# to force that without clashing with CMake build target names.
add_executable(${PROJECT_NAME}_exe src/main.cpp)
set_target_properties(${PROJECT_NAME}_exe PROPERTIES OUTPUT_NAME ${PROJECT_NAME})

