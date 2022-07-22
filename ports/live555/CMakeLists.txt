cmake_minimum_required(VERSION 3.5)
set(VERSION 2022.07.14)
project(live555 
    VERSION ${VERSION}
    LANGUAGES C CXX)

include_directories(
    BasicUsageEnvironment/include
    groupsock/include
    liveMedia/include
    UsageEnvironment/include
)

if (WIN32)
    add_definitions(-DNO_GETIFADDRS)
endif(WIN32)

if (NOT MSVC)
    add_compile_options(-DSOCKLEN_T=socklen_t)
endif()

file(GLOB BASIC_USAGE_ENVIRONMENT_SRCS BasicUsageEnvironment/*.c BasicUsageEnvironment/*.cpp)
add_library(BasicUsageEnvironment ${BASIC_USAGE_ENVIRONMENT_SRCS})

file(GLOB GROUPSOCK_SRCS groupsock/*.c groupsock/*.cpp)
add_library(groupsock ${GROUPSOCK_SRCS})

file(GLOB LIVEMEDIA_SRCS liveMedia/*.c liveMedia/*.cpp)
add_library(liveMedia ${LIVEMEDIA_SRCS})
find_package(OpenSSL REQUIRED)
target_include_directories(liveMedia PRIVATE "${OPENSSL_INCLUDE_DIR}")

file(GLOB USAGE_ENVIRONMENT_SRCS UsageEnvironment/*.c UsageEnvironment/*.cpp)
add_library(UsageEnvironment ${USAGE_ENVIRONMENT_SRCS})

# add_library(${PROJECT_NAME}::core INTERFACE)

# target_link_libraries(${PROJECT_NAME}::core
#     PUBLIC groupsock
#     PUBLIC BasicUsageEnvironment
#     PUBLIC liveMedia
#     PUBLIC UsageEnvironment
# )

## Install library + targets ##################################################
include(CMakePackageConfigHelpers)

install(TARGETS groupsock BasicUsageEnvironment liveMedia UsageEnvironment
    EXPORT ${PROJECT_NAME}-targets
    RUNTIME DESTINATION     ${CMAKE_INSTALL_BINDIR}
        COMPONENT			${PROJECT_NAME}_Runtime

    LIBRARY DESTINATION     ${CMAKE_INSTALL_LIBDIR}
		COMPONENT			${PROJECT_NAME}_Runtime
		NAMELINK_COMPONENT	${PROJECT_NAME}_Development

    	# ... and the import lib into the devel package
	ARCHIVE DESTINATION     ${CMAKE_INSTALL_LIBDIR}
        COMPONENT			${PROJECT_NAME}_Development    
)

install(EXPORT  ${PROJECT_NAME}-targets
	DESTINATION ${CMAKE_INSTALL_DATADIR}/${PROJECT_NAME}
	NAMESPACE  ${PROJECT_NAME}::)


install(TARGETS groupsock BasicUsageEnvironment liveMedia UsageEnvironment
	# on Windows put the dlls into bin
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
		COMPONENT			${PROJECT_NAME}_Runtime

	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
		COMPONENT			${PROJECT_NAME}_Runtime
		NAMELINK_COMPONENT	${PROJECT_NAME}_Development

	# ... and the import lib into the devel package
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
		COMPONENT			${PROJECT_NAME}_Development
)

# file(COPY "${CMAKE_CURRENT_LIST_DIR}/config.cmake.in" DESTINATION "${SOURCE_PATH}")

configure_package_config_file(
	cmake/config.cmake.in
	${PROJECT_BINARY_DIR}/${PROJECT_NAME}-config.cmake
	INSTALL_DESTINATION ${CMAKE_INSTALL_DATADIR}/${PROJECT_NAME}
	NO_SET_AND_CHECK_MACRO)

write_basic_package_version_file(
    ${PROJECT_NAME}-config-version.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion)

install(
    FILES
        ${PROJECT_BINARY_DIR}/${PROJECT_NAME}-config.cmake
        ${PROJECT_BINARY_DIR}/${PROJECT_NAME}-config-version.cmake
    DESTINATION
        ${CMAKE_INSTALL_DATADIR}/${PROJECT_NAME})

file(GLOB HEADERS
        BasicUsageEnvironment/include/*.h*
        groupsock/include/*.h*
        liveMedia/include/*.h*
        UsageEnvironment/include/*.h*
)

install(
    FILES
        ${HEADERS}
        # ${PROJECT_BINARY_DIR}/version.h
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME})