# 常见日常维护



## Vim 编辑文件报：Swap file "Hello.java.swp" already exists!

- 问题原因：
    - Vim 编辑 Hello.java 文件的时候，非正常退出，然后又重新再 Vim 这个文件一般都会提示这个。
- 解决办法：
    - 进入被编辑的文件目录，比如：Hello.java 我放在 /opt 目录下，那就先：`cd /opt`，
    - 然后：`ls -A`，会发现有一个：.Hello.java.swp，把这个文件删除掉：`rm -rf .Hello.java.swp`，然后重新 Vim 文件即可。
    

