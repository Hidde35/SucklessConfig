#!/bin/bash

# Copy wallpapers folder to ~/Pictures
if [ -d "other/wallpapers" ]; then
    cp -r other/wallpapers ~/Pictures/
    echo "Wallpapers have been copied to ~/Pictures."
else
    echo "The folder other/wallpapers does not exist, skipping."
fi

# Define package manager configurations
declare -A pkg_managers=(
    ["zypper"]="sudo zypper install -y"
    ["apt"]="sudo apt install -y"
)

declare -A update_commands=(
    ["zypper"]="sudo zypper refresh"
    ["apt"]="sudo apt update"
)

declare -A base_packages=(
    ["zypper"]="feh st"
    ["apt"]="feh"
)

# Detect package manager
for pkg_manager in "${!pkg_managers[@]}"; do
    if command -v "$pkg_manager" >/dev/null 2>&1; then
        INSTALL_CMD="${pkg_managers[$pkg_manager]}"
        UPDATE_CMD="${update_commands[$pkg_manager]}"
        BASE_PKGS="${base_packages[$pkg_manager]}"
        break
    fi
done

if [ -z "$INSTALL_CMD" ]; then
    echo "No supported package manager found. Please install packages manually."
    exit 1
fi

# Update and install base packages
$UPDATE_CMD
$INSTALL_CMD $BASE_PKGS

# Determine which folders to process based on package manager
if [ "$pkg_manager" = "zypper" ]; then
    folders=("dmenu" "dwm" "slstatus")
else
    folders=("dmenu" "dwm" "slstatus" "st")
fi

# Loop through each folder and run the commands
for folder in "${folders[@]}"; do
    if [ -d "$folder" ]; then
        echo "Entering folder: $folder"
        cd "$folder"
        sudo make clean install
        # Clean up again after installation to remove any generated object files
        sudo make clean
        cd ..
        echo "Finished processing folder: $folder"
    else
        echo "Folder $folder does not exist, skipping."
    fi
done

# Replace 'user' with the actual username in dwm.desktop
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
