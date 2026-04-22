#!/bin/bash

WALLPAPER=$(yad --file  \
	--title="Choose the wallpaper" \
	--filename="$START_DIR" \
	--file-filter="Images | *.png *.jpg *.jpeg *.bmp *.webp *.gif" \
	--width=800 \
	--height=600 \
	--add-preview \
	--large-preview
	
	
)

wal -i $WALLPAPER
