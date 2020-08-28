cmake_minimum_required(VERSION 3.1)

project(ffms2
    VERSION 2.40.0.0
    LANGUAGES CXX
)
set(BUILD_SHARED_LIBS ON)

set(ffms2_URL "https://github.com/FFMS/ffms2")

option(ENABLE_DEBUG "Enable debug build. [default=NO]" NO)
option(ENABLE_TEST "Enable build test. [default=NO]" NO)
option(ENABLE_APP "Enable ffmsindex building. [default=YES]" YES)
option(ENABLE_AVISYNTH "Enable AviSynth+ plugin. [default=NO]" NO)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

message(STATUS "Checking if debug build is enabled... ${ENABLE_DEBUG}")
if(NOT ${CMAKE_CONFIGURATION_TYPES})
    if(NOT ${CMAKE_BUILD_TYPE})
        if(ENABLE_DEBUG)
            set(CMAKE_BUILD_TYPE "Debug")
        else()
            set(CMAKE_BUILD_TYPE "Release")
        endif()
    endif()
endif()



if(MSVC)
    set(EXTRA_WARNINGS "/W4")
else()
    set(EXTRA_WARNINGS "-Wall" "-Wextra")
endif()

if(MINGW OR CYGWIN)
    set(BUILD_SHARED_LIBS OFF)
endif()

if(CYGWIN AND BUILD_SHARED_LIBS)
    message(FATAL_ERROR "Shared build is broken on cygwin. Please set CMake BUILD_SHARED_LIBS variable to OFF")
endif()

add_library(ffms2 "")
add_library(ffms2::ffms2 ALIAS ffms2)

if(WIN32)
    set_target_properties(ffms2 PROPERTIES DEBUG_POSTFIX d)
endif()

set_target_properties(ffms2
    PROPERTIES
        CXX_STANDARD 11
        CXX_STANDARD_REQUIRED YES
)

if(UNIX)
    execute_process(
        COMMAND sh ${CMAKE_CURRENT_LIST_DIR}/version.sh
        WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
        OUTPUT_VARIABLE FFMS_VERSION
    )
else()
    set(FFMS_VERSION ${ffms2_VERSION})
endif()
message(STATUS "FFMS Version: ${FFMS_VERSION}")

find_package(ZLIB REQUIRED)

find_package(FFMPEG
    REQUIRED COMPONENTS 
        avutil 
        avformat 
        avcodec 
        swscale 
        swresample
)


target_link_libraries(ffms2
    PRIVATE
        ZLIB::ZLIB
        FFMPEG::FFMPEG
)

include(FFmpegAdditionalChecks)
check_additional_linker_flags_for_ffmpeg(ffms_ffmpeg_options)

if(ffms_ffmpeg_options)
    set_target_properties(ffms2 
        PROPERTIES LINK_FLAGS ${ffms_ffmpeg_options}
    )
endif()

target_compile_options(ffms2
    PRIVATE ${EXTRA_WARNINGS}
)

if(MINGW)
    target_compile_options(ffms2
        PRIVATE
            "-no-undefined"
    )
endif()

target_include_directories(ffms2
    PRIVATE
        ${CMAKE_CURRENT_LIST_DIR}
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
)

target_compile_definitions(ffms2
    PRIVATE
        _FILE_OFFSET_BITS=64
        FFMS_EXPORTS
        __STDC_CONSTANT_MACROS
)

if(WIN32)
    target_compile_definitions(ffms2
        PRIVATE
            $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:FFMS_WIN_DEBUG>
    )
endif()

add_subdirectory(src/core)
add_subdirectory(src/vapoursynth)
if(ENABLE_AVISYNTH)
    add_subdirectory(src/avisynth)
endif()

set_target_properties(ffms2 PROPERTIES
    PUBLIC_HEADER "include/ffms.h;include/ffmscompat.h"
)

if(ENABLE_APP)
    add_subdirectory(src/index)
endif()


include(GNUInstallDirs)
set(CMAKE_INSTALL_CMAKEDIR ${CMAKE_INSTALL_LIBDIR}/cmake/ffms2)
# Preparing config file for pkgconfig
set(configure_input
    "Generated from CMake"
)
set(prefix ${CMAKE_INSTALL_PREFIX})
set(exec_prefix ${CMAKE_INSTALL_PREFIX})
set(libdir ${CMAKE_INSTALL_FULL_LIBDIR})
set(includedir ${CMAKE_INSTALL_FULL_INCLUDEDIR})
configure_file(ffms2.pc.in
  ffms2.pc
  @ONLY
)

install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/ffms2.pc
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig
)

install(
  TARGETS ffms2
  EXPORT ffms2Targets
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

install(EXPORT ffms2Targets
    FILE ffms2Targets.cmake
    NAMESPACE ffms2::
    DESTINATION ${CMAKE_INSTALL_CMAKEDIR}
)

install(FILES ffms2Config.cmake
  DESTINATION ${CMAKE_INSTALL_CMAKEDIR}
)

if(ENABLE_TEST)
    set(SAMPLES_DIR ${CMAKE_CURRENT_BINARY_DIR}/test/samples)
    set(SAMPLES_URL "https://storage.googleapis.com/ffms2tests")

    add_custom_target(test-setup
        COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/test
        COMMAND ${CMAKE_COMMAND} -E make_directory ${SAMPLES_DIR}
    )

    find_package(GTest)
endif()
