cmake_minimum_required(VERSION 3.20.0)
find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(firmups)

if(CONFIG_FIRMUPS_MODULE)
    message(STATUS "FIRMUPS enabled")

    include(FetchContent)

    # Pull device-sdk from GitHub
    FetchContent_Declare(
        firmups-device-sdk
        GIT_REPOSITORY https://github.com/firmups/device-sdk.git
        GIT_TAG main   # or a branch name like main
    )
    FetchContent_MakeAvailable(firmups-device-sdk)

    if(CONFIG_FIRMUPS_ENCRYPTION_CALLBACKS)
        target_compile_definitions(firmups-device-sdk PRIVATE FIRMUPS_USE_CRYPTO_CALLBACKS)
        zephyr_compile_definitions(FIRMUPS_USE_CRYPTO_CALLBACKS)
        if(CONFIG_FIRMUPS_ENCRYPTION_AES)
            target_compile_definitions(firmups-device-sdk PRIVATE FIRMUPS_USE_AES)
            zephyr_compile_definitions(FIRMUPS_USE_AES)
        endif()
    elseif(CONFIG_FIRMUPS_ENCRYPTION_AES)
        message(FATAL_ERROR CONFIG_FIRMUPS_ENCRYPTION_AES needs CONFIG_FIRMUPS_ENCRYPTION_CALLBACKS)
    endif()

    # Declare a Zephyr library
    zephyr_library()

    # Add your own sources if needed
    zephyr_library_sources(src/empty.c)

    # Add include directories from the SDK target
    get_target_property(SDK_INCLUDES firmups-device-sdk INCLUDE_DIRECTORIES)
    #message(FATAL_ERROR "SDK INCLUDES: ${SDK_INCLUDES}")
    zephyr_library_include_directories(${SDK_INCLUDES})

    # Link the SDK target to the Zephyr library
    target_link_libraries(${ZEPHYR_CURRENT_LIBRARY} PUBLIC firmups-device-sdk)

    # Add SDK includes to the app target
    target_include_directories(app PRIVATE ${SDK_INCLUDES})
else()
    message(STATUS "FIRMUPS disabled")
endif()
