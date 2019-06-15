# ACLOCAL_AMFLAGS = -I m4
# AUTOMAKE_OPTIONS = foreign

# pkgconfigdir = $(libdir)/pkgconfig
# pkgconfig_DATA = ffms2.pc

# dist_doc_DATA = doc/ffms2-api.md doc/ffms2-changelog.md

add_library(ffms2 "")

target_compile_options(ffms2
    PRIVATE ${EXTRA_WARNINGS}
)

# AM_CPPFLAGS = \
# 	-I. \
# 	-I$(top_srcdir)/include \
# 	-I$(top_srcdir)/src/config \
target_include_directories(ffms2
    PRIVATE
        ${CMAKE_CURRENT_LIST_DIR}
    PUBLIC
        ${CMAKE_SOURCE_DIR}/include
    PRIVATE
        ${CMAKE_SOURCE_DIR}/src/config
)
# 	-D_FILE_OFFSET_BITS=64 \
# 	-DFFMS_EXPORTS \
# 	-D__STDC_CONSTANT_MACROS \
target_compile_definitions(ffms2
    PRIVATE
        "_FILE_OFFSET_BITS=64"
        "FFMS_EXPORTS"
        "__STDC_CONSTANT_MACROS"
)

target_link_libraries(ffms2
    PRIVATE
        ZLIB::ZLIB
        FFMPEG::FFMPEG
)
# 	@FFMPEG_CFLAGS@ \
# For cmake CFLAGS getting via transietive dependecy from FFMPEG::FFMPEG target
# 	@ZLIB_CPPFLAGS@ \
# For cmake CPPFLAGS getting via transietive dependecy from ZLIB::ZLIB target
# 	-include config.h

# AM_CXXFLAGS = -std=c++11 -fvisibility=hidden
# Makefile.am line 19
set_target_properties(ffms2
    PROPERTIES
        CXX_STANDARD 11
        CXX_STANDARD_REQUIRED YES
        # CXX_VISIBILITY_PRESET hidden
)

# lib_LTLIBRARIES = src/core/libffms2.la
# src_core_libffms2_la_LDFLAGS = @src_core_libffms2_la_LDFLAGS@
# src_core_libffms2_la_LIBADD = @FFMPEG_LIBS@ @ZLIB_LDFLAGS@ -lz @LTUNDEF@
# src_core_libffms2_la_SOURCES = \
# 	src/core/audiosource.cpp \
# 	src/core/audiosource.h \
# 	src/core/ffms.cpp \
# 	src/core/filehandle.cpp \
# 	src/core/filehandle.h \
# 	src/core/indexing.cpp \
# 	src/core/indexing.h \
# 	src/core/track.cpp \
# 	src/core/track.h \
# 	src/core/utils.cpp \
# 	src/core/utils.h \
# 	src/core/videosource.cpp \
# 	src/core/videosource.h \
# 	src/core/videoutils.cpp \
# 	src/core/videoutils.h \
# 	src/core/zipfile.cpp \
# 	src/core/zipfile.h \
# 	src/vapoursynth/VapourSynth.h \
# 	src/vapoursynth/vapoursource.cpp \
# 	src/vapoursynth/vapoursource.h \
# 	src/vapoursynth/vapoursynth.cpp
set(LIB_SOURCES
    src/core/audiosource.cpp
    src/core/audiosource.h
    src/core/ffms.cpp
    src/core/filehandle.cpp
    src/core/filehandle.h
    src/core/indexing.cpp
    src/core/indexing.h
    src/core/track.cpp
    src/core/track.h
    src/core/utils.cpp
    src/core/utils.h
    src/core/videosource.cpp
    src/core/videosource.h
    src/core/videoutils.cpp
    src/core/videoutils.h
    src/core/zipfile.cpp
    src/core/zipfile.h
    src/vapoursynth/VapourSynth.h
    src/vapoursynth/vapoursource.cpp
    src/vapoursynth/vapoursource.h
    src/vapoursynth/vapoursynth.cpp
)

target_sources(ffms2
    PRIVATE
        ${LIB_SOURCES}
        ${LIB_HEADERS}
)

# include_HEADERS = $(top_srcdir)/include/ffms.h $(top_srcdir)/include/ffmscompat.h
set(LIB_HEADERS
    include/ffms.h
    include/ffmscompat.h
)


# bin_PROGRAMS = src/index/ffmsindex
add_executable(ffmsindex "")

# src_index_ffmsindex_SOURCES = src/index/ffmsindex.cpp
set(APP_SOURCES
    src/index/ffmsindex.cpp
)
target_sources(ffmsindex
    PRIVATE
        ${APP_SOURCES}
)

# src_index_ffmsindex_LDADD = src/core/libffms2.la
target_link_libraries(ffmsindex
    PRIVATE ffms2
)







# .PHONY: test test-build test-clean test-sync test-run
# clean-local: test-clean

# SAMPLES_DIR = $(abs_top_builddir)/test/samples
# SAMPLES_URL = https://storage.googleapis.com/ffms2tests

# test: test-setup test-build test-run

# test-setup:
# 	@$(MKDIR_P) $(abs_top_builddir)/test
# 	@$(MKDIR_P) $(SAMPLES_DIR)
# 	@if [ ! -e "$(abs_top_builddir)/test/Makefile" ]; then \
#         $(LN_S) $(abs_top_srcdir)/test/Makefile $(abs_top_builddir)/test/Makefile; \
#     fi

# test-build: test-setup src/core/libffms2.la
# 	@if [ ! -d "$(abs_top_srcdir)/test/googletest" ]; then \
#         echo "googletest submodule not initalized."; \
#     fi
# 	@$(MAKE) -C test USER_DIR=$(abs_top_srcdir) SAMPLES_DIR=$(SAMPLES_DIR) CXX=$(CXX) AR=$(AR)

# test-sync: test-setup
# 	@$(MAKE) -C test sync USER_DIR=$(abs_top_srcdir) SAMPLES_DIR=$(SAMPLES_DIR) SAMPLES_URL=$(SAMPLES_URL) CXX=$(CXX) AR=$(AR)

# test-run: test-build
# 	@$(MAKE) -C test run USER_DIR=$(abs_top_srcdir) SAMPLES_DIR=$(SAMPLES_DIR) CXX=$(CXX) AR=$(AR) -k

# test-clean:
# 	@$(MAKE) -C test clean USER_DIR=$(abs_top_srcdir) CXX=$(CXX) AR=$(AR)
