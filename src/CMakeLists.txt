cmake_minimum_required(VERSION 3.14)
project(app)

include(CPack)

add_executable(app main.cpp)

install(TARGETS app RUNTIME DESTINATION bin)
