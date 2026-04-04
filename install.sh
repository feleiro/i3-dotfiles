read "Начать установку? (yes/no)" decision




if [ "$decision" = "yes" ]; then
	echo "Понадобятся права администратора,йоу"
	sudo -v
	echo  "Устанавливаем все необходимые пакеты..."
	yay -S --needed --noconfirm i3-wm alacritty rofi i3status polybar picom pywal feh scrot xclip dolphin && echo "Успешно."
	echo "Удаляю старые файлы конфигов,если таковые имеются..."
	if [ -d "$HOME/.config/i3" ]; then
    		rm -rf "$HOME/.config/i3"
    		echo "Папка i3 удалена."
	fi
	if [ -d "$HOME/.config/i3" ]; then
    		rm -rf "$HOME/.config/rofi"
    		echo "Папка rofi  удалена."
	fi
	if [ -d "$HOME/.config/i3" ]; then
    		rm -rf "$HOME/.config/alacritty"
    		echo "Папка alacritty удалена."
	fi
	if [ -d "$HOME/.config/i3" ]; then
    		rm -rf "$HOME/.config/polybar"
    		echo "Папка polybar удалена."
	fi
		if [ -d "$HOME/.config/wal" ]; then
    		rm -rf "$HOME/.config/wal"
    		echo "Папка pywal удалена."
	fi
	
	
	echo "Копирую файлы конфигов в ~/.config "
	
	echo "Копирую файлы конфигов для i3..."
	cp -R ./i3 ~/.config/i3 && echo "Успешно."

	echo "Копирую файлы конфигов для alacritty..."
	cp -R ./alacritty ~/.config/alacritty && echo "Успешно."

	echo "Копирую файлы конфигов для rofi..."
	cp -R ./rofi ~/.config/rofi && echo "Успешно."

	echo "Копирую файлы конфигов для polybar ..."
	cp -R ./polybar  ~/.config/polybar && echo "Успешно."

	echo "Копирую файлы конфигов для pywal..."
	cp -R ./wal ~/.config/wal && echo "Успешно."



else
	echo "ну и иди ты"

fi
