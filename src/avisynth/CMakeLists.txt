cmake_minimum_required(VERSION 3.1)

set(SRC ${CMAKE_CURRENT_LIST_DIR})

set(LIB_SOURCES
    ${SRC}/avisynth.cpp
    ${SRC}/avssources.h
    ${SRC}/avssources.cpp
)

target_sources(ffms2
    PRIVATE
        ${LIB_SOURCES}
)

target_include_directories(ffms2
    PRIVATE
        ${CMAKE_CURRENT_LIST_DIR}
)
