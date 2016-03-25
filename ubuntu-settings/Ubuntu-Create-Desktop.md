# Ubuntu 给 Dash 添加程序图标

## 创建图标文件

- 我们建设以创建 Eclipse 程序图标为例
- 进入图标存放目录|：`cd /usr/share/applications`
- 创建文件并编辑：`sudo gedit eclipse.desktop`
``` ini
[Desktop Entry]
Name=eclipse
Name[zh_CN]=eclipse
Comment=eclipse Client
Exec=/usr/programa/tools/eclipse/eclipse
Icon=/usr/programa/tools/eclipse/icon.xpm
Terminal=false
Type=Application
Categories=Application;
Encoding=UTF-8
StartupNotify=true
```
- 重点参数说明（注意：路径使用完整路径）
    - Name 为你想要显示在 Launcher 中的名称
    - Comment 为说明。
    - Exec 为程序执行位置
    - Icon 为图标所在路径
- 最后，打开 Dash，在顶部搜索框搜索 **eclipse**，此时你应该能搜到它，先单击试一下看能不能打开，如果可以打开，拖到该图标启动器上，下次就可以直接从启动器打开了

## 资料

- 图文资料：<http://my.oschina.net/Obahua/blog/110612>
- 图文资料：<http://www.cnblogs.com/enein/articles/2818864.html>
- 图文资料：<http://blog.chinaunix.net/uid-26404477-id-3462663.html>
