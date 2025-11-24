cmake_minimum_required(VERSION 3.20.0)
#find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(firmups_agent_module)

include(FetchContent)

# Pull device-sdk from GitHub
FetchContent_Declare(
    firmups-device-sdk
    GIT_REPOSITORY https://github.com/firmups/device-sdk.git
    GIT_TAG main   # or a branch name like main
)
FetchContent_MakeAvailable(firmups-device-sdk)

# target_sources(app PRIVATE src/main.c)
# target_include_directories(app PRIVATE include)
