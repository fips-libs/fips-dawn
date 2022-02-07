if (USE_DAWN_SDK)
    get_filename_component(DAWN_SDK_DIR ${FIPS_ROOT_DIR}/../fips-sdks/dawn/dawn ABSOLUTE)
    if (CMAKE_BUILD_TYPE MATCHES "Debug")
        set(DAWN_BUILD_DIR ${DAWN_SDK_DIR}/out/Debug)
    else()
        set(DAWN_BUILD_DIR ${DAWN_SDK_DIR}/out/Release)
    endif()
    
    # confusing hack from the original Dawn cmake files for getting the messy
    # internal vs public header search paths right
    add_library(dawn_public_config INTERFACE)
    target_include_directories(dawn_public_config INTERFACE "${DAWN_SDK_DIR}/include" "${DAWN_BUILD_DIR}/gen/include")
    
    add_library(dawn_internal_config INTERFACE)
    target_include_directories(dawn_internal_config INTERFACE "${DAWN_SDK_DIR}/src" "${DAWN_BUILD_DIR}/gen/src")
    target_link_libraries(dawn_internal_config INTERFACE dawn_public_config)

endif()

macro(dawn_add_deps target)
    if (USE_DAWN_SDK)
        target_link_libraries(${target} dawn_internal_config)

        target_link_directories(${target} PUBLIC ${DAWN_BUILD_DIR}/src/dawn/)
        target_link_directories(${target} PUBLIC ${DAWN_BUILD_DIR}/src/dawn/native)
        target_link_directories(${target} PUBLIC ${DAWN_BUILD_DIR}/src/dawn/utils)
        target_link_directories(${target} PUBLIC ${DAWN_BUILD_DIR}/src/dawn/platform)
        target_link_directories(${target} PUBLIC ${DAWN_BUILD_DIR}/src/dawn/wire)
        target_link_directories(${target} PUBLIC ${DAWN_BUILD_DIR}/src/dawn/common)
        target_link_directories(${target} PUBLIC ${DAWN_BUILD_DIR}/src/dawn_native)
        target_link_directories(${target} PUBLIC ${DAWN_BUILD_DIR}/third_party/spirv-tools/source)
        target_link_directories(${target} PUBLIC ${DAWN_BUILD_DIR}/third_party/spirv-tools/source/opt)
        target_link_directories(${target} PUBLIC ${DAWN_BUILD_DIR}/third_party/abseil/absl/strings)
        target_link_directories(${target} PUBLIC ${DAWN_BUILD_DIR}/third_party/tint/src)
        target_link_directories(${target} PUBLIC ${DAWN_BUILD_DIR}/third_party/glfw/src)

        target_link_libraries(${target}
            SPIRV-Tools
            SPIRV-Tools-opt
            tint
            tint_diagnostic_utils
            absl_str_format_internal
            absl_strings
            dawncpp
            dawn_utils
            dawn_proc
            dawn_native
            dawn_platform
            dawn_wire
            dawn_common
            dawncpp_headers
            dawn_headers
            glfw3
        )
    endif()
endmacro()





