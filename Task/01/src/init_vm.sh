# update system
sudo apt update && sudo apt dist-upgrade -y

# 1. set shared folder
sudo apt install virtualbox-guest-utils -y
mkdir /home/${USER}/host /home/${USER}/Downloads
sudo mount -t vboxsf host /home/${USER}/host
sudo mount -t vboxsf Downloads /home/${USER}/Downloads

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
