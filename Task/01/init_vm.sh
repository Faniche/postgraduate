# update system
sudo apt update && sudo apt dist-upgrade -y

# 1. install tmux
sudo apt install tmux -y
touch .tmux.conf
echo "set -g mouse on" >> .tmux.conf
echo "setw -g mouse-resize-pane on" >> .tmux.conf
echo ""setw -g mouse-select-pane on >> .tmux.conf
echo "setw -g mouse-select-window on" >> .tmux.conf
echo ""setw -g mode-mouse on >> .tmux.conf

# 2. config vim
touch .vimrc
cat>.vimrc<<EOF
:set number relativenumber
:set tabstop=4
:set shiftwidth=4
:set expandtab
EOF
sudo touch /etc/vim/vimrc.local
sudo cat>/etc/vim/vimrc.local<<EOF
:set number relativenumber
:set tabstop=4
:set shiftwidth=4
:set expandtab
EOF

# 3. install net-tools
sudo apt install net-tools -y

# 4. set proxy
PROXY_ADDRESS=10.100.0.1:1080
echo 'echo 'http_proxy=\"http://${PROXY_ADDRESS}\"' >> /etc/environment' | sudo sh
echo 'echo 'https_proxy=\"https://${PROXY_ADDRESS}\"' >> /etc/environment' | sudo sh
echo 'echo 'no_proxy=\"localhost, 127.0.0.1, 10.0.0.0/8, 192.168.0.0/16, ::1\"' >> /etc/environment' | sudo sh

sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab

