const path = require('path');

hexo.extend.filter.register('before_post_render', function(data) {
    // 获取当前文章的文件名（不含后缀）
    const postName = path.basename(data.source, '.md');
    
    // 正则升级：匹配 ![](任意路径/文件名.png)
    // 捕获组 1: 路径部分, 捕获组 2: 图片文件名
    const imgRegex = /!\[.*?\]\((?:\.\.\/|\.\/|\/)*([^/)]+?)\/([^)]+?)\)/g;

    let matchCount = 0;

    data.content = data.content.replace(imgRegex, (match, fullPath, fileName) => {
        // 核心逻辑：只要路径的最后一段是文章名，或者路径包含文章名
        // 这样无论是在 _posts/ 还是 _posts/leetcode/ 都能匹配上
        if (fullPath.endsWith(postName) || fullPath.includes('/' + postName)) {
            matchCount++;
            const newTag = `{% asset_img "${fileName}" %}`;
            return newTag;
        }
        return match;
    });

    return data;
});