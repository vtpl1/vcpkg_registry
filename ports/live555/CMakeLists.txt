cmake_minimum_required(VERSION 3.15)

set(VERSION 2022.07.14)

project(live555
	VERSION ${VERSION}
	DESCRIPTION "A complete RTSP server application"
	HOMEPAGE_URL "https://www.live555.com/liveMedia"
	LANGUAGES C CXX)

include(GNUInstallDirs)
file(GLOB GROUPSOCK_HDRS groupsock/include/*.hh)
file(GLOB GROUPSOCK_SRCS groupsock/*.c groupsock/*.cpp)

add_library(groupsock
	${GROUPSOCK_SRCS}
)

target_include_directories(groupsock
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/groupsock/include>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}>
    PRIVATE 
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/UsageEnvironment/include>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}>
)

set_target_properties(
	groupsock PROPERTIES
		POSITION_INDEPENDENT_CODE ON)

set_target_properties(
	groupsock PROPERTIES
		SOVERSION	${PROJECT_VERSION_MAJOR}
		VERSION     ${PROJECT_VERSION})

if (MSVC)
target_compile_definitions(groupsock
    PUBLIC NO_GETIFADDRS
    PRIVATE _CRT_SECURE_NO_WARNINGS
    PRIVATE _WINSOCK_DEPRECATED_NO_WARNINGS
)
target_compile_options(groupsock
    PRIVATE /wd4244
    PRIVATE /wd4312
)
target_link_libraries(groupsock
    PUBLIC ws2_32
)
else()
target_compile_options(groupsock
    PRIVATE -Wno-int-to-pointer-cast
)
endif()

file(GLOB USAGE_ENVIRONMENT_HDRS UsageEnvironment/include/*.hh)
file(GLOB USAGE_ENVIRONMENT_SRCS UsageEnvironment/*.c UsageEnvironment/*.cpp)

add_library(UsageEnvironment
	${USAGE_ENVIRONMENT_SRCS}
)

target_include_directories(UsageEnvironment
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/UsageEnvironment/include>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}>
)

target_link_libraries(UsageEnvironment
	PUBLIC groupsock
)

file(GLOB BASIC_USAGE_ENVIRONMENT_HDRS BasicUsageEnvironment/include/*.hh)
file(GLOB BASIC_USAGE_ENVIRONMENT_SRCS BasicUsageEnvironment/*.c UsageEnvironment/*.cpp)

add_library(BasicUsageEnvironment
	${BASIC_USAGE_ENVIRONMENT_SRCS}
)

target_include_directories(BasicUsageEnvironment
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/BasicUsageEnvironment/include>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}>
)

target_link_libraries(BasicUsageEnvironment
	PUBLIC UsageEnvironment
)

find_package(OpenSSL REQUIRED)

file(GLOB LIVE_MEDIA_HDRS liveMedia/include/*.hh)
file(GLOB LIVE_MEDIA_SRCS liveMedia/*.c liveMedia/*.cpp)


add_library(liveMedia
	${LIVE_MEDIA_SRCS}
)

target_include_directories(liveMedia
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/liveMedia/include>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}>
)

target_link_libraries(liveMedia
	PUBLIC BasicUsageEnvironment
    PUBLIC UsageEnvironment
    PUBLIC groupsock
    PUBLIC OpenSSL::SSL
    PUBLIC OpenSSL::Crypto
)

## Install library + targets ##################################################
include(CMakePackageConfigHelpers)

install(TARGETS groupsock UsageEnvironment BasicUsageEnvironment liveMedia
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

install(EXPORT ${PROJECT_NAME}-targets
	DESTINATION ${CMAKE_INSTALL_DATADIR}/${PROJECT_NAME}
	NAMESPACE   ${PROJECT_NAME}::
)

install(TARGETS groupsock UsageEnvironment BasicUsageEnvironment liveMedia
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

configure_package_config_file(${PROJECT_SOURCE_DIR}/cmake/config.cmake.in
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

list (APPEND HEADERS ${GROUPSOCK_HDRS} ${USAGE_ENVIRONMENT_HDRS} ${BASIC_USAGE_ENVIRONMENT_HDRS} ${LIVE_MEDIA_HDRS})

install(
    FILES
        ${HEADERS}
        # ${PROJECT_BINARY_DIR}/version.h
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME})