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