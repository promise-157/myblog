#!/bin/bash

# 1. 交互输入
read -p "[1/3] 输入大类 (回车则为未分类): " U_CAT
read -p "[2/3] 使用模板 (回车则用 post): " U_LYT
read -p "[3/3] 标题名字 (回车则用时间戳): " U_TTL

echo "========================================"

# 2. 处理默认值
[ -z "$U_LYT" ] && U_LYT="post"
[ -z "$U_CAT" ] && FINAL_CAT="未分类" || FINAL_CAT="$U_CAT"

# 生成时间戳 (格式: 20231027_1430)
STAMP=$(date +"%Y%m%d_%H%M")

# 处理标题：如果为空则用时间戳，空格替换为破折号
if [ -z "$U_TTL" ]; then
    FINAL_TITLE=$STAMP
else
    FINAL_TITLE=$(echo "$U_TTL" | tr ' ' '-')
fi

# 3. 确定路径 (Linux 使用正斜杠 /)
if [ -z "$U_CAT" ]; then
    REL_PATH="${FINAL_TITLE}/${FINAL_TITLE}.md"
else
    REL_PATH="${U_CAT}/${FINAL_TITLE}/${FINAL_TITLE}.md"
fi

echo "[Hexo] 正在创建文章..."
# 执行 hexo 命令
hexo new "$U_LYT" "$FINAL_TITLE" --path "$REL_PATH"

# 目标文件全路径
TARGET_FILE="source/_posts/$REL_PATH"

if [ ! -f "$TARGET_FILE" ]; then
    echo "[错误] 找不到文件: $TARGET_FILE"
    exit 1
fi

# 4. 随机图片逻辑
RANDOM_NUM=$(( ( RANDOM % 5 )  + 1 ))
COVER_PATH="/gallery/defaultCover${RANDOM_NUM}.png"
THUMB_PATH="/gallery/defaultThumbnail${RANDOM_NUM}.png"

echo "[处理] 正在写入数据..."

# 5. 使用 sed 进行文本替换
# -i 直接修改文件。Linux 下 sed 的语法与 Win 有别
# 替换占位符
sed -i "s|COVER_PLACEHOLDER|$COVER_PATH|g" "$TARGET_FILE"
sed -i "s|THUMBNAIL_PLACEHOLDER|$THUMB_PATH|g" "$TARGET_FILE"

# 处理分类：在 categories: 后面一行进行替换 (更安全的方式)
# 这里模拟原脚本逻辑：仅在 categories 区域替换“未分类”
sed -i "/categories:/,/tags:/ s/未分类/$FINAL_CAT/" "$TARGET_FILE"

echo "---------------------------------------"
echo "[成功] 文章已就绪: $FINAL_TITLE"
echo "[大类] $FINAL_CAT"
echo "---------------------------------------"
