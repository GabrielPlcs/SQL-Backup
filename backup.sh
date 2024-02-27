#!/bin/bash

# Set variables for server connection
SERVER="Kali" # Server name or IP address
USERNAME="root" # Username on remote server
PORT=22 # Port number for SSH connection (default is 22)
KEY="/path/to/privatekeyfile" # Path to private key file if using public key authentication instead of password (optional)

# Set variables for database backup
DATABASE="database_de_prueba" # Name of database to be backed up
DUMPFILE="$HOME/backups/$DATABASE.$(date +%F-%H:%M).sql" # Local path where backup will be saved
REMOTEHOST="Debian" # Remote host to send backup to via SSH
REMOTEDIR="/home/elliott/backups/" # Directory on remote host where backup will be sent
BACKUPDIR="$HOME/old-backups/" # Directory to move old backups to
COMPRESSOR="gzip" # Compression program to use (can also use bzip2, xz, etc.)
KEEPDAYS=7 # Number of days to keep compressed backups

# Function to display usage information
usage() {
    echo "Usage: $(basename "$0") [-h] [--help]"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        *)
            break
            ;;
    esac
done

# Check if required programs are installed
if ! type mysqldump &> /dev/null; then
    echo "Error: 'mysqldump' not found."
    exit 1
fi

if ! type scp &> /dev/null; then
    echo "Error: 'scp' not found."
    exit 1
fi

if ! type ssh &> /dev/null; then
    echo "Error: 'ssh' not found."
    exit 1
fi

if ! type $COMPRESSOR &> /dev/null; then
    echo "Error: '$COMPRESSOR' not found."
    exit 1
fi

# Create backup directories if they don't already exist
mkdir -p "$HOME"/backups
mkdir -p "$BACKUPDIR"

# Backup database
echo "Backing up database..."
mysqldump --databases $DATABASE | tee $DUMPFILE || exit 1

# Move old backups to archive folder
find "$HOME"/backups/*.sql -mtime "+${KEEPDAYS}" -exec mv {} "$BACKUPDIR" \;

# Compress new backup
echo "Compressing backup..."
$COMPRESSOR $DUMPFILE

# Send compressed backup to remote server
echo "Sending backup to remote server..."
scp "${DUMPFILE}.gz" elliott@192.168.1.108:"$REMOTEDIR" || exit 1

# Clean up local files
echo "Cleaning up local files..."
#rm ${DUMPFILE}{,.gz}

echo "Database backup complete!"
exit 0