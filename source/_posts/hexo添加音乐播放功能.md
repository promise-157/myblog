---
title: hexo添加音乐播放功能
comments: true
cover: /gallery/defaultCover1.png
thumbnail: /gallery/defaultThumbnail1.png
tags:
  - 未分类
categories:
  - 未分类
date: 2026-03-20 20:17:31
description:
---
- [生成底部播放器界面](#生成底部播放器界面)
- [背景音乐播放](#背景音乐播放)
- [进入特定md博文播放音乐](#进入特定md博文播放音乐)
- [三种功能切换](#三种功能切换)

<div id="enable-music"></div>

## 生成底部播放器界面
1. 首先只能网易云，需要获取id。
2. icarus v5.1.0
3. `npm install hexo-tag-aplayer --save`安装
4. 找到footer.jsx配置文件。将第一行改为： 
 `const { Component, Fragment } = require('inferno');`
5. 把return改为：
```
return <Fragment>
    <footer class="footer"> ... </footer>
    {/* 注入 CSS 和 JS */}
    <link rel="stylesheet" href="https://cdn.staticfile.net/aplayer/1.10.1/APlayer.min.css" />
    <script src="https://cdn.staticfile.net/aplayer/1.10.1/APlayer.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/meting@2.0.1/dist/Meting.min.js"></script>
    <meting-js
        server="kugou" 
        type="playlist" 
        id="3zissqg2zdz0f6" 
        fixed="true" 
        theme="#3273dc">
    </meting-js>
</Fragment>;
```
6. 我的原文件
```
const { Component } = require('inferno');

const { cacheComponent } = require('hexo-component-inferno/lib/util/cache');



class Footer extends Component {

    render() {

        const {

            logo,

            logoUrl,

            siteUrl,

            siteTitle,

            siteYear,

            author,

            links,

            copyright,

            showVisitorCounter,

            visitorCounterTitle

        } = this.props;



        let footerLogo = '';

        if (logo) {

            if (logo.text) {

                footerLogo = logo.text;

            } else {

                footerLogo = <img src={logoUrl} alt={siteTitle} height="28" />;

            }

        } else {

            footerLogo = siteTitle;

        }



        return <footer class="footer">

            <div class="container">

                <div class="level">

                    <div class="level-start">

                        <a class="footer-logo is-block mb-2" href={siteUrl}>

                            {footerLogo}

                        </a>

                        <p class="is-size-7">

                            <span dangerouslySetInnerHTML={{ __html: `&copy; ${siteYear} ${author || siteTitle}` }}></span>

                            &nbsp;&nbsp;Powered by <a href="https://hexo.io/" target="_blank" rel="noopener">Hexo</a>&nbsp;&&nbsp;

                            <a href="https://github.com/ppoffice/hexo-theme-icarus" target="_blank" rel="noopener">Icarus</a>

                            {showVisitorCounter ? <br /> : null}

                            {showVisitorCounter ? <span id="busuanzi_container_site_uv"

                                dangerouslySetInnerHTML={{ __html: visitorCounterTitle }}></span> : null}

                        </p>

                        {copyright ? <p class="is-size-7" dangerouslySetInnerHTML={{ __html: copyright }}></p> : null}

                    </div>

                    <div class="level-end">

                        {Object.keys(links).length ? <div class="field has-addons">

                            {Object.keys(links).map(name => {

                                const link = links[name];

                                return <p class="control">

                                    <a class={`button is-transparent ${link.icon ? 'is-large' : ''}`} target="_blank" rel="noopener" title={name} href={link.url}>

                                        {link.icon ? <i class={link.icon}></i> : name}

                                    </a>

                                </p>;

                            })}

                        </div> : null}

                    </div>

                </div>

            </div>

        </footer>;

    }

}



module.exports = cacheComponent(Footer, 'common.footer', props => {

    const { config, helper } = props;

    const { url_for, _p, date } = helper;

    const { logo, title, author, footer, plugins } = config;



    const links = {};

    if (footer && footer.links) {

        Object.keys(footer.links).forEach(name => {

            const link = footer.links[name];

            links[name] = {

                url: url_for(typeof link === 'string' ? link : link.url),

                icon: link.icon

            };

        });

    }



    return {

        logo,

        logoUrl: url_for(logo),

        siteUrl: url_for('/'),

        siteTitle: title,

        siteYear: date(new Date(), 'YYYY'),

        author,

        links,

        copyright: footer?.copyright ?? '',

        showVisitorCounter: plugins && plugins.busuanzi === true,

        visitorCounterTitle: _p('plugin.visitor_count', '<span id="busuanzi_value_site_uv">0</span>')

    };

});
```
7. 修改后的文件
```
const { Component, Fragment } = require('inferno'); // 这里增加了 Fragment
const { cacheComponent } = require('hexo-component-inferno/lib/util/cache');

class Footer extends Component {
    render() {
        const {
            logo,
            logoUrl,
            siteUrl,
            siteTitle,
            siteYear,
            author,
            links,
            copyright,
            showVisitorCounter,
            visitorCounterTitle
        } = this.props;

        let footerLogo = '';
        if (logo) {
            if (logo.text) {
                footerLogo = logo.text;
            } else {
                footerLogo = <img src={logoUrl} alt={siteTitle} height="28" />;
            }
        } else {
            footerLogo = siteTitle;
        }

        return <Fragment>
            <footer class="footer">
                <div class="container">
                    <div class="level">
                        <div class="level-start">
                            <a class="footer-logo is-block mb-2" href={siteUrl}>
                                {footerLogo}
                            </a>
                            <p class="is-size-7">
                                <span dangerouslySetInnerHTML={{ __html: `&copy; ${siteYear} ${author || siteTitle}` }}></span>
                                &nbsp;&nbsp;Powered by <a href="https://hexo.io/" target="_blank" rel="noopener">Hexo</a>&nbsp;&&nbsp;
                                <a href="https://github.com/ppoffice/hexo-theme-icarus" target="_blank" rel="noopener">Icarus</a>
                                {showVisitorCounter ? <br /> : null}
                                {showVisitorCounter ? <span id="busuanzi_container_site_uv"
                                    dangerouslySetInnerHTML={{ __html: visitorCounterTitle }}></span> : null}
                            </p>
                            {copyright ? <p class="is-size-7" dangerouslySetInnerHTML={{ __html: copyright }}></p> : null}
                        </div>
                        <div class="level-end">
                            {Object.keys(links).length ? <div class="field has-addons">
                                {Object.keys(links).map(name => {
                                    const link = links[name];
                                    return <p class="control">
                                        <a class={`button is-transparent ${link.icon ? 'is-large' : ''}`} target="_blank" rel="noopener" title={name} href={link.url}>
                                            {link.icon ? <i class={link.icon}></i> : name}
                                        </a>
                                    </p>;
                                })}
                            </div> : null}
                        </div>
                    </div>
                </div>
            </footer>
            {/* 这里的音乐播放器代码会被注入到页面最底部 */}
            <link rel="stylesheet" href="https://cdn.staticfile.net/aplayer/1.10.1/APlayer.min.css" />
            <script src="https://cdn.staticfile.net/aplayer/1.10.1/APlayer.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/meting@2.0.1/dist/Meting.min.js"></script>
            <meting-js
                server="netease"
                type="playlist"
                id="13312157228"
                fixed="true"
                autoplay="false"
                loop="all"
                order="random"
                preload="auto"
                list-folded="true"
                theme="#3273dc">
            </meting-js>
        </Fragment>;
    }
}

module.exports = cacheComponent(Footer, 'common.footer', props => {
    const { config, helper } = props;
    const { url_for, _p, date } = helper;
    const { logo, title, author, footer, plugins } = config;

    const links = {};
    if (footer && footer.links) {
        Object.keys(footer.links).forEach(name => {
            const link = footer.links[name];
            links[name] = {
                url: url_for(typeof link === 'string' ? link : link.url),
                icon: link.icon
            };
        });
    }

    return {
        logo,
        logoUrl: url_for(logo),
        siteUrl: url_for('/'),
        siteTitle: title,
        siteYear: date(new Date(), 'YYYY'),
        author,
        links,
        copyright: footer?.copyright ?? '',
        showVisitorCounter: plugins && plugins.busuanzi === true,
        visitorCounterTitle: _p('plugin.visitor_count', '<span id="busuanzi_value_site_uv">0</span>')
    };
});
```
## 背景音乐播放
```
const { Component, Fragment } = require('inferno'); // 这里增加了 Fragment
const { cacheComponent } = require('hexo-component-inferno/lib/util/cache');

class Footer extends Component {
    render() {
        const {
            logo,
            logoUrl,
            siteUrl,
            siteTitle,
            siteYear,
            author,
            links,
            copyright,
            showVisitorCounter,
            visitorCounterTitle
        } = this.props;

        let footerLogo = '';
        if (logo) {
            if (logo.text) {
                footerLogo = logo.text;
            } else {
                footerLogo = <img src={logoUrl} alt={siteTitle} height="28" />;
            }
        } else {
            footerLogo = siteTitle;
        }

        return <Fragment>
            <footer class="footer">
                <div class="container">
                    <div class="level">
                        <div class="level-start">
                            <a class="footer-logo is-block mb-2" href={siteUrl}>
                                {footerLogo}
                            </a>
                            <p class="is-size-7">
                                <span dangerouslySetInnerHTML={{ __html: `&copy; ${siteYear} ${author || siteTitle}` }}></span>
                                &nbsp;&nbsp;Powered by <a href="https://hexo.io/" target="_blank" rel="noopener">Hexo</a>&nbsp;&&nbsp;
                                <a href="https://github.com/ppoffice/hexo-theme-icarus" target="_blank" rel="noopener">Icarus</a>
                                {showVisitorCounter ? <br /> : null}
                                {showVisitorCounter ? <span id="busuanzi_container_site_uv"
                                    dangerouslySetInnerHTML={{ __html: visitorCounterTitle }}></span> : null}
                            </p>
                            {copyright ? <p class="is-size-7" dangerouslySetInnerHTML={{ __html: copyright }}></p> : null}
                        </div>
                        <div class="level-end">
                            {Object.keys(links).length ? <div class="field has-addons">
                                {Object.keys(links).map(name => {
                                    const link = links[name];
                                    return <p class="control">
                                        <a class={`button is-transparent ${link.icon ? 'is-large' : ''}`} target="_blank" rel="noopener" title={name} href={link.url}>
                                            {link.icon ? <i class={link.icon}></i> : name}
                                        </a>
                                    </p>;
                                })}
                            </div> : null}
                        </div>
                    </div>
                </div>
            </footer>
            {/* 这里的音乐播放器代码会被注入到页面最底部 */}
            <link rel="stylesheet" href="https://cdn.staticfile.net/aplayer/1.10.1/APlayer.min.css" />
            <script src="https://cdn.staticfile.net/aplayer/1.10.1/APlayer.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/meting@2.0.1/dist/Meting.min.js"></script>
        <div style="display:none">
            <meting-js
                server="netease"
                type="playlist"
                id="13312157228"
                fixed="false"
                autoplay="true"
                loop="all"
                order="random"
                preload="auto"
                list-folded="true"
                theme="#3273dc">
            </meting-js>
            </div>
            {/* 强制自动播放脚本：尝试在用户点击页面任何地方时触发播放 */}
<script dangerouslySetInnerHTML={{ __html: `
    document.addEventListener('click', function() {
        var ap = document.querySelector('meting-js').aplayer;
        if (ap && ap.paused) {
            ap.play();
        }
    }, { once: true });
` }} />
{/* --- 隐藏式背景音乐结束 --- */}
        </Fragment>;
    }
}

module.exports = cacheComponent(Footer, 'common.footer', props => {
    const { config, helper } = props;
    const { url_for, _p, date } = helper;
    const { logo, title, author, footer, plugins } = config;

    const links = {};
    if (footer && footer.links) {
        Object.keys(footer.links).forEach(name => {
            const link = footer.links[name];
            links[name] = {
                url: url_for(typeof link === 'string' ? link : link.url),
                icon: link.icon
            };
        });
    }

    return {
        logo,
        logoUrl: url_for(logo),
        siteUrl: url_for('/'),
        siteTitle: title,
        siteYear: date(new Date(), 'YYYY'),
        author,
        links,
        copyright: footer?.copyright ?? '',
        showVisitorCounter: plugins && plugins.busuanzi === true,
        visitorCounterTitle: _p('plugin.visitor_count', '<span id="busuanzi_value_site_uv">0</span>')
    };
});
```
主要是增加了个点击播放功能。

## 进入特定md博文播放音乐
1. 首先是添加条件
```
<div id="enable-music"></div>在文章内插入
```
2.  修改文件
```
const { Component, Fragment } = require('inferno');
const { cacheComponent } = require('hexo-component-inferno/lib/util/cache');

class Footer extends Component {
    render() {
        const {
            logo,
            logoUrl,
            siteUrl,
            siteTitle,
            siteYear,
            author,
            links,
            copyright,
            showVisitorCounter,
            visitorCounterTitle
        } = this.props;

        let footerLogo = '';
        if (logo) {
            if (logo.text) {
                footerLogo = logo.text;
            } else {
                footerLogo = <img src={logoUrl} alt={siteTitle} height="28" />;
            }
        } else {
            footerLogo = siteTitle;
        }

        return <Fragment>
            <footer class="footer">
                <div class="container">
                    <div class="level">
                        <div class="level-start">
                            <a class="footer-logo is-block mb-2" href={siteUrl}>
                                {footerLogo}
                            </a>
                            <p class="is-size-7">
                                <span dangerouslySetInnerHTML={{ __html: `&copy; ${siteYear} ${author || siteTitle}` }}></span>
                                &nbsp;&nbsp;Powered by <a href="https://hexo.io/" target="_blank" rel="noopener">Hexo</a>&nbsp;&&nbsp;
                                <a href="https://github.com/ppoffice/hexo-theme-icarus" target="_blank" rel="noopener">Icarus</a>
                                {showVisitorCounter ? <br /> : null}
                                {showVisitorCounter ? <span id="busuanzi_container_site_uv"
                                    dangerouslySetInnerHTML={{ __html: visitorCounterTitle }}></span> : null}
                            </p>
                            {copyright ? <p class="is-size-7" dangerouslySetInnerHTML={{ __html: copyright }}></p> : null}
                        </div>
                        <div class="level-end">
                            {Object.keys(links).length ? <div class="field has-addons">
                                {Object.keys(links).map(name => {
                                    const link = links[name];
                                    return <p class="control">
                                        <a class={`button is-transparent ${link.icon ? 'is-large' : ''}`} target="_blank" rel="noopener" title={name} href={link.url}>
                                            {link.icon ? <i class={link.icon}></i> : name}
                                        </a>
                                    </p>;
                                })}
                            </div> : null}
                        </div>
                    </div>
                </div>
            </footer>

            {/* --- 智能背景音乐系统开始 --- */}
            {/* 1. 加载核心资源 */}
            <link rel="stylesheet" href="https://cdn.staticfile.net/aplayer/1.10.1/APlayer.min.css" />
            <script src="https://cdn.staticfile.net/aplayer/1.10.1/APlayer.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/meting@2.0.1/dist/Meting.min.js"></script>

            {/* 2. 隐藏的播放器容器 */}
            <div id="music-storage" style={{ display: 'none' }}></div>

            {/* 3. 核心探测脚本：兼容普通文章与加密文章 */}
            <script dangerouslySetInnerHTML={{ __html: `
                (function() {
                    var retryCount = 0;
                    var checkMusic = setInterval(function() {
                        // 探测文章中是否存在开启音乐的“暗号”标签
                        var trigger = document.getElementById('enable-music');
                        if (trigger) {
                            clearInterval(checkMusic);
                            var storage = document.getElementById('music-storage');
                            // 动态注入 MetingJS 标签，确保在解密后或页面加载后初始化
                            storage.innerHTML = '<meting-js server="netease" type="playlist" id="13312157228" fixed="false" autoplay="true" loop="all" order="random" preload="auto"></meting-js>';
                            
                            // 浏览器策略：监听第一次点击以启动音频上下文
                            document.addEventListener('click', function() {
                                var el = document.querySelector('meting-js');
                                if (el && el.aplayer && el.aplayer.paused) {
                                    el.aplayer.play();
                                }
                            }, { once: true });
                        }
                        // 如果 10 秒内都没发现暗号（比如在首页），则停止探测
                        if (retryCount++ > 20) clearInterval(checkMusic);
                    }, 500);
                })();
            ` }} />
            {/* --- 智能背景音乐系统结束 --- */}

        </Fragment>;
    }
}

module.exports = cacheComponent(Footer, 'common.footer', props => {
    const { config, helper } = props;
    const { url_for, _p, date } = helper;
    const { logo, title, author, footer, plugins } = config;

    const links = {};
    if (footer && footer.links) {
        Object.keys(footer.links).forEach(name => {
            const link = footer.links[name];
            links[name] = {
                url: url_for(typeof link === 'string' ? link : link.url),
                icon: link.icon
            };
        });
    }

    return {
        logo,
        logoUrl: url_for(logo),
        siteUrl: url_for('/'),
        siteTitle: title,
        siteYear: date(new Date(), 'YYYY'),
        author,
        links,
        copyright: footer?.copyright ?? '',
        showVisitorCounter: plugins && plugins.busuanzi === true,
        visitorCounterTitle: _p('plugin.visitor_count', '<span id="busuanzi_value_site_uv">0</span>')
    };
});
```
改动较大，是因为为了解决加密文章的tags获取

## 三种功能切换
1. 直接复制文章里的代码替换footer.jsx
2. 取消容器隐藏：
把容器的 display: none 删掉。
开启吸附模式：把 meting-js 的参数 fixed 改为 true。
```
{/* 1. 这里删掉 style={{ display: 'none' }} */}
<div id="music-storage"></div> 

<script dangerouslySetInnerHTML={{ __html: `
    (function() {
        var checkMusic = setInterval(function() {
            var trigger = document.getElementById('enable-music');
            if (trigger) {
                clearInterval(checkMusic);
                var storage = document.getElementById('music-storage');
                // 2. 这里把 fixed="false" 改为 fixed="true"
                storage.innerHTML = '<meting-js server="netease" type="playlist" id="13312157228" fixed="true" autoplay="true" loop="all" order="random"></meting-js>';
                
                // 监听点击启动
                document.addEventListener('click', function() {
                    var el = document.querySelector('meting-js');
                    if (el && el.aplayer && el.aplayer.paused) {
                        el.aplayer.play();
                    }
                }, { once: true });
            }
        }, 500);
    })();
` }} />
```
3. 全局背景音乐：
   直接删掉所有的 setInterval 探测脚本，把播放器直接“写死”在 Fragment 里。
```
{/* --- 直接把这段贴在 </footer> 后面即可 --- */}
<link rel="stylesheet" href="https://cdn.staticfile.net/aplayer/1.10.1/APlayer.min.css" />
<script src="https://cdn.staticfile.net/aplayer/1.10.1/APlayer.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/meting@2.0.1/dist/Meting.min.js"></script>

{/* 如果想隐藏就加 style={{display:'none'}}，想显示就不加 */}
<div id="global-music">
    <meting-js
        server="netease"
        type="playlist"
        id="13312157228"
        fixed="true" 
        autoplay="true"
        loop="all"
        order="random">
    </meting-js>
</div>

<script dangerouslySetInnerHTML={{ __html: `
    document.addEventListener('click', function() {
        var el = document.querySelector('meting-js');
        if (el && el.aplayer && el.aplayer.paused) {
            el.aplayer.play();
        }
    }, { once: true });
` }} />
```
> 其实我觉得直接复制粘贴全部代码最省事。。。