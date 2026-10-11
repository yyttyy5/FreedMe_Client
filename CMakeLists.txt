cmake_minimum_required(VERSION 4.3)
project(freedMe_client)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

qt_add_executable(freedMe_client
        main.cpp
)

qt_add_qml_module(freedMe_client
        URI FreedMe
        QML_FILES
            Main.qml
)

target_link_libraries(freedMe_client
        PRIVATE
            Qt6::Quick
)