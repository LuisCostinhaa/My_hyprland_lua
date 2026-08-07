#
# ~/.bashrc
#

# If not running interactively, don't do anything
#[[ $- != *i* ]] && return

##
##	GENERATE A FORMAT SEQUENCE
##
# 1. Nice username colors
export PS1='\[\e[0;36m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;35m\]\w\[\e[0m\]> '


################################################################################
#
#macchina
fastfetch
#
export EDITOR="subl"
#
source /usr/share/blesh/ble.sh
#
#
alias cat="bat"
alias ccache="yay -Scc"
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'
alias grep='grep --color=auto'
alias ip="ip a"
alias jctl="journalctl -p 3 -xb"
alias keyring="sudo pacman -Sy archlinux-keyring"
alias ll="lsd -lh"
alias ls='lsd -la --color=auto'
alias nano-fstab="sudo nano /etc/fstab"
alias nano-grub="sudo nano /etc/default/grub"
alias nano-pacman.conf="sudo nano /etc/pacman.conf"
alias pacotes="pacman -Qet"
alias reload="sudo fc-cache -vf"
alias telemovel="simple-mtpfs --device 1 ~/Telemovel"
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias update-mirrorlist="sudo reflector -c Portugal -c Spain -c germany -a 12 -p https -p http --sort rate --score 10 --save /etc/pacman.d/mirrorlist"
alias update-mkinitcpio="sudo mkinitcpio -P linux"
alias vcahe="du -sh /var/cache/pacman/pkg/"
alias microcode='grep . /sys/devices/system/cpu/vulnerabilities/*'
alias howold="sudo lshw | grep -B 3 -A 8 BIOS"
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias riplong="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -3000 | nl"
alias list="sudo pacman -Qqe"
alias listt="sudo pacman -Qqet"
alias listaur="sudo pacman -Qqem"
alias f="yazi"
alias matrix="cmatrix  -s"
alias reloud="source ~/.zshrc"
alias p="poweroff"
alias papirus="papirus-folders -C"
alias sy="yay -Sy"
alias ss="yay -Ss"
alias cpu="sudo auto-cpufreq --live"
alias syu="yay -Syu"
alias r="reboot"
alias y="yazi"
