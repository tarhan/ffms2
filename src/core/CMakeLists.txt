cmake_minimum_required(VERSION 3.1)

set(SRC ${CMAKE_CURRENT_LIST_DIR})

set(LIB_SOURCES
    ${SRC}/audiosource.cpp
    ${SRC}/audiosource.h
    ${SRC}/ffms.cpp
    ${SRC}/filehandle.cpp
    ${SRC}/filehandle.h
    ${SRC}/indexing.cpp
    ${SRC}/indexing.h
    ${SRC}/track.cpp
    ${SRC}/track.h
    ${SRC}/utils.cpp
    ${SRC}/utils.h
    ${SRC}/videosource.cpp
    ${SRC}/videosource.h
    ${SRC}/videoutils.cpp
    ${SRC}/videoutils.h
    ${SRC}/zipfile.cpp
    ${SRC}/zipfile.h
)

target_sources(ffms2
    PRIVATE
        ${LIB_SOURCES}
)
