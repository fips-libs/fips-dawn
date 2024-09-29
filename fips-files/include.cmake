if (USE_DAWN_SDK)
    get_filename_component(DAWN_SDK_DIR ${FIPS_ROOT_DIR}/../fips-sdks/dawn/dawn ABSOLUTE)
    if (CMAKE_BUILD_TYPE MATCHES "Debug")
        set(DAWN_BUILD_DIR ${DAWN_SDK_DIR}/out/Debug)
    else()
        set(DAWN_BUILD_DIR ${DAWN_SDK_DIR}/out/Release)
    endif()
    if (FIPS_MSVC)
        set(DAWN_LIB_PREFIX "")
        set(DAWN_LIB_SUFFIX ".lib")
        set(DAWN_SHARED_SUFFIX ".dll")
    elseif(FIPS_MACOS)
        set(DAWN_LIB_PREFIX "lib")
        set(DAWN_LIB_SUFFIX ".a")
        set(DAWN_SHARED_SUFFIX ".dylib")
    else()
        set(DAWN_LIB_PREFIX "lib")
        set(DAWN_LIB_SUFFIX ".a")
        set(DAWN_SHARED_SUFFIX ".so")
    endif()

    add_library(webgpu_dawn SHARED IMPORTED)
    set_target_properties(webgpu_dawn PROPERTIES IMPORTED_LOCATION "${DAWN_BUILD_DIR}/src/dawn/native/${DAWN_LIB_PREFIX}webgpu_dawn${DAWN_SHARED_SUFFIX}")
    target_include_directories(webgpu_dawn INTERFACE "${DAWN_SDK_DIR}/include" "${DAWN_BUILD_DIR}/gen/include")

    add_library(dawn_glfw STATIC IMPORTED)
    set_target_properties(dawn_glfw PROPERTIES IMPORTED_LOCATION "${DAWN_BUILD_DIR}/src/dawn/glfw/${DAWN_LIB_PREFIX}dawn_glfw${DAWN_LIB_SUFFIX}")
    target_link_libraries(dawn_glfw INTERFACE glfw3)

    add_library(glfw3 STATIC IMPORTED)
    set_target_properties(glfw3 PROPERTIES IMPORTED_LOCATION "${DAWN_BUILD_DIR}/third_party/glfw/src/${DAWN_LIB_PREFIX}glfw3${DAWN_LIB_SUFFIX}")
    if (FIPS_MACOS)
        target_link_libraries(glfw3 INTERFACE "-framework Cocoa" "-framework IOKit" "-framework QuartzCore")
    endif()

    add_library(webgpu_glfw ALIAS dawn_glfw)

#    add_library(dawn_public_config INTERFACE)
#    target_include_directories(dawn_public_config INTERFACE "${DAWN_SDK_DIR}/include" "${DAWN_BUILD_DIR}/gen/include")
#    add_library(absl_throw_delegate STATIC IMPORTED)
#    set_target_properties(absl_throw_delegate PROPERTIES IMPORTED_LOCATION "${DAWN_BUILD_DIR}/third_party/abseil/absl/base/${DAWN_LIB_PREFIX}absl_throw_delegate${DAWN_LIB_SUFFIX}")
#    add_library(absl_strings_internal STATIC IMPORTED)
#    set_target_properties(absl_strings_internal PROPERTIES IMPORTED_LOCATION "${DAWN_BUILD_DIR}/third_party/abseil/absl/strings/${DAWN_LIB_PREFIX}absl_strings_internal${DAWN_LIB_SUFFIX}")
#    target_link_libraries(absl_strings_internal INTERFACE absl_throw_delegate)
#    add_library(absl_strings STATIC IMPORTED)
#    set_target_properties(absl_strings PROPERTIES IMPORTED_LOCATION "${DAWN_BUILD_DIR}/third_party/abseil/absl/strings/${DAWN_LIB_PREFIX}absl_strings${DAWN_LIB_SUFFIX}")
#    target_link_libraries(absl_strings INTERFACE absl_strings_internal)
#    add_library(absl_str_format_internal STATIC IMPORTED)
#    set_target_properties(absl_str_format_internal PROPERTIES IMPORTED_LOCATION "${DAWN_BUILD_DIR}/third_party/abseil/absl/strings/${DAWN_LIB_PREFIX}absl_str_format_internal${DAWN_LIB_SUFFIX}")
#
#    add_library(tint_diagnostic_utils STATIC IMPORTED)
#    set_target_properties(tint_diagnostic_utils PROPERTIES IMPORTED_LOCATION "${DAWN_BUILD_DIR}/src/tint/${DAWN_LIB_PREFIX}tint_diagnostic_utils${DAWN_LIB_SUFFIX}")
#    add_library(tint STATIC IMPORTED)
#    set_target_properties(tint PROPERTIES IMPORTED_LOCATION "${DAWN_BUILD_DIR}/src/tint/${DAWN_LIB_PREFIX}tint${DAWN_LIB_SUFFIX}")
#    target_link_libraries(tint INTERFACE tint_diagnostic_utils)
#
#    add_library(dawn_common STATIC IMPORTED)
#    set_target_properties(dawn_common PROPERTIES IMPORTED_LOCATION "${DAWN_BUILD_DIR}/src/dawn/common/${DAWN_LIB_PREFIX}dawn_common${DAWN_LIB_SUFFIX}")
#    add_library(dawn_headers STATIC IMPORTED)
#    set_target_properties(dawn_headers PROPERTIES IMPORTED_LOCATION "${DAWN_BUILD_DIR}/src/dawn/${DAWN_LIB_PREFIX}dawn_headers${DAWN_LIB_SUFFIX}")
#    add_library(dawn_wire STATIC IMPORTED)
#    set_target_properties(dawn_wire PROPERTIES IMPORTED_LOCATION "${DAWN_BUILD_DIR}/src/dawn/wire/${DAWN_LIB_PREFIX}dawn_wire${DAWN_LIB_SUFFIX}")
#    add_library(dawn_platform STATIC IMPORTED)
#    set_target_properties(dawn_platform PROPERTIES IMPORTED_LOCATION "${DAWN_BUILD_DIR}/src/dawn/platform/${DAWN_LIB_PREFIX}dawn_platform${DAWN_LIB_SUFFIX}")
#    add_library(dawn_native STATIC IMPORTED)
#    set_target_properties(dawn_native PROPERTIES IMPORTED_LOCATION "${DAWN_BUILD_DIR}/src/dawn/native/${DAWN_LIB_PREFIX}dawn_native${DAWN_LIB_SUFFIX}")
#    target_link_libraries(dawn_native INTERFACE absl_strings absl_str_format_internal)
#    if (FIPS_MACOS)
#        target_link_libraries(dawn_native INTERFACE "-framework QuartzCore" "-framework Metal" "-framework IOSurface")
#    endif()
#
#    add_library(webgpu_dawn STATIC IMPORTED)
#    set_target_properties(webgpu_dawn PROPERTIES IMPORTED_LOCATION "${DAWN_BUILD_DIR}/src/dawn/native/${DAWN_LIB_PREFIX}webgpu_dawn${DAWN_LIB_SUFFIX}")
#    target_link_libraries(webgpu_dawn INTERFACE dawn_public_config)
#    target_link_libraries(webgpu_dawn INTERFACE tint dawn_headers dawn_common dawn_platform dawn_native dawn_wire)
endif()
