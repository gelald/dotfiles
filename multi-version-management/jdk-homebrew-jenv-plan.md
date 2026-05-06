# JDK 统一管理方案：Homebrew + jEnv

## Context

当前机器上有 2 个 Oracle JDK（通过安装包安装）和 1 个浏览器插件 Java，路径都是硬编码的。目标是彻底清理后，统一用 Homebrew 安装 JDK 8/17/21/25，再用 jEnv 管理多版本切换。

## 当前状态

| 版本 | 安装方式 | 路径 |
|------|---------|------|
| JDK 8 (1.8.0_381) | Oracle 安装包 | `/Library/Java/JavaVirtualMachines/jdk-1.8.jdk` |
| JDK 17 (17.0.8) | Oracle 安装包 | `/Library/Java/JavaVirtualMachines/jdk-17.jdk` |
| Java 插件 (1.8.451) | 独立安装 | `/Library/Internet Plug-Ins/JavaAppletPlugin.plugin` |
| jEnv 0.6.0 | Homebrew | 已在 `.zshrc` 中配置 |

## 关键决策：使用 Temurin (cask) 而非 openjdk (formula)

**原因**：`openjdk@8` formula 要求 x86_64 架构，在 Apple Silicon 上无法安装。而 `temurin@8` cask 通过 Rosetta 2（已安装）运行。统一使用 Temurin 保持一致性，且 cask 安装的 JDK 自动注册到 `/Library/Java/JavaVirtualMachines/`，无需手动 symlink。

| 版本 | 安装命令 |
|------|---------|
| JDK 8 | `brew install --cask temurin@8` |
| JDK 17 | `brew install --cask temurin@17` |
| JDK 21 | `brew install --cask temurin@21` |
| JDK 25 | `brew install --cask temurin@25` |

## 实施步骤

### Step 1：清理 jEnv 中现有版本

```bash
jenv remove 1.8; jenv remove 1.8.0.381; jenv remove 17.0; jenv remove 17.0.8
jenv remove oracle64-1.8.0.381; jenv remove oracle64-17.0.8
jenv versions  # 确认清空
```

### Step 2：卸载 Oracle JDK 和 Java 插件

```bash
sudo rm -rf /Library/Java/JavaVirtualMachines/jdk-1.8.jdk
sudo rm -rf /Library/Java/JavaVirtualMachines/jdk-17.jdk
sudo rm -rf "/Library/Internet Plug-Ins/JavaAppletPlugin.plugin"
sudo rm -rf /Library/PreferencePanes/JavaControlPanel.prefPane
/usr/libexec/java_home -V 2>&1  # 确认已清空
```

### Step 3：Homebrew 安装 Temurin JDK

```bash
brew install --cask temurin@8
brew install --cask temurin@17
brew install --cask temurin@21
brew install --cask temurin@25
/usr/libexec/java_home -V 2>&1  # 确认 4 个版本都已注册
```

### Step 4：配置 jEnv

```bash
# 路径需根据 Step 3 的 java_home -V 实际输出调整
jenv add /Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Home
jenv add /Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home
jenv add /Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home
jenv add /Library/Java/JavaVirtualMachines/temurin-25.jdk/Contents/Home
jenv global 17.0    # 设置全局默认
jenv enable-plugin export  # 确保 JAVA_HOME 被正确导出
```

### Step 5：更新 `.zshrc`

修改文件：`shell/zshrc`（第 122-131 行）

将当前配置：
```bash
########## java ##########
export JAVA_8_HOME=/Library/Java/JavaVirtualMachines/jdk-1.8.jdk/Contents/Home
export JAVA_17_HOME=/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home

export JAVA_HOME=$JAVA_17_HOME
export PATH="$JAVA_HOME:$PATH"

########## jenv ##########
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
```

替换为：
```bash
########## jenv ##########
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

########## java ##########
# jEnv 管理 JAVA_HOME，不再需要手动设置
export JAVA_8_HOME=$(/usr/libexec/java_home -v 1.8)
export JAVA_17_HOME=$(/usr/libexec/java_home -v 17)
export JAVA_21_HOME=$(/usr/libexec/java_home -v 21)
export JAVA_25_HOME=$(/usr/libexec/java_home -v 25)
```

关键变更：jEnv init 移到前面、移除手动 `JAVA_HOME` 和 `PATH` 设置、使用 `java_home -v` 动态获取路径。

### Step 6：体验 jEnv 多级别设置

```bash
# global 级别 — 全局默认
jenv global 17.0
cd ~ && java -version  # 应显示 17.x

# shell 级别 — 仅当前终端会话生效
jenv shell 1.8
java -version          # 应显示 1.8.x
# 打开新终端窗口后恢复 17.x

# local 级别 — 项目目录生效，写入 .java-version 文件
mkdir -p /tmp/test-jenv-local && cd /tmp/test-jenv-local
jenv local 21.0
java -version          # 应显示 21.x
cat .java-version      # 查看 jEnv 写入的版本文件
cd ~ && java -version  # 离开目录后恢复 17.x

# 优先级验证：shell > local > global
jenv shell 25.0
cd /tmp/test-jenv-local
java -version          # shell 覆盖 local，应显示 25.x
```

### Step 7：验证

```bash
source ~/.zshrc
jenv versions          # 确认 4 个版本
java -version          # 确认全局默认 17
echo $JAVA_HOME        # 确认 jEnv 管理
jenv shell 1.8         # 测试切换
java -version          # 确认切换成功
```

## 需修改的文件

- `shell/zshrc` — Java/jEnv 配置段（第 122-131 行）

## 注意事项

- JDK 8 通过 Rosetta 2 运行，性能有轻微损失（legacy 版本影响极小）
- `jenv local` 会创建 `.java-version` 文件，注意 `.gitignore`
- IDE（如 IntelliJ）需手动更新 Project SDK 指向新路径
