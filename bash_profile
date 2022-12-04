# JDK 
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_291.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH:.
export CLASSPATH=$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:.

# Database
export PATH=$PATH:/usr/local/mysql/bin
export PATH=$PATH:/usr/local/mongodb/bin

# Node 
export NODE_HOME=/Users/ngyb/local/node
export PATH=$PATH:$NODE_HOME/bin

# Python3 
alias python="/usr/local/bin/python3"

# Maven 
export M2_HOME=/Library/Apache/apache-maven-3.6.3
export PATH=$PATH:$M2_HOME/bin

# tsc 
export TSC_HOME=/usr/local/lib/node_modules/typescript/bin/tsc
export PATH=$PATH:$TSC_HOME

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# pnpm
export PNPM_HOME="/Users/ngyb/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# homebrew aliyun mirrors
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles

