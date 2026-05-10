---
title: CMake语法
comments: true
cover: /gallery/defaultCover1.png
thumbnail: /gallery/defaultThumbnail1.png
tags:
  - 未分类
categories:
  - 笔记
toc: true
excerpt: 详情请点击read more
date: 2026-05-09 14:22:54
description:
---
# 语法
## include
用于包含别的cmake文件，相当于把其他文件的内容完全粘贴了过来
## execute_process
执行子进程
## define_property与set_property
自定义属性,set去绑定
## set
设置变量，可以有cache缓存，这个缓存有修改，存储位置不同的作用。
## add_subdirectory
添加子目录，会自动进入该目录执行cmake脚本，include的cmake可以共享当前文件的作用域的变量函数等。添加子目录则是引入独立的脚本
## include_directories和target_include_directories
都是添加目录到编译器头文件搜索中，后缀可以让添加关系更清晰
## link_directories和target_link_directories
添加编译好的库文件搜索目录，这些目录下是存.a，.so或者.lib文件的，分别为静态库，动态库和接口库
## option
提供一个布尔缓存变量，用于条件编译
## add_library
生成一个库文件，之后可以使用link_directories把这个库链接到其他目标
## add_executable
生成可执行文件
## add_custom_target
创建伪目标，正常的目标由add_executable，add_library，以及本例创建，这些目标都有自己的属性，链接库和头文件以及编译选项，通常会make所有目标当然也可以直接指定目标编译，make==make all
## add_custom_command
自定义构建命令，可以声明一个文件或者多个文件由指定命令生成，也可以声明一个目标执行前后进行额外的命令
## add_dependencies
指目标之间的依赖，确保生成一个目标构建前另一个目标一生成
# 指令
## make cmake ninja
make ninja属于底层，cmake属于上层，cmake读取cmake脚本生成make和ninja文件。  
cmake生成的文件在执行cmake指令的那个路径，但是他会生成很多文件所以通常用build装，默认生成make文件，生成ninja文件使用cmake -G Ninja ..
ninja更快更现代。
## make install指令
将编译好的程序、库、头文件、配置等复制到系统目录也可以用户指定，安装后其他项目可以通过find_package使用  
可执行文件放到/usr/local/bin后可以直接在终端输入名字执行。补充一下这个路径的作用，通常情况下编译器会去这个地方找东西，/local是用户自己安装的。/usr/下是系统级别的通常只读。
## CMakeLists.txt和.cmake文件的区别
.cmake可以通过 include() 或 find_package()，可以通过cmake命令行使用但是内部不能执行构建目标的指令，通常用于大型CMakeLists.txt的模块化拆分
## project
其实就起到一些版本信息的影响，所以cmake.txt通常在子模块下可以不用也可以用，但是.cmake一定不能有，因为他可能会用include包含，这种包含类似于粘贴，会污染cmake.txt的信息。