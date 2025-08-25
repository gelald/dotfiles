# dotfiles

这个仓库用于管理我的 macOS 中的配置文件

## 什么是dotfiles

许多计算机软件程序将它们的配置设置存储在普通的、基于文本的文件或目录中。这些文件我们通常称为 `dotfile` 或者说 `.rc` 文件。
由于历史原因，`dotfile` 通常以点(`.`)开头，以(`rc`)结尾，比如 `.zshrc` 、 `.vimrc`，将它们与普通文件和目录区分开来的是它们的前缀，在基于
Unix 的系统中，`dotfile` 默认被操作系统隐藏。

## 管理 dotfiles 的方式

`dotfile` 文件痛点：**由于各款产品的配置文件的位置可能不同，管理起来很不方便**。

为了方便管理，我们把配置文件统一放到一个文件夹中管理，然后在用户根目录**用软链接的方式生成一个快捷键方式**
，这样访问用户目录的 `dotfile` 时，会自动打开那个统一管理的文件夹中对应的 `dotfile`

### rcm

有一款产品：[rcm](https://github.com/thoughtbot/rcm) ，可以帮助我们完成以上事情

rcm 天然支持了 `dotfile` 的统一管理与迁移，**特别地，适合管理 `~/` 下的配置文件**，其中 rcm 有四个命令：

- lsrc：列出当前所有通过 rcm 管理的 `dotfile` ，以及其对应的符号链接位置
- mkrc：将指定的 `dotfile` 移动至你的集中存储目录，并在 `~/` 目录下创建相应的符号链接
- rcup：根据 rcm 管理的 `dotfile` 更新当前用户目录下已存在的符号链接或创建新的符号链接
- rcdn：删除通过 rcm 创建的 `dotfile` 的符号链接

### ln -s

rcm 的做法存在一定的弊端：我们的配置文件除了 `dotfile` 外，还有一些其他的不是 `.` 开头的配置文件，比如一份 `.json`
格式的常见的配置文件，rcm 就不是特别满足，对于这种情况，我们可以使用 Unix 系统中的 `ln` 命令实现同样的效果

具体做法：

1. 移动配置文件到统一目录中
    ```shell
    mv ~/.bash_profile ~/dotfiles/base_profile
    ```

2. 创建这个文件的快捷方式到原有位置中
   ```shell
   ln -s ~/dotfiles/base_profile ~/.bash_profile
   ```

## 文件原位置

```shell
ln -sf dotfiles/shell/zshrc ~/.zhsrc

ln -sf dotfiles/shell/starship.toml ~/.config/starship.toml

ln -sf dotfiles/git/gitconfig ~/.gitconfig

ln -sf dotfiles/terminal/kitty ~/.config/kitty
 
# iTerm2.json 是 iTerm2 的配置文件；Terminal.terminal 是 macOS Terminal 的配置文件（包含配色、字体等）
# 他们可以打开 iTerm2 或者 Terminal 来直接导入配置
```

## 总结

使用软连接统一管理起来后，修改与查看配置文件就变得非常方便了，
**另外如果还可以使用 git 来实现配置的追溯，这也是这个仓库诞生的原因**

## 参考链接

[Dotfiles - 什么是Dotfile以及如何在Mac和Linux中创建它](https://juejin.cn/post/7023216265825107981)

[如何在Mac上利用rcm优雅地管理dotfiles配置文件](https://blog.csdn.net/qq_43827595/article/details/107459146)
