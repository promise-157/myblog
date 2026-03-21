@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: --- 配置区 ---
set LAYOUT=post
if "%1"=="leetcode" (
    set LAYOUT=leetcode
    echo [模式] 已切换为 LeetCode 刷题模式
) else if not "%1"=="" (
    set LAYOUT=%1
    echo [模式] 已切换为自定义模式: %1
)

:: 1. 输入标题
set /p post_title="请输入标题 (直接回车用时间戳): "
if "!post_title!"=="" (
    set post_title=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%
)

:: 2. 执行 hexo new (指定布局)
echo [Hexo] 正在使用模板 [%LAYOUT%] 创建文章: %post_title%...
call hexo new %LAYOUT% "%post_title%"

:: 3. 定位文件路径并同步移动资产文件夹
set safe_title=%post_title: =-%
set source_md=source\_posts\%safe_title%.md
set source_dir=source\_posts\%safe_title%

if "%LAYOUT%"=="leetcode" (
    :: 创建 leetcode 子目录
    if not exist "source\_posts\leetcode" mkdir "source\_posts\leetcode"
    
    :: 关键修正：同时移动文章和对应的同名文件夹
    if exist "!source_md!" move "!source_md!" "source\_posts\leetcode\" >nul
    if exist "!source_dir!" move "!source_dir!" "source\_posts\leetcode\" >nul
    
    set target_file=source\_posts\leetcode\%safe_title%.md
) else (
    set target_file=!source_md!
)

if not exist "%target_file%" (
    echo [错误] 找不到生成的文件: %target_file%
    pause
    exit /b
)

:: 4. 随机图片分配 (保持你原有的逻辑)
set /a random_num=%random% %% 5 + 1
set cover_path=/gallery/defaultCover%random_num%.png
set thumb_path=/gallery/defaultThumbnail%random_num%.png

:: 5. 替换占位符
set temp_file=%target_file%.tmp
(for /f "usebackq delims=" %%i in ("%target_file%") do (
    set "line=%%i"
    set "line=!line:COVER_PLACEHOLDER=%cover_path%!"
    set "line=!line:THUMBNAIL_PLACEHOLDER=%thumb_path%!"
    echo !line!
)) > "%temp_file%"

move /y "%temp_file%" "%target_file%" >nul


echo ---------------------------------------
echo [成功] 文章已创建: %target_file%
echo [布局] 使用模板: %LAYOUT%
echo ---------------------------------------
pause