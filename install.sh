#!/bin/sh

echo " ----------------------------------------------------------------------------------"
echo " |                                     INSTALLER                                  |"
echo " |     ___________     __________    _______    ___________     __    ______      |"
echo " |    |   ______  |   |   ____   \  /  ___  |  |  ___   _  \   |  |  /  __  \     |"
echo " |    |  |__   |  |   |  |__   \  \/  /  |  |  |  | |  |_)  |  |  | |  |  |  |    |"
echo " |    |   __|  |  |   |   __|   >    <   |  |  |  | |      /   |  | |  |  |  |    |"
echo " |    |  |     |   ----  |____ /  /\  \  |   --   | |  |\  \   |  | |   --   |    |"
echo " |    |__|     |_________________/  \__\ |_______/  |__| \__\  |__|  \______/     |"
echo " |                                                                                |"
echo " ----------------------------------------------------------------------------------"
echo ""
echo "Root user need to install Flexurio."

UNAME=$(uname)
if [ "$UNAME" ">" "MINGW" -a "$UNAME" "<" "MINGX" ] ; then
    echo "Sorry, flexurio on Windows not ready"
    exit
fi
if [ "$UNAME" != "Linux" -a "$UNAME" != "Darwin" ] ; then
    echo "Sorry, this OS is not supported yet via this installer."
    echo "For more details on supported platforms, see https://www.flexurio.com"
    exit
fi

# Install meteor
# sudo curl https://install.meteor.com/ | sh

# Check pip python
pip install ConfigParser
pip install requests

# Create destination folder
mkdir -p ~/.flexurio/
cp -R flexurio ~/.flexurio/
cp -R flexurio_config ~/.flexurio/
cp -R flexurio_portal ~/.flexurio/

sudo rm -R /usr/local/bin/flexurio
sudo ln -s ~/.flexurio/flexurio /usr/local/bin/flexurio
sudo chmod +x /usr/local/bin/flexurio
sudo chmod +x ~/.flexurio/flexurio

echo ""
echo "Installation complete."
echo ""

# Exit from the script with success (0)
exit 0
