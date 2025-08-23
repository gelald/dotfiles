# non-dot

这个目录存放一些不是 `.` 开头的配置文件，因为 rcm 对于一些不是 `.` 开头的配置文件的支持度不够好，
rcm 生成的快捷方式都是有一个 `.` 开头的。

## 软链接

既然 rcm 的支持度不够好，我们使用另一种更原始的解决方案：软链接，我们使用的命令是 `ln`

1. 移动配置文件到统一目录中
    ```shell
    mv ~/app/setting.json ~/dotfiles/app_setting.json
    ```

2. 创建这个文件的快捷方式到原有位置中
   ```shell
   ln -s ~/dotfiles/app_setting.json ~/app/setting.json
   ```

---

```shell
ln -s dotfiles/non-dot/kitty ~/.config/kitty

ln -s dotfiles/non-dot/starship.toml ~/.config/starship.toml

# iTerm2.json 是 iTerm2 的配置文件；Nord.terminal 是 macOS Terminal 的配置文件（包含配色、字体等）
```