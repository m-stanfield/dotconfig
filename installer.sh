#!/bin/bash


# Check if the $XDG_CONFIG_HOME exists, if so use it otherwise use the $HOME/.config directory
if [ -z "$XDG_CONFIG_HOME" ]; then
    target_dir="$HOME/.config"
else
    target_dir="$XDG_CONFIG_HOME"
fi

# Check if the bash_aliases file or nvim or tmux directories exist within the above directory, if so back them up by prepending the bak. string to the name
if [ -f "$target_dir/bash_aliases" ]; then
    mv "$target_dir/bash_aliases" "$target_dir/bak..aliases"
fi

if [ -d "$target_dir/.git" ]; then
    mv "$target_dir/.git" "$target_dir/bak..git"
fi

if [ -d "$target_dir/nvim" ]; then
    mv "$target_dir/nvim" "$target_dir/bak.nvim"
fi

if [ -d "$target_dir/tmux" ]; then
    mv "$target_dir/tmux" "$target_dir/bak.tmux"
fi

# Double check that, after moving, the bash_aliases file and nvim or tmux directories do not exists
if [ -e "$target_dir/bash_aliases" ] || [ -d "$target_dir/nvim" ] || [ -d "$target_dir/tmux" ]; then
    echo "Error: Backup failed. Please check the target directory."
    exit 1
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# copy the bash_aliases, nvim, and tmux from the scripts directory to the target directory
cp -r "${SCRIPT_DIR}"/{bash_aliases,nvim,tmux,.git} "$target_dir"

# Ask the user if they want to source the bash_aliases file in the .bashrc, if they confirm source the .aliases file in the .bashrc file
read -p "Do you want to source the bash_aliases file in the .bashrc? (y/n) " choice
case "$choice" in
    y|Y )
	echo "if [ -f \${XDG_CONFIG_HOME}/bash_aliases ]; then" >> ~/.bashrc
	echo "    . \${XDG_CONFIG_HOME}/bash_aliases" >> ~/.bashrc
	echo "elif [ -f \${HOME}/.config/bash_aliases ]; then" >> ~/.bashrc
	echo "    . \${HOME}/.config/bash_aliases" >> ~/.bashrc
	echo "fi" >> ~/.bashrc
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
sudo apt install build-essential

wget https://go.dev/dl/go1.21.6.linux-amd64.tar.gz
sudo rm -rf /usr/local/go 
sudo tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz
# export PATH=$PATH:/usr/local/go/bin

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
# source ~/.bashrc
# nvm install --lts

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

echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
https://regolith-desktop.org/release-3_0-ubuntu-jammy-amd64 jammy main" | \
sudo tee /etc/apt/sources.list.d/regolith.list
sudo apt install regolith-desktop regolith-session-flashback regolith-look-lascaille


sudo apt install stow

sudo apt install xsel

sudo apt install ripgrep
sudo apt install python3.10
sudo apt install python3.10-venv
