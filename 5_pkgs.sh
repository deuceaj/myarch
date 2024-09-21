#!/usr/bin/env bash

# Display a welcome banner
echo -ne "
-------------------------------------------------------------------------
██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ██╗███╗   ██╗ ██████╗         
██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██║████╗  ██║██╔════╝         
██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     ██║██╔██╗ ██║██║  ███╗        
██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██║██║╚██╗██║██║   ██║        
██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗██║██║ ╚████║╚██████╔╝        
╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝         
                                                                                    
██████╗  █████╗  ██████╗███╗   ███╗ █████╗ ███╗   ██╗      ██████╗ ██╗  ██╗ ██████╗ 
██╔══██╗██╔══██╗██╔════╝████╗ ████║██╔══██╗████╗  ██║      ██╔══██╗██║ ██╔╝██╔════╝ 
██████╔╝███████║██║     ██╔████╔██║███████║██╔██╗ ██║█████╗██████╔╝█████╔╝ ██║  ███╗
██╔═══╝ ██╔══██║██║     ██║╚██╔╝██║██╔══██║██║╚██╗██║╚════╝██╔═══╝ ██╔═██╗ ██║   ██║
██║     ██║  ██║╚██████╗██║ ╚═╝ ██║██║  ██║██║ ╚████║      ██║     ██║  ██╗╚██████╔╝
╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝      ╚═╝     ╚═╝  ╚═╝ ╚═════╝ 
nn
-------------------------------------------------------------------------
"

# Function to install packages using pacman
install_with_pacman() {
    if pacman -Qi "$1" &> /dev/null; then
        tput setaf 2
        echo "###############################################################################"
        echo "################## The package $1 is already installed"
        echo "###############################################################################"
        echo
        tput sgr0
    else
        tput setaf 3
        echo "###############################################################################"
        echo "##################  Installing package $1"
        echo "###############################################################################"
        echo
        tput sgr0
        sudo pacman -S --noconfirm --needed "$1"
        installed_pacman+=("$1")
    fi
}

# Function to install packages using yay
install_with_yay() {
    if yay -Qi "$1" &> /dev/null; then
        tput setaf 2
        echo "###############################################################################"
        echo "################## The package $1 is already installed"
        echo "###############################################################################"
        echo
        tput sgr0
    else
        tput setaf 3
        echo "###############################################################################"
        echo "##################  Installing package $1"
        echo "###############################################################################"
        echo
        tput sgr0
        yay -S --noconfirm --needed "$1"
        installed_yay+=("$1")
    fi
}

# Function to print category headers
print_category() {
    tput setaf 5
    echo "################################################################"
    echo "Installing software for category $1"
    echo "################################################################"
    tput sgr0
}

# Array to keep track of packages not installed
not_installed=()

# Installing packages with pacman
print_category "Test"

pacman_list=(
   ### Must have programs

	
	amd-ucode
	alacritty
	bat
	corectrl	
	discord
	baobab
	cifs-utils
	dunst
	evince
	ffmpeg
	ffmpegthumbnailer
	firefox
	foliate
	git
	gtk-theme-elementary
	gparted
	gtk3	
	guvcview
	gvfs-mtp
	kitty
	mpv
	neovim
	noise-suppression-for-voice
	ntfs-3g
	nwg-look
	obsidian
	obs-studio
	pamixer
	pacman-contrib	
	papirus-icon-theme
	pavucontrol
	playerctl
	polkit-gnome
	qt5-wayland 
	qt5ct
	qt6-wayland 
	qt6ct
	qt5-svg
	qt5-quickcontrols2
	qt5-graphicaleffects
	qalculate-gtk
	slurp
	thunar
	thunar-media-tags-plugin
	thunar-archive-plugin
	thunar-volman
	tumbler
	virt-viewer	
	timeshift
	torbrowser-launcer
	wl-clipboard
	wf-recorder
	viewnior
	virt-manager
	vlc
	
	####################
	####      Files ####
	####################
	 ncdu
	 ranger
	 ueberzug	 

	################
	#### Images ####
	####################
	 imagemagick

	####################
	#### Multimedia ####
	####################
	 youtube-dl

	####################
	#### ARCHIVE    ####
	####################
	file-roller
	gzip
	p7zip
	sharutils
	ufw
	unrar
	unzip
	xarchiver	

	####################
	#### Gaming     ####
	####################
	steam
	proton-ge-custom-bin 
	lib32-vulkan-radeon
	
	####################
	#### Utilities  ####
	####################
	bridge-utils
	dnsmasq
	edk2-ovmf
	iptables-nft
	libguestfs
	libvirt
	# qemu-desktop
	qemu-full
	swtpm
	vde2
)

installed_pacman=()
for name in "${pacman_list[@]}"; do
    install_with_pacman "$name"
done

# Installing packages with yay
print_category "AUR"

yay_list=(
    

	#aur
	archlinux-tweak-tool-git 
	brave-bin
	ckb-next
	emote
	input-remapper-git
	nordpass-bin
	nordtray-bin
	nordvpn-bin
	ocs-url
	pacseek
	pamac-all
	pcloud-drive
	sddm-theme-sugar-candy-git
	spicetify-cli
	spotify
	spotifywn-git
	timeshift
	timeshift-autosnap
	wps-office
	Visual-studio-code-bin
	
	#fonts
	ttf-ms-fonts
	otf-sora
	ttf-comfortaa
	ttf-nerd-fonts-symbols-common
	otf-firamono-nerd
	inter-font
	ttf-fantasque-nerd
	noto-fonts
	noto-fonts-emoji
	ttf-jetbrains-mono-nerd
	ttf-icomoon-feather
	ttf-iosevka-nerd
	adobe-source-code-pro-fonts	
)

installed_yay=()
for name in "${yay_list[@]}"; do
    install_with_yay "$name"
done

# List any packages that were not installed
echo "Packages not installed by pacman:"
for name in "${pacman_list[@]}"; do
    if [[ ! " ${installed_pacman[@]} " =~ " ${name} " ]]; then
        echo "$name"
        not_installed+=("$name")
    fi
done

echo "Packages not installed by yay:"
for name in "${yay_list[@]}"; do
    if [[ ! " ${installed_yay[@]} " =~ " ${name} " ]]; then
        echo "$name"
        not_installed+=("$name")
    fi
done

if [ ${#not_installed[@]} -eq 0 ]; then
    echo "All packages were successfully installed."
else
    echo "Some packages were not installed:"
    for name in "${not_installed[@]}"; do
        echo "$name"
    done
fi
