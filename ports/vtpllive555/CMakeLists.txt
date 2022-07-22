cmake_minimum_required(VERSION 3.5)
set(VERSION 2022.07.14)

project(live555 
    VERSION ${VERSION}
    LANGUAGES C CXX)


file(GLOB GROUPSOCK_HDRS groupsock/include/*.hh)

file(GLOB GROUPSOCK_SRCS groupsock/*.c groupsock/*.cpp)
    
add_library(groupsock ${GROUPSOCK_SRCS})

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
else()
target_compile_options(groupsock
    PRIVATE -Wno-int-to-pointer-cast
)
endif()

# file(GLOB USAGE_ENVIRONMENT_HDRS UsageEnvironment/include/*.hh)

# file(GLOB USAGE_ENVIRONMENT_SRCS UsageEnvironment/*.c UsageEnvironment/*.cpp)
    
# add_library(UsageEnvironment ${USAGE_ENVIRONMENT_SRCS})

# target_include_directories(UsageEnvironment
#     PUBLIC UsageEnvironment/include
# )

# target_link_libraries(UsageEnvironment
#     PUBLIC groupsock
# )

# file(GLOB BASIC_USAGE_ENVIRONMENT_HDRS UsageEnvironment/include/*.hh)

# file(GLOB BASIC_USAGE_ENVIRONMENT_SRCS UsageEnvironment/*.c UsageEnvironment/*.cpp)

# add_library(BasicUsageEnvironment ${BASIC_USAGE_ENVIRONMENT_SRCS})

# target_include_directories(BasicUsageEnvironment
#     PUBLIC BasicUsageEnvironment/include
# )

# target_link_libraries(BasicUsageEnvironment
#     PUBLIC UsageEnvironment
# )

## Install library + targets ##################################################
include(CMakePackageConfigHelpers)

install(TARGETS groupsock
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


install(TARGETS groupsock
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
	${PROJECT_SOURCE_DIR}/cmake/config.cmake.in
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

# file(GLOB HEADERS
#         BasicUsageEnvironment/include/*.h*
#         groupsock/include/*.h*
#         liveMedia/include/*.h*
#         UsageEnvironment/include/*.h*
# )

install(
    FILES
        ${HEADERS}
        # ${PROJECT_BINARY_DIR}/version.h
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME})