#!/bin/bash


# Check if the $XDG_CONFIG_HOME exists, if so use it otherwise use the $HOME/.config directory
if [ -z "$XDG_CONFIG_HOME" ]; then
    target_dir="$HOME/.config"
else
    target_dir="$XDG_CONFIG_HOME"
fi
read -p "Do you want to source the bash_aliases file in the .bashrc? (y/n) " choice
case "$choice" in
    y|Y )
	echo "if [ -f \${XDG_CONFIG_HOME}/bash_aliases ]; then" >> ~/.bashrc
	echo "    . \${XDG_CONFIG_HOME}/bash_aliases" >> ~/.bashrc
	echo "elif [ -f \${HOME}/.config/bash_aliases ]; then" >> ~/.bashrc
	echo "    . \${HOME}/.config/bash_aliases" >> ~/.bashrc
	echo "fi" >> ~/.bashrc;;
    n|N ) echo "Okay, bash_aliases file not sourced in .bashrc.";;
    * ) echo "Invalid input. bash_aliases file not sourced in .bashrc.";;
esac

read -p "Do you want to install required packages? (y/n) " choice
case "$choice" in
    y|Y ) echo "Installing packages";;
    n|N ) echo "Not installing packages. User will be required to install their own"
	exit 0;;
    * ) echo "Invalid input. bash_aliases file not sourced in .bashrc."
	exit 1;;
esac


sudo apt -y update && sudo apt -y upgrade
sudo apt install -y clangd
sudo apt install -y bear
sudo apt install -y build-essential

wget https://go.dev/dl/go1.21.6.linux-amd64.tar.gz
sudo rm -rf /usr/local/go 
sudo tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
sudo apt install curl
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc
nvm install --lts

sudo apt install libfuse2
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /bin/nvim

curl -L https://raw.githubusercontent.com/catppuccin/gnome-terminal/v0.2.0/install.py | python3 -

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip

unzip JetBrainsMono.zip -d ~/.fonts
fc-cache -fv


git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


wget -qO - https://regolith-desktop.org/regolith.key | \
gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null
sudo apt update
echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
https://regolith-desktop.org/release-3_0-ubuntu-jammy-amd64 jammy main" | \
sudo tee /etc/apt/sources.list.d/regolith.list
sudo apt install regolith-desktop regolith-session-flashback regolith-look-lascaille


sudo apt install -y stow

sudo apt install -y xsel

sudo apt install -y ripgrep
sudo apt install -y python3.10
sudo apt install -y python3.10-venv
sudo apt install libevent-dev ncurses-dev build-essential bison pkg-config
wget https://github.com/tmux/tmux/releases/download/3.4/tmux-3.4.tar.gz
tar -zxf tmux-*.tar.gz
cd tmux-*/
./configure
make && sudo make install


mkdir ~/.virtualenvs
cd ~/.virtualenvs
python -m venv debugpy
debugpy/bin/python -m pip install debugpy
