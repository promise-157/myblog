@echo off
:: 关键点 1：切换到 UTF-8 编码环境
chcp 65001 >nul
setlocal enabledelayedexpansion

:: 1. 输入标题
set /p post_title="请输入博文标题 (直接回车则使用时间戳): "
if "%post_title%"=="" (
    set post_title=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%
)

:: 2. 执行 hexo new
echo [Hexo] 正在创建文章: %post_title%...
call hexo new post "%post_title%"

:: 3. 定位文件路径 (处理空格转横杠)
set safe_title=%post_title: =-%
set target_file=source\_posts\%safe_title%.md

if not exist "%target_file%" (
    echo [错误] 找不到生成的文件: %target_file%
    pause
    exit /b
)

:: 4. 生成随机数 (1-5) 并设置封面
set /a random_num=%random% %% 1 + 1
set cover_path=/gallery/defaultCover%random_num%.png
set thumb_path=/gallery/defaultThumbnail%random_num%.png

:: 5. 替换占位符 (利用临时文件)
set temp_file=%target_file%.tmp

:: 关键点 2：增加 usebackq，并确保 type 读取时环境已是 UTF-8
(for /f "usebackq delims=" %%i in ("%target_file%") do (
    set "line=%%i"
    set "line=!line:COVER_PLACEHOLDER=%cover_path%!"
    set "line=!line:THUMBNAIL_PLACEHOLDER=%thumb_path%!"
    echo !line!
)) > "%temp_file%"

move /y "%temp_file%" "%target_file%" >nul

echo ---------------------------------------
echo [成功] 文章已创建: %target_file%
echo [封面] 已分配: %cover_path%
echo ---------------------------------------
pause