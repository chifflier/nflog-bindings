cmake_minimum_required(VERSION 2.6)

SET(VERSION "0.3")

STRING(COMPARE EQUAL "${CMAKE_SOURCE_DIR}" "${CMAKE_BINARY_DIR}" insource)
IF(insource)
  MESSAGE(FATAL_ERROR "nflog-bindings requires an out of source build. Please create a separate build directory and run 'cmake path_to_nflog_bindings [options]' there.")
ENDIF(insource)

# cmake --help-policy CMP0003
IF(COMMAND cmake_policy)
  cmake_policy(SET CMP0003 NEW)
ENDIF(COMMAND cmake_policy)

FIND_PACKAGE(SWIG REQUIRED)
INCLUDE(${SWIG_USE_FILE})

INCLUDE(FindPkgConfig)
pkg_search_module(LIBNFLOG "libnetfilter_log")

IF (NOT LIBNFLOG_FOUND)
  MESSAGE(FATAL_ERROR "libnetfilter_log was not found")
ENDIF (NOT LIBNFLOG_FOUND)

SET( LIB_SUFFIX "" CACHE STRING "The library directory suffix. 32bit empty string, 64 for 64bit." )
SET( LIB_INSTALL_DIR  "${CMAKE_INSTALL_PREFIX}/lib${LIB_SUFFIX}" )

ADD_SUBDIRECTORY(python)
ADD_SUBDIRECTORY(perl)

CONFIGURE_FILE(${CMAKE_CURRENT_SOURCE_DIR}/nflog_version.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/nflog_version.h)

