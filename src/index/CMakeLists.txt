cmake_minimum_required(VERSION 3.1)

add_executable(ffmsindex "")

target_sources(ffmsindex
    PRIVATE 
        vsutf16.h
        ffmsindex.cpp
)

target_link_libraries(ffmsindex
    PRIVATE 
        ffms2::ffms2
)

set_target_properties(ffmsindex
    PROPERTIES
        CXX_STANDARD 11
        CXX_STANDARD_REQUIRED ON
)
