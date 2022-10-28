# -----------------------------------------------------------------
#  CMake Module for RTEMS
#
# The cmake distribution by default does not contain a module for RTEMS
# -----------------------------------------------------------------

# Note - RTEMS does not support "shared libs" in the traditional sense,
# but it does have a loader that does static linking at runtime.
# This property is set true which allows one to use the CMake shared library logic
# But the code is otherwise built as static -- no PIC flags
set_property(GLOBAL PROPERTY TARGET_SUPPORTS_SHARED_LIBS TRUE)
set(CMAKE_EXECUTABLE_SUFFIX ".exe")
set(CMAKE_SHARED_LIBRARY_SUFFIX ".obj")
set(CMAKE_SHARED_MODULE_SUFFIX ".obj")

# Setting all these to empty string defeats the default behavior
# of adding an -fPIC option to shared library/module code.
set(CMAKE_DL_LIBS "")
set(CMAKE_C_COMPILE_OPTIONS_PIC "")
set(CMAKE_CXX_COMPILE_OPTIONS_PIC "")

set(CMAKE_SHARED_LIBRARY_C_FLAGS "")
set(CMAKE_SHARED_LIBRARY_CXX_FLAGS "")
set(CMAKE_SHARED_MODULE_C_FLAGS "")
set(CMAKE_SHARED_MODULE_CXX_FLAGS "")

# Include the system specs directly within the COMPILE_OBJECT definitions
# This way it does not need to be done via CMAKE_C_FLAGS and it simplifies
# the process in general.
set(RTEMS_SYS_SPECS_FLAGS    "-B${RTEMS_TARGET_PATH}/${RTEMS_BSP}/lib -qrtems")
set(RTEMS_SYS_LINK_LIB_PATH  "-L${RTEMS_TARGET_PATH}/${RTEMS_BSP}/lib")

# Basic command templates for compiling C and C++ code
set(CMAKE_C_COMPILE_OBJECT   "<CMAKE_C_COMPILER>   <DEFINES> ${RTEMS_SYS_SPECS_FLAGS} ${RTEMS_BSP_C_FLAGS}   <INCLUDES> <FLAGS> -o <OBJECT> -c <SOURCE>")
set(CMAKE_CXX_COMPILE_OBJECT "<CMAKE_CXX_COMPILER> <DEFINES> ${RTEMS_SYS_SPECS_FLAGS} ${RTEMS_BSP_CXX_FLAGS} <INCLUDES> <FLAGS> -o <OBJECT> -c <SOURCE>")

# This creates a simple relocatable object file, not a shared library
set(CMAKE_SHARED_OBJECT_LINKER_FLAGS -r)
set(CMAKE_C_CREATE_SHARED_MODULE "<CMAKE_LINKER> ${RTEMS_BSP_LINK_FLAGS} <LINK_FLAGS> -o <TARGET> ${CMAKE_SHARED_OBJECT_LINKER_FLAGS} <OBJECTS> <LINK_LIBRARIES>")
set(CMAKE_CXX_CREATE_SHARED_MODULE ${CMAKE_C_CREATE_SHARED_MODULE})
set(CMAKE_C_CREATE_SHARED_LIBRARY ${CMAKE_C_CREATE_SHARED_MODULE})
set(CMAKE_CXX_CREATE_SHARED_LIBRARY ${CMAKE_C_CREATE_SHARED_MODULE})
set(CMAKE_C_LINK_EXECUTABLE "<CMAKE_LINKER> ${RTEMS_BSP_LINK_FLAGS} <LINK_FLAGS> -o <TARGET> ${CMAKE_SHARED_OBJECT_LINKER_FLAGS} <OBJECTS> <LINK_LIBRARIES>")

SET(RTEMS_TARGET_PATH
    "${RTEMS_BSP_PREFIX}/${CMAKE_SYSTEM_PROCESSOR}-rtems${CMAKE_SYSTEM_VERSION}")

set(RTEMS_TOOLS_PATH
    "${RTEMS_TOOLS_PREFIX}/${CMAKE_SYSTEM_PROCESSOR}-rtems${CMAKE_SYSTEM_VERSION}")

set(CMAKE_FIND_ROOT_PATH
    "${RTEMS_TARGET_PATH}/${RTEMS_BSP}"
    "${RTEMS_TOOLS_PATH}")

set(CMAKE_SYSTEM_PREFIX_PATH
    ${CMAKE_FIND_ROOT_PATH})

set(CMAKE_SYSTEM_INCLUDE_PATH
    "${RTEMS_TARGET_PATH}/${RTEMS_BSP}/lib/include"
    "${RTEMS_TOOLS_PATH}/include")

set(CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES ${CMAKE_SYSTEM_INCLUDE_PATH})
set(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES ${CMAKE_SYSTEM_INCLUDE_PATH})
set(CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES "${RTEMS_TARGET_PATH}/${RTEMS_BSP}/lib")
set(CMAKE_SYSTEM_LIBRARY_PATH ${CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES})

set(RTEMS TRUE)
set(UNIX TRUE)
