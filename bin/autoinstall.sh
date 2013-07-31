#!/bin/bash

aider_function() {
    echo -e "Usage: autoinstall.sh [function]"
    echo -e "setup_software:\tinstall nessesary software"
    echo -e "setup_addition:\tinstall vbox guest additions"
    echo -e "setup_userhome:\tuser configurations"
}

aider_readline() {
    rm $1
    while true;do
        read -p ">" input
        if [ "$input" = "EOF" ]; then 
            break
        fi
        echo $input >> $1
    done
}

setup_software() {
    echo 'APT::Install-Recommends "0";' | sudo tee -a /etc/apt/apt.conf

    sudo aptitude update
    sudo aptitude upgrade

    sudo aptitude install xinit xserver-xorg-video-vesa xserver-xorg-input-mouse xserver-xorg x11-xserver-utils dkms
    sudo aptitude install slim openbox xdg-user-dirs
    sudo aptitude install xterm vim-gtk ctags firefox git xsel software-properties-common
    sudo aptitude install gnupg-agent devscripts debhelper fakeroot dput cdbs
}

setup_addition() {
    sudo mkdir -p /media/cdrom
    sudo mount /dev/cdrom /media/cdrom
    cd /media/cdrom
    sudo ./VBoxLinuxAdditions.run
}

setup_userhome() {
    cd $HOME

    ssh-keygen -t rsa
    cat $HOME/.ssh/id_rsa.pub | xsel -b
    read -p "SSH: Please update SSH key on Github [Enter to continue]" 

    git clone git@github.com:lainme/dotfiles.git dotfiles
    cp -r dotfiles/.gitconfig dotfiles/.vimrc dotfiles/.vim dotfiles/.Xresources .
    rm -rf dotfiles

    git clone git@github.com:lainme/dotfiles-ubuntu.git dotfiles
    ln -sf dotfiles/* .
    ln -sf dotfiles/.[^.]* .
    rm .git

    echo "GPG: Please enter the public key [EOF to finish]"
    aider_readline pubkeys
    echo "GPG: Please enter the private key [EOF to finish]"
    aider_readline seckeys
    rm -rf .gnupg
    gpg --import pubkeys seckeys
    gpg --export-secret-subkeys AAD227A4 > subkeys
    gpg --delete-secret-key F48E55F7
    gpg --import pubkeys subkeys
    rm pubkeys seckeys subkeys
    echo "use-agent" >> .gnupg/gpg.conf
}

if [ -n $1 ];then
    aider_function
fi
