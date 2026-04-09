---
title: 在vscode上进行qt编程
comments: true
cover: /gallery/defaultCover5.png
thumbnail: /gallery/defaultThumbnail5.png
tags:
  - 未分类
categories:
  - 使用教程
toc: true
excerpt: 详情请点击read more
date: 2026-04-05 14:17:03
description:
---

# 使用clangd插件
1. 安装好vscode上的clangd插件，将C_Cpp.intelliSenseEngine设置失能。
2. 本地下载sudo apt install clangd-12，然后绑定一下版本，
```
# 语法：sudo update-alternatives --install <链接> <名称> <路径> <优先级>
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-12 100
```
遇到报错可以在vscode的配置里面把path属性添加上。/usr/bin/clangd
3. 然后在你的编译文件cmake里启动即可。
4. clang是需要借助你build文件夹，因此找不到的话记得在设置: Arguments中加上--compile-commands-dir=build。vscode里面不要加引号。
5. 当然别忘了你可以写个settingjson文件便于移植。

# cmake文件语法和qt传统编程移植方法
1. 变量，set()，修改，如果没有就是定义功能。后续使用方法为：${}。
2. 自动生成变量：project(MyQtApp)，生成${PROJECT_NAME}。
3. 内置变量。
- 搜索路径变量：环境变量：CMAKE_PREFIX_PATH（自定义），PATH（默认）。
- 针对性变量：CMAKE_INCLUDE_PATH，CMAKE_LIBRARY_PATH，CMAKE_PROGRAM_PATH。
- CMAKE_CURRENT_SOURCE_DIR，执行当前的CMakeLists.txt路径。
4. find_package(Qt5 COMPONENTS Widgets Core Gui REQUIRED)。内填包名，子模块标识，子模块名，找不到时处理方法
5. target_link_libraries把声明好的包在编译时把二进制代码link上
6. add_executable(...)。生成可执行文件。
7. file(GLOB_RECURSE SRCS "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp")，搜索方法，变量名，正则表达式，因为add这些需要填入具体的名字，所以可以用这种方法使用变量代替。
8. CMakeLists.txt是主入口。.cmake文件是脚本，通过include()和find_package()调用。进行辅助功能：设置变量、编写宏、辅助搜索路径。这里就可以用cmake文件代替qt编程里的pri文件。
9. target_include_directories告诉编译器包含路径。
10. pro功能替代：
```
find_package(Qt5 COMPONENTS Widgets Core Gui Network REQUIRED)

target_link_libraries(MyQtApp PRIVATE 
    Qt5::Widgets 
    Qt5::Core 
    Qt5::Gui
    Qt5::Network
)
```
# 交叉编译在vscode上的使用
1. 先去正点原子资料里安装好交叉编译器：fsl-imx-x11-glibc-x86_64-meta-toolchain-qt5-cortexa7hf-neon-toolchain-4.1.15-2.1.0_20241230.sh
2. 然后在vscode，使用ctrl shift p调出指令，选择kits为交叉编译工具。如果你想要用正点原子source环境变量实现指定编译目标的话需要选未指定。然后他会使用环境变量，但是我没试过就不细说了。
3. 修改cmake：声明sysroot变量。需要写在project前面
```
set(SDK_TARGET_SYSROOT "/opt/fsl-imx-x11/4.1.15-2.1.0/sysroots/cortexa7hf-neon-poky-linux-gnueabi")
set(CMAKE_SYSROOT ${SDK_TARGET_SYSROOT})
set(CMAKE_FIND_ROOT_PATH ${SDK_TARGET_SYSROOT})
project(MyQtApp)

# 指向交叉编译环境中的 Qt 配置路径
set(Qt5_DIR "${CMAKE_SYSROOT}/usr/lib/cmake/Qt5")#这个不知道有没有必要，我也懒得删除懒得验证了。
```
4. 在setting.json指定编译工具链：我的理解是前面指定的是编译器路径，这里声明的是什么语言对应什么编译工具，毕竟有gcc和g++两种。这里顺便把clangd也改了，不改的话也能跳转qt的库函数但是好像跳转不到arm库的定义，但是都能编译成功。
```
{
    "clangd.path": "/usr/bin/clangd",
    /* 核心：添加 clangd 启动参数 */
    "clangd.arguments": [
        "--compile-commands-dir=build",
        "--query-driver=/opt/fsl-imx-x11/4.1.15-2.1.0/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi/arm-poky-linux-gnueabi*",
        "--header-insertion=never",
        "--clang-tidy",
        "--all-scopes-completion",
        "--completion-style=detailed"
    ],

    "cmake.configureSettings":{
       // 因为我们把逻辑写进 CMakeLists 了，这里不需要指向 .cmake 文件了
        // 但为了保险，可以把 Sysroot 也传进去
        "CMAKE_SYSROOT": "/opt/fsl-imx-x11/4.1.15-2.1.0/sysroots/cortexa7hf-neon-poky-linux-gnueabi"
    },
    "cmake.environment": {
        "CFLAGS": "-march=armv7-a -mfloat-abi=hard -mfpu=neon -mtune=cortex-a7",
        "CXXFLAGS": "-march=armv7-a -mfloat-abi=hard -mfpu=neon -mtune=cortex-a7"
    }

}
```