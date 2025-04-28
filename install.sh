#!/bin/bash
# Install required package
sudo apt update && sudo apt install -y feh
# Copy wallpapers folder to ~/Pictures
if [ -d "other/wallpapers" ]; then
    cp -r other/wallpapers ~/Pictures/
    echo "Wallpapers have been copied to ~/Pictures."
else
    echo "The folder other/wallpapers does not exist, skipping."
fi

# List of folders to process
folders=("dmenu" "dwm" "slstatus" "st")

# Loop through each folder and run the commands
for folder in "${folders[@]}"; do
    if [ -d "$folder" ]; then
        echo "Entering folder: $folder"
        cd "$folder"
        sudo make clean install
        cd ..
        echo "Finished processing folder: $folder"
    else
        echo "Folder $folder does not exist, skipping."
    fi
done

# # Replace 'user' with the actual username in dwm.desktop
if [ -n "$USER" ]; then
    username=$(echo "$USER" | tr '[:upper:]' '[:lower:]' | cut -d'@' -f1)
    sed -i "s|/home/user|/home/$username|g" dwm.desktop
else
    echo "USER is not set. Skipping username replacement."
fi

# Copy dwm.desktop to /usr/share/xsessions
sudo cp dwm.desktop /usr/share/xsessions/
echo "dwm.desktop has been copied to /usr/share/xsessions."

# Make .xinitrc executable and copy to ~/
if [ -f ".xinitrc" ]; then
    cp .xinitrc ~/
    chmod +x ~/.xinitrc
    echo ".xinitrc has been made executable and copied to ~/."
else
    echo ".xinitrc does not exist, skipping."
fi