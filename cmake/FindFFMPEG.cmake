#[==============================================[
FindFFMPEG
-----------

Ищем библиотеку FFMPEG и создаем импортируемую
цель FFMPEG::FFMPEG

#]==============================================]
if (${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)
    set(comps_selected ON)
    set(comps ${${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS})
else()
    set(comps_selected)
    set(comps
            avcodec
            avdevice
            avfilter
            avformat
            avutil
            postproc
            swresample
            swscale
    )
endif()


# Импортируем путь к заголовочным файлам FFMPEG
if (MSVC OR MINGW)
    if (DEFINED ENV{ffmpeg_DIR})
        set(ENV_FFMPEG YES)
        set(includes_search_paths $ENV{ffmpeg_DIR}/include)
        set(library_search_paths $ENV{ffmpeg_DIR}/lib)
        set(no_use_default NO_DEFAULT_PATH)
    endif()
endif()

include(FindPackageHandleStandardArgs)

find_path(FFMPEG_INCLUDE_DIR
    NAMES   libavcodec/avcodec.h
            libavdevice/avdevice.h
            libavfilter/avfilter.h
            libavformat/avformat.h
            libavutil/avutil.h
            libpostproc/postproc.h
            libswresample/swresample.h
            libswscale/swscale.h
    PATHS ${includes_search_paths}
)

set(FFMPEG_INCLUDE_DIRS)
set(FFMPEG_LIBS)
set(FFMPEG_comps_founds)

foreach(icomp IN LISTS comps)
    if (${icomp} STREQUAL "postproc")
        set(inc_path lib${icomp}/postprocess.h)
    else()
        set(inc_path lib${icomp}/${icomp}.h)
    endif()
    find_path(FFMPEG_INCLUDE_DIR_${icomp}
        NAMES ${inc_path}
        PATHS ${includes_search_paths}
    )
    find_library(FFMPEG_LIBRARY_${icomp}
        NAMES ${icomp}
        PATHS ${library_search_paths}
        ${no_use_default}
    )
    
    find_package_handle_standard_args(FFMPEG_${icomp}
        REQUIRED_VARS FFMPEG_LIBRARY_${icomp} FFMPEG_INCLUDE_DIR_${icomp}
    )
    list(APPEND FFMPEG_INCLUDE_DIRS "${FFMPEG_INCLUDE_DIR_${icomp}}")
    list(APPEND FFMPEG_LIBS "${FFMPEG_LIBRARY_${icomp}}")
    list(APPEND FFMPEG_comps_founds FFMPEG_${icomp}_FOUND)
endforeach()
list(REMOVE_DUPLICATES FFMPEG_INCLUDE_DIRS)
list(REMOVE_DUPLICATES FFMPEG_LIBS)

set(FFMPEG_NAME "ffmpeg")

find_package_handle_standard_args(FFMPEG
    REQUIRED_VARS FFMPEG_NAME ${FFMPEG_comps_founds}
    HANDLE_COMPONENTS
)

# Проверяем наличие библиотки по заголовочному файлу и файлу библиотеки
if (FFMPEG_FOUND)
    include(GNUInstallDirs)
    foreach(icomp IN LISTS comps)
        if (NOT TARGET FFMPEG::${icomp})   
            add_library(FFMPEG::${icomp}
                UNKNOWN IMPORTED
            )
            set_target_properties(FFMPEG::${icomp} PROPERTIES
                IMPORTED_LOCATION "${FFMPEG_LIBRARY_${icomp}}"
            )
            set_target_properties(FFMPEG::${icomp} PROPERTIES
                INTERFACE_INCLUDE_DIRECTORIES "${FFMPEG_INCLUDE_DIR_${icomp}}"
            )
        endif()
    endforeach()
    if (NOT TARGET FFMPEG_FFMPEG)    
        add_library(FFMPEG_FFMPEG INTERFACE)
        add_library(FFMPEG::FFMPEG ALIAS FFMPEG_FFMPEG)
        foreach(icomp IN LISTS comps)
            target_link_libraries(FFMPEG_FFMPEG
                INTERFACE FFMPEG::${icomp}
            )
        endforeach()
        # TODO Research correct way (include all ffmpeg components)
        install(
            TARGETS FFMPEG_FFMPEG
            EXPORT ffmpegTargets    
        )
        install(EXPORT ffmpegTargets
            FILE ffmpegTargets.cmake
            NAMESPACE FFMPEG::
            DESTINATION lib/cmake/FFMPEG
        )
    endif()
endif()

