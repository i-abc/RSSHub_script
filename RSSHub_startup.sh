#!/bin/bash

# 启动 tmux 会话
tmux new-session -d -s RSSHub

# 在第一个窗口中启动 RSSHub
tmux send-keys -t RSSHub:0 "cd RSSHub && npm start" C-m

# 创建一个新的 tmux 窗口
tmux new-window -t RSSHub:1

# 在新窗口中启动 RSSHub_check
tmux send-keys -t RSSHub:1 "cd RSSHub_check && ./RSSHub_check.sh" C-m

# 输出运行情况
echo "RSSHub and RSSHub_check started."
