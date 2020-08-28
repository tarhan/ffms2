cmake_minimum_required(VERSION 3.1)

set(SRC ${CMAKE_CURRENT_LIST_DIR})

set(LIB_SOURCES
    ${SRC}/VapourSynth.h
    ${SRC}/vapoursource.cpp
    ${SRC}/vapoursource.h
    ${SRC}/vapoursynth.cpp
)

target_sources(ffms2
    PRIVATE
        ${LIB_SOURCES}
)
