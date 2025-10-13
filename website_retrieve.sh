#! /bin/bash

# The name of the directory in which the production website is hosted 
WEBSITE_DIR="advising"

# The name of the directory in which the testing website is hosted on GitHub
GITHUB_DIR="website"

# The name of the archive directory
ARCHIVE_DIR="ARCHIVE"

# Get command line flags
while getopts "yn" OPTION; do
	case $OPTION in
		y)
			EXPRESS_CONFIRM="y"
			;;
		n)
			exit 1
			;;
		\?)
			exit 1
			;;
	esac
done

# Make the archive directory
mkdir -p "$ARCHIVE_DIR"

# Set the working directory to the directory which contains the script itsself
cd $(dirname "$0")

# Warn the user that the script will remove all files in the directory
if [ "$EXPRESS_CONFIRM" != "y" ]; then
	read -p "Warning this script will rearrange all files in the directory in which it resides. Continue? (Y/N): " CONFIRM
fi

# If the user does not pass the confirmation then fail
if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" && "$EXPRESS_CONFIRM" != "y" ]; then
	exit 1
fi

while true; do
	# Get the current date and time on the system
	DATE_TIME_STR="$(date +"%y-%m-%d_%H-%M-%S")"

	# Generate a random eleven character long base 64 number
	RAND_STR="$(cat /dev/urandom | tr -cd 'a-zA-Z0-9\-\_' | head -c 11)"

	# Create the new directory name by combining the name and the random number
	DIR_NAME="$DATE_TIME_STR~$RAND_STR"

	# Repeate the process until a unique directory name is found
	if [ ! -d "$DIR_NAME" ]; then
		break
	fi
done

# Make the new directory
mkdir "$DIR_NAME"

# Allows for selecting all but some files
shopt -s extglob

# Check if there are any files that need to be moved
FILTER="$(echo !("$(basename "$0")"|"$DIR_NAME"|"$ARCHIVE_DIR"))"
if [ "$FILTER" != "!("$(basename "$0")"|"$DIR_NAME"|"$ARCHIVE_DIR")" ]; then
# Move them into the new folder if they exist
	mv !("$(basename "$0")"|"$DIR_NAME"|"$ARCHIVE_DIR") "$DIR_NAME"/.

# Move the new folder into the archive folder
	mv "$DIR_NAME" "$ARCHIVE_DIR/."
else
# Otherwise remove the new directory
	rm -rf "$DIR_NAME"
fi

# Retrieve the website from the Pages link
wget -r -np -nH  https://johannes-weis.github.io/UML_CS_advising/$GITHUB_DIR/

# Move the contents back to the root directory
mv UML_CS_advising/$GITHUB_DIR/* .

# Remove the now empty directory
rm -rf UML_CS_advising

# Add the neccessary permissions to the hosting directory
sudo chmod 777 -R /home/CIS/web/$WEBSITE_DIR 
