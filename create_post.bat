@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

set /p "U_CAT=[1/3] 输入大类 (回车则为未分类): "
set /p "U_LYT=[2/3] 使用模板 (回车则用 post): "
set /p "U_TTL=[3/3] 标题名字 (回车则用时间戳): "
echo ========================================

if "%U_LYT%"=="" set "U_LYT=post"
set "STAMP=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%"
set "STAMP=%STAMP: =0%"
set "STAMP=%STAMP::=%"

set "FINAL_TITLE=%U_TTL%"
if "%FINAL_TITLE%"=="" set "FINAL_TITLE=%STAMP%"
set "FINAL_TITLE=%FINAL_TITLE: =-%"

set "FINAL_CAT=%U_CAT%"
if "%FINAL_CAT%"=="" set "FINAL_CAT=未分类"

if "%U_CAT%"=="" (
    set "REL_PATH=%FINAL_TITLE%/%FINAL_TITLE%.md"
) else (
    set "REL_PATH=%U_CAT%/%FINAL_TITLE%/%FINAL_TITLE%.md"
)

echo [Hexo] 正在创建文章...
call hexo new "%U_LYT%" "%FINAL_TITLE%" --path "%REL_PATH%"

set "target_file=source\_posts\%REL_PATH:/=\%"

if not exist "%target_file%" (
    echo [错误] 找不到文件: "%target_file%"
    pause
    exit /b
)

set /a random_num=%random% %% 5 + 1
set "cover_path=/gallery/defaultCover%random_num%.png"
set "thumb_path=/gallery/defaultThumbnail%random_num%.png"

echo [处理] 正在写入数据...
set "temp_file=%target_file%.tmp"
set "in_cat=0"

(for /f "usebackq delims=" %%i in ("%target_file%") do (
    set "line=%%i"
    
    :: 封面替换
    if not "!line:COVER_PLACEHOLDER=!"=="!line!" set "line=!line:COVER_PLACEHOLDER=%cover_path%!"
    if not "!line:THUMBNAIL_PLACEHOLDER=!"=="!line!" set "line=!line:THUMBNAIL_PLACEHOLDER=%thumb_path%!"
    
    :: 状态切换：进入 categories 时打开开关，进入 tags 时关闭开关
    echo !line! | findstr /C:"categories:" >nul && set "in_cat=1"
    echo !line! | findstr /C:"tags:" >nul && set "in_cat=0"
    
    :: 只有在分类区才替换
    if "!in_cat!"=="1" (
        set "line=!line:未分类=%FINAL_CAT%!"
    )

    if "!line!"=="" (echo.) else (echo !line!)
)) > "%temp_file%"

move /y "%temp_file%" "%target_file%" >nul

echo ---------------------------------------
echo [成功] 文章已就绪: %FINAL_TITLE%
echo [大类] %FINAL_CAT%
echo ---------------------------------------
pause