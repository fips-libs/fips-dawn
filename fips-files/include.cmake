get_filename_component(DAWN_SDK_DIR ${FIPS_ROOT_DIR}/../fips-sdks/dawn/dawn ABSOLUTE)
if (CMAKE_BUILD_TYPE MATCHES "Debug")
    set(DAWN_BUILD_DIR ${DAWN_SDK_DIR}/out/Debug)
else()
    set(DAWN_BUILD_DIR ${DAWN_SDK_DIR}/out/Release)
endif()
message("DAWN_SDK_DIR: ${DAWN_SDK_DIR}")
message("DAWN_BUILD_DIR: ${DAWN_BUILD_DIR}")

include_directories(${DAWN_SDK_DIR} ${DAWN_SDK_DIR}/src ${DAWN_SDK_DIR}/src/include ${DAWN_BUILD_DIR}/gen/src/include)
link_directories(${DAWN_BUILD_DIR}/obj)
link_directories(${DAWN_BUILD_DIR}/obj/src/dawn)
link_directories(${DAWN_BUILD_DIR}/obj/third_party)


