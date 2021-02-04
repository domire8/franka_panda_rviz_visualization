cmake_minimum_required(VERSION 3.0.2)
project(franka_panda_rviz_visualization)

find_package(catkin REQUIRED
    franka_panda_description
    )

catkin_package()


install(DIRECTORY launch
    DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
    )
