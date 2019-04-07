# Copyright (c) 2019 Gino Latorilla.
#
# Declare any (production) dependencies of your project here.

# Call `pkg-config --list-all` to know what's available in your system
find_package(PkgConfig)

# You can use this with CMake targets as `PkgConfig::python3`.
pkg_check_modules(python3 IMPORTED_TARGET "python3>=3.0")
