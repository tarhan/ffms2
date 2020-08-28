
include(CheckCXXSourceCompiles)
function(check_ffmpeg_works result)
    set(CMAKE_REQUIRED_LIBRARIES 
        FFMPEG::avcodec 
        FFMPEG::swscale
    )
    set(CMAKE_REQUIRED_QUIET TRUE)
    if(ARGC EQUAL 2)
        set(linker_options ${ARGV1})
    endif()
    if(linker_options)
        set(CMAKE_REQUIRED_LINK_OPTIONS ${linker_options})
    endif()
    check_cxx_source_compiles([[
    extern "C" {
        #include <libavcodec/avcodec.h>
        #include <libswscale/swscale.h>
    }

        int main() {
            avcodec_register_all();
            swscale_version();
            return 0;
        }
    ]] isFFmpegWorking)
    if(isFFmpegWorking)
        set(${result} "yes" PARENT_SCOPE)
    else()
        set(${result} "no" PARENT_SCOPE)
    endif()
    unset(CMAKE_REQUIRED_LIBRARIES)
    unset(CMAKE_REQUIRED_QUIET)
    unset(CMAKE_REQUIRED_LINK_OPTIONS)
endfunction()

function(check_additional_linker_flags_for_ffmpeg linker_flags)
    set(opts "")
    check_ffmpeg_works(testFFmpegWorking)
    message(STATUS "Checking if FFmpeg works: ${testFFmpegWorking}")
    if(NOT testFFmpegWorking)
        message(FATAL_ERROR "cannot link with FFmpeg")
    endif()

    if(BUILD_SHARED_LIBS)
        check_ffmpeg_works(testFFmpegSharedNoSymbolic "-shared")
        message(STATUS "Checking if FFmpeg works[shared,no symbolic]: ${testFFmpegSharedNoSymbolic}")
        if(NOT testFFmpegSharedNoSymbolic)
            check_ffmpeg_works(testFFmpegSharedWithSymbolic "-Wl,-Bsymbolic")
            message(STATUS "Checking if FFmpeg works[shared,symbolic]: ${testFFmpegSharedWithSymbolic}")
            if(testFFmpegSharedWithSymbolic)
                set(opts "-Wl,-Bsymbolic")
            else()
                message(FATAL_ERROR "cannot build ffms2 as a shared library")                
            endif()
        endif()
    else()
        message(STATUS "Build static. ffmpeg testing")
    endif()
    set(${linker_flags} ${opts})
endfunction()
