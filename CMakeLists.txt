cmake_minimum_required(VERSION 3.16)

project(harbour-confla LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include(GNUInstallDirs)
include(FeatureSummary)

find_package(Qt5 COMPONENTS Core Gui Quick Sql DBus LinguistTools REQUIRED)

if(NOT DEFINED FLAVOR)
    message(FATAL_ERROR "Please specify the platform using -DFLAVOR=platform as a CMake option. Supported platforms: kirigami, silica, qtcontrols, uuitk.")
elseif(FLAVOR STREQUAL "silica")
    add_definitions(-DMER_EDITION_SAILFISH)
elseif(FLAVOR STREQUAL "kirigami")
    add_definitions(-Dflavor_kirigami)
elseif(FLAVOR STREQUAL "qtcontrols")
    add_definitions(-Dflavor_qtcontrols)
elseif(FLAVOR STREQUAL "uuitk")
    add_definitions(-DUUITK_EDITION)
    add_subdirectory(click)
else()
    message(FATAL_ERROR "Unsupported platform '${FLAVOR}'. Supported platforms: kirigami, silica, qtcontrols, uuitk.")
endif()

file(GLOB TS_FILES translations/*.ts)

if(FLAVOR STREQUAL "uuitk")
    add_definitions(-DTRANSLATION_FOLDER="./share/harbour-confla/translations")
else()
    add_definitions(-DTRANSLATION_FOLDER="${CMAKE_INSTALL_FULL_DATAROOTDIR}/harbour-confla/translations")
endif()

list(APPEND RESOURCES confla.qrc)
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/platform-${FLAVOR}.qrc")
    list(APPEND RESOURCES "platform-${FLAVOR}.qrc")
else()
    message(WARNING "Resource file 'platform-${FLAVOR}.qrc' not found. Proceeding without it.")
endif()

set(SOURCES
    ./src/main.cpp
    ./src/customnetworkaccessmanager.cpp
    ./src/downloader.cpp
    ./src/filereader.cpp
    ./src/networkaccessmanagerfactory.cpp
)

set(HEADERS
    ./src/customnetworkaccessmanager.h
    ./src/downloader.h
    ./src/filereader.h
    ./src/networkaccessmanagerfactory.h
)

add_executable(harbour-confla
  ${SOURCES}
  ${HEADERS}
  ${RESOURCES}
  ${TS_FILES}
)
find_package(Qt5 COMPONENTS Gui Widgets Quick Positioning REQUIRED)

QT5_ADD_TRANSLATION(QM_FILES ${TS_FILES} OPTIONS -idbased)
add_custom_target(ui_translations DEPENDS ${QM_FILES})
add_dependencies(harbour-confla ui_translations)

QT5_CREATE_TRANSLATION(QT_FILES "${CMAKE_SOURCE_DIR}"
    OPTIONS "-no-obsolete")

install(FILES ${QM_FILES}
    DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/harbour-confla/translations")

install(TARGETS harbour-confla RUNTIME
        DESTINATION ${CMAKE_INSTALL_BINDIR})

target_include_directories(harbour-confla PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/..
)

target_compile_definitions(harbour-confla
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(harbour-confla
  PRIVATE 
  Qt5::Core Qt5::Widgets Qt5::Quick Qt5::Positioning
  ${SAILFISH_LDFLAGS}
)

if(FLAVOR STREQUAL "silica")
    target_include_directories(harbour-confla PRIVATE
        $<BUILD_INTERFACE:
        ${SAILFISH_INCLUDE_DIRS}
        >)
endif()

install(FILES "harbour-confla.desktop"
    DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/applications")


if(FLAVOR STREQUAL "uuitk")

#install(FILES "icons/108x108/harbour-confla.png"
#    DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/108x108/apps")

#install(FILES "icons/172x172/harbour-confla.png"
#    DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/172x172/apps")

#install(FILES "icons/128x128/harbour-confla.png"
#    DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/128x128/apps")

#install(FILES "icons/86x86/harbour-confla.png"
#    DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/86x86/apps")

#install(FILES "icons/scalable/harbour-confla.svg"
#    DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/scalable/apps")

endif()

#install(FILES "harbour-confla.appdata.xml"
#    DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/metainfo")

file(WRITE "${CMAKE_BINARY_DIR}/QtCreatorDeployment.txt"
    "${CMAKE_INSTALL_PREFIX}\n${CMAKE_BINARY_DIR}/harbour-confla:bin\n")
