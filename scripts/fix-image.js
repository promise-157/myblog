const path = require('path');

hexo.extend.filter.register('before_post_render', function(data) {
    // 1. 打印：证明脚本被加载并开始处理文章
    console.log('====================================');
    console.log('[调试] 正在处理文章:', data.title);

    const postName = path.basename(data.source, '.md');
    
    // 2. 更加宽容的正则表达式
    // 匹配：![](文件名/图.png) 或 ![](./文件名/图.png) 或 ![](/文件名/图.png)
    const imgRegex = /!\[.*?\]\((?:\.\/|\/)?([^)]+?)\/([^)]+?)\)/g;

    // 记录匹配次数
    let matchCount = 0;

    data.content = data.content.replace(imgRegex, (match, folderName, fileName) => {
        // 只有文件夹名和文件名一致，或者是子文件夹时才转换
        if (folderName === postName || folderName.includes(postName)) {
            matchCount++;
            const newTag = `{% asset_img "${fileName}" %}`;
            console.log(`  [转换成功] ${match}  =>  ${newTag}`);
            return newTag;
        }
        return match;
    });

    if (matchCount === 0) {
        console.log('  [注意] 此文章未发现匹配路径的图片。');
    }
    
    return data;
});