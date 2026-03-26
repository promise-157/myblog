const path = require('path');
const fs = require('fs-extra');

hexo.extend.filter.register('before_post_render', function(data) {
    const postSrcDir = path.dirname(data.full_source);
    const postName = path.basename(data.source, '.md');
    // 关键：读取你的 root 配置 (/myblog/)
    const blogRoot = hexo.config.root || '/';

    // 正则：匹配所有 ![](...)，捕获组 1 为路径/文件名
    const imgRegex = /!\[.*?\]\((?:\.\/)?(?:([^/)]+)\/)?([^)]+?)\)/g;

    data.content = data.content.replace(imgRegex, (match, pathPart, fileName) => {
        // 判定：同级图片 (pathPart为空) 或 同名文件夹图片 (pathPart === postName)
        if (!pathPart || pathPart === postName) {
            
            // 寻找物理原图
            let srcPath = path.join(postSrcDir, postName, fileName);
            if (!fs.existsSync(srcPath)) {
                srcPath = path.join(postSrcDir, fileName);
            }

            if (fs.existsSync(srcPath)) {
                // 1. 强制搬运图片到 public 对应位置
                // data.path 已经是 :year/:month/:day/:title/ 结构
                const destPath = path.join(hexo.public_dir, data.path, fileName);
                fs.ensureDirSync(path.dirname(destPath));
                fs.copySync(srcPath, destPath);

                // 2. 生成带 root 前缀的路径，解决子目录虚无问题
                const webPath = path.join(blogRoot, data.path, fileName).replace(/\\/g, '/');
                
                // console.log(`[同步成功] ${postName} -> ${webPath}`);
                return `<img src="${webPath}" alt="${fileName}">`;
            }
        }
        return match;
    });

    return data;
});