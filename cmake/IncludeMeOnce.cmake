# Copyright (c) 2019 Gino Latorilla.
#
# Restrict a *.cmake file to be included at most once.

macro(IncludeMeOnce )
    if(__is_included_${CMAKE_CURRENT_LIST_FILE})
        return()
    endif()
    set(__is_included_${CMAKE_CURRENT_LIST_FILE} INCLUDED)
endmacro()