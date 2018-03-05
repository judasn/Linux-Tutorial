# 安装的 rm（删除）

## 由来

- 我们都知道 `rm -rf` 是一个危险的操作，所以我们应该尽可能养成一个不要 rm 的习惯，而是 mv。

## 设置

- 创建一个用来存放要被我们删除的文件夹存放地：`cd $home && mkdir .trash`
- 赋予最高权限（个人习惯）：`chmod 777 .trash`
- 如果你使用 bash，你需要修改你的 home 目录下的：`.bashrc`
- 我使用的是 zsh，所以我修改：`vim .zshrc`，在文件的最后面增加下面内容：

```
# rm transform
function rm() {
    # garbage collect
    now=$(date +%s)
    for s in $(ls --indicator-style=none $HOME/.trash/) ;do
        dir_name=${s//_/-}
        dir_time=$(date +%s -d $dir_name)
        # if big than one month then delete
        if [[ 0 -eq dir_time || $(($now - $dir_time)) -gt 2592000 ]] ;then
            echo "Trash " $dir_name " has Gone "
            /bin/rm $s -rf
        fi
    done
    
    # add new folder
    prefix=$(date +%Y_%m_%d)
    hour=$(date +%H)
    mkdir -p $HOME/.trash/$prefix/$hour
    if [[ -z $1 ]] ;then
            echo 'Missing Args'
        return
    fi
    echo "Hi, Trashing" $1 "to /root/.trash"
    mv $1 $HOME/.trash/$prefix/$hour
}
```

- 刷新配置：`source ~/.zshrc`
- 然后断开终端，重新连接
- 此时如果你使用：`rm -rf a.txt` 会出现这样的提示：

```
Hi, Trashing -rf to /root/.trash
mv: invalid option -- 'r'
Try 'mv --help' for more information.
```

- 现在我们删除一个测试文件：`rm a.txt`，会事显示：`Hi, Trashing a.txt to /root/.trash`
- 因为我们上面的 shell 每次触发 rm 明白的时候都会去删除一个月前的目录，所以就不需要定时器来删除 .trash 里面的文件了。
- 如果你要强制删除，清空 .trash 目录，可以使用真正的 rm 命令：`/usr/bin/rm -rf ~/.trash/*`


## 资料

- <http://www.linuxde.net/2013/02/11915.html>
