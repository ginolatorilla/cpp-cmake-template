# Gino's C++ CMake project template

A C++ project template that uses the CMake build system.

Supports Linux only.

## Features

- Project options stored as CMake cache variables
- Test-driven development with Google Test
- Choose whether to use locally-installed Google Test or download them from GitHub
- CMake sections divided for maintainability (see `cmake/_section*` for details)
- Support for package dependency management with `PkgConfig`
- Support for address and undefined behaviour sanitizers in tests
- Support for static analysis with `clang-tidy`
