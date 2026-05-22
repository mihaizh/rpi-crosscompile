cmake_minimum_required(VERSION 3.14)
project(app)

include(CPack)

find_package(OpenCV REQUIRED)

add_executable(app main.cpp)
target_link_libraries(app PRIVATE ${OpenCV_LIBS})

install(TARGETS app RUNTIME DESTINATION bin)
