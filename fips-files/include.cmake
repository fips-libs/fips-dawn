# FIXME: more platforms
if (CMAKE_BUILD_TYPE MATCHES "Debug")
    get_filename_component(DAWN_BUILD_DIR ${FIPS_ROOT_DIR}/../fips-sdks/dawn/dawn/out/Debug ABSOLUTE)
else()
    get_filename_component(DAWN_BUILD_DIR ${FIPS_ROOT_DIR}/../fips-sdks/dawn/dawn/out/Release ABSOLUTE)
endif()
message("DAWN_BUILD_DIR: ${DAWN_BUILD_DIR}")

# include Dawn header as "dawn/webgpu.h"
include_directories(${DAWN_BUILD_DIR}/gen/src/include)
# FIXME: .a vs .lib
link_directories(${DAWN_BUILD_DIR}/obj)


