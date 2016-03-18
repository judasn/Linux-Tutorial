# Github 协同合作（基于 IntelliJ IDEA）

## 假设场景

- 项目 `Linux-Tutorial`：<https://github.com/judasn/Linux-Tutorial>
- 项目发起者：judasn：<https://github.com/judasn>
- 参与人 A：YouMeek：<https://github.com/YouMeek>
- judasn 使用 Firefox 浏览器 + IntelliJ IDEA 15.0.4
- YouMeek 使用 Chrome 浏览器 + IntelliJ IDEA 2016.1


## 协同场景

- 项目 Linux-Tutorial 属于 judasn，我暂且称此为：`源项目`
- YouMeek Fork 了一份 Linux-Tutorial 项目，我暂且称此为：`副项目`
- YouMeek 在 `副项目` 中进行修改内容
- YouMeek 要把自己修改的内容提交到 `源项目`


## 协同细节

- 此时 judasn 需要做的：
    - 按生活习惯，继续在 `源项目` 上进行开发
- 此时 YouMeek 需要做的：
    - 先 pull request 做更新，把 `源项目` 最近更新的内容跟 `副项目` 进行合并
    - 把 `副项目` 中自己所做的修改 pull request 给 `源项目`

