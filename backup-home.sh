#!/bin/bash

# short rsync explanation
# -v = verbose
# -a = archive mode
# -l = copy symlinks as symlinks (yep, we want this)
# -P = show progress during transfer
# -o = preserve owner (super-user only)
# -g = preserve group
# --delete = delete files on backup drive which have been deleted on the origin drive (mirror function)
#--inplace this option tells rsync to update the destination file in-place. (which is a good idea for virtual machine images)

##### SETUP ###############################

read -p "Enter the backup media name: " BACKUP_MEDIA
read -p "Enter the folder on the backup media where the backup will be make: " BACKUP_FLDR

BACKUP_PATH="/media/${USER}/${BACKUP_MEDIA}/${BACKUP_FLDR}/"

# text files with exclude entries to show which data should not be backuped (like tmp data or the download folder)
PATH_HOME_EXCLUDES="${HOME}/repos/rsync-backup-script/config/HOME_backup_excludes.txt"


##### RUNNING #############################

# show script config
echo "You are about to run:"
echo "rsync -avlPog --delete --exclude-from ${PATH_HOME_EXCLUDES} ${HOME} ${BACKUP_PATH}"
while true
do
 read -r -p "Are You Sure? [Y/n] " input
 
 case $input in
     [yY][eE][sS]|[yY])
 echo "Running..."
 break
 ;;
     [nN][oO]|[nN])
 echo "Exiting..."
 exit 0
        ;;
     *)
 echo "Invalid input..."
 ;;
 esac
done

# checking if path exists, otherwise exit
if [ -d $BACKUP_PATH ]; then
    echo "Backing up to $BACKUP_PATH ...";
else
    echo "No directory $BACKUP_PATH found. Exiting...";
    exit 1;
fi

# make the backup
rsync -avlPog --delete --exclude-from $PATH_HOME_EXCLUDES $HOME $BACKUP_PATH

