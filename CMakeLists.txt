cmake_minimum_required(VERSION 4.3)
project(Messenger_client)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core WebSockets)

qt_standard_project_setup()

qt_add_executable(Messenger_client
        main.cpp
)

target_link_libraries(Messenger_client
        PRIVATE
        Qt6::Core
        Qt6::WebSockets
)