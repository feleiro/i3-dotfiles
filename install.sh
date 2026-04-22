#!/bin/bash
LCONFIG_DIR="$(pwd)/config"
DEFAULT_DIR="$(pwd)/default"
CONFIG_FILES=("i3" "alacritty" "polybar" "rofi" "wal" "picom")
CONFIG_DIR="$HOME/.config"
BACKUP_SFX=".backup-$(date +%Y%m%d_%H%M%S)"
I3_CFG="$LCONFIG_DIR/i3/config.d"

PACKAGES="i3 picom rofi pywal scrot xclip yad alacritty polybar feh dolphin"

echo "Сейчас тебе и3 ставить будем"
echo "Твои старые файлы конфигов удалены не будут,они будут в том же месте,но с прeпиской .backup"
read -p "Начать установку? (y/n): " decision
read -p "Использовать клавишу win для запуска rofi? (По умолчанию win+d): (y/n): " usewin


symlink() {
	
	local src="$1"
	local dst="$2"
	
	if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
		echo "уже есть ссылка: $src -> $dst"
		return
	fi

	if [ -e "$dst" ] && [ ! -L "$dst" ]; then
		echo "создаю backup для $dst"
		mv "$dst" "$dst$BACKUP_SFX"
	fi

	mkdir -p "$(dirname "$dst")"
	ln -sf "$src" "$dst"
	echo "создана ссылка: $src -> $dst"
}

get_distro() {
local distro="$(grep '^ID_LIKE=' /etc/os-release | cut -d'=' -f2 | tr -d '"')"

if [ "$distro" = "" ]; then 
	distro="$(grep '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')"
	fi

	echo "$distro"
}


add_or_replace() {
    local srch="$1"
    local rplc="$2"
    local dst="$3"

	mkdir -p "$(dirname "$dst")"
	touch "$dst"

    if grep -Fxq "$rplc" "$dst"; then
        echo "Строка уже существует в $dst"
    else
        if grep -Fq "$srch" "$dst"; then
            echo "Обновляю существующую настройку в $dst"
            sed -i "s|.*$srch.*|$rplc|" "$dst"
        else
            echo "Добавляю новую строку в $dst"
            echo "$rplc" >> "$dst"
        fi
    fi
}


install_packages() {
	local pkgs="$1"
	local distro="$(get_distro)"

	echo " система: "$distro" "

	case "$distro" in 
		*arch*) 
			echo "Проверяем,установлен ли yay..."
			
			if ! pacman -Qi "yay" &> /dev/null; then
				echo "yay не установлен. Устанавливаем..."
				sudo pacman -S --needed git base-devel
				git clone https://aur.archlinux.org/yay-bin.git
				cd yay-bin
				makepkg -si	
				cd .. ||
				rm -rf yay-bin
				fi
			echo "устанавливаем недостающие пакеты..."
			yay -S --needed --noconfirm $pkgs
			;;
		*void*) 
			echo "Устанавливаем недостающие пакеты..."
			sudo xbps-install -Sy $pkgs
			;;
	esac
} 


#starting installatiom
if [[ "$decision" =~ "y" ]]; then	
    echo "Понадобятся права администратора, йоу"
    sudo -v

#setting up congig/ files
	if [ -d "$LCONFIG_DIR" ] && [ -n "$(ls -A "$LCONFIG_DIR" 2>/dev/null)" ]; then
		read -p "папка config не была пуста. Удалить содержимое? (y/n)" clear_config
		if [[ "$clear_config" =~ "y" ]]; then
			rm -rf "${LCONFIG_DIR:?}"/*
			mkdir -p $LCONFIG_DIR
		else
			echo "Так дела не идут. Убери что осталось в папке $LCONFIG_DIR и тогда можем поговорить"
			exit 1
		fi

	fi

	cp -RT "$DEFAULT_DIR" "$LCONFIG_DIR"

#checking if distro is void and prompting to set up sound

    if [[ "$(get_distro)" =~ "void" ]]; then

	read -p "У тебя void linux. Добавить звук в автозапуск i3? (pipewire,pipewire-pulse,wireplumber) Они также будут установлены,если их не было. (y/n): " install_sound
	if [[ "$install_sound" =~ "y" ]]; then

	PACKAGES="$PACKAGES wireplumber pipewire" 	

	add_or_replace "exec --no-startup-id pipewire" "exec --no-startup-id pipewire" "$I3_CFG/autostart.conf"
	add_or_replace "exec --no-startup-id pipewire-pulse" "exec --no-startup-id pipewire-pulse" "$I3_CFG/autostart.conf"
	add_or_replace "exec --no-startup-id wireplumber" "exec --no-startup-id wireplumber" "$I3_CFG/autostart.conf"
	fi

    fi

    [[ "$usewin" =~ "y" ]] && PACKAGES="$PACKAGES xcape"

#install
 
echo "Устанавливаем все необходимые пакеты..."

    install_packages "$PACKAGES"

#symlinking

    echo "Создаём символические ссылки..."
   
    for cfg in "${CONFIG_FILES[@]}"; do 
	    symlink "$LCONFIG_DIR/$cfg" "$CONFIG_DIR/$cfg"
    done

#windows key 

if [[ "$usewin" =~ "y" ]]; then
        echo "Настраиваю запуск rofi по одиночному нажатию Win..."
        
	add_or_replace "xcape" "exec --no-startup-id xcape -e 'Super_L=Alt_L|F1'" "$I3_CFG/autostart.conf"
        
	add_or_replace 'bindcode \$mod+40' 'bindsym Mod1+F1 exec "rofi -modi drun,run -show drun"' "$I3_CFG/autostart.conf"
fi

#finish

    echo "Установка завершена! Перезайди в i3 (Mod+M)."
else
    echo "Ну и иди ты"
fi

