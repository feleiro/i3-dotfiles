#!/bin/bash

read -p "Начать установку? (yes/no): " decision
read -p "Использовать клавишу win для запуска rofi? (По умолчанию win+d): (yes/no): " usewin

if [ "$decision" = "yes" ]; then
    echo "Понадобятся права администратора, йоу"
    sudo -v

    echo "Устанавливаем все необходимые пакеты..."
    PACKAGES="i3-wm alacritty rofi i3status polybar picom pywal feh scrot xclip dolphin"
    [ "$usewin" = "yes" ] && PACKAGES="$PACKAGES xcape"
    
    yay -S --needed --noconfirm $PACKAGES && echo "Пакеты установлены успешно."

    echo "Удаляю старые файлы конфигов, если таковые имеются..."
    for folder in i3 rofi alacritty polybar wal; do
        if [ -d "$HOME/.config/$folder" ]; then
            rm -rf "$HOME/.config/$folder"
            echo "Папка $folder удалена."
        fi
    done
    
    echo "Копирую файлы конфигов в ~/.config..."
    
    configs=("i3" "alacritty" "rofi" "polybar" "wal")
    for cfg in "${configs[@]}"; do
        if [ -d "./$cfg" ]; then
            cp -R "./$cfg" ~/.config/ && echo "Конфиг $cfg скопирован успешно."
        else
            echo "Ошибка: Исходная папка ./$cfg не найдена!"
        fi
    done

    if [ "$usewin" = "yes" ]; then
        echo "Настраиваю запуск rofi по одиночному нажатию Win..."
        # Добавляем в автозагрузку
        echo "exec --no-startup-id xcape -e 'Super_L=Alt_L|F1'" >> ~/.config/i3/config.d/autostart.conf
        # Меняем бинд в конфиге (Alt_L+F1 — это Alt+F1, который эмулирует ksuperkey)
        sed -i 's/bindcode $mod+40/bindsym Mod1+F1/g' ~/.config/i3/config.d/keybinds.conf
    fi

    echo "Установка завершена! Перезагрузите i3 (Mod+Shift+R)."
else
    echo "Ну и иди ты"
fi

