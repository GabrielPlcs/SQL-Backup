# Database Backup Script

This script automates the process of backing up a MySQL/MariaDB database by sending the compressed backup to a remote server via SSH/SCP.

## Usage

To execute the script: 

```bash
bash backup.sh
```

Optional parameters include:

- `-h` or `--help` to show help

## Configuration Variables

The script defines the following variables that must be configured:   

- `SERVER`: Name or IP of the remote server  
- `USERNAME`: Username on remote server
- `DATABASE`: Name of database to backup
- `REMOTEDIR`: Destination folder on remote server

## Process

1. Performs database backup using mysqldump   
2. Compresses the backup file
3. Copies the compressed backup to remote server
4. Moves old backups to archive folder
5. Cleans up local files

This automatically handles the complete daily backup process of the database securely.

## Built With

- Bash
- Mysqldump
- SSH/SCP

## Advice

- Test the script thoroughly before putting in production
- Consider encrypting backups for increased security
- Configure script to run on a schedule (cron job)
- Implement logging and notifications for failures   
- Store backups off-system as an additional precaution
- Continuously review variables and processes to ensure they remain valid

## SSH Connection Tips

- Generate SSH key pairs for authentication rather than passwords
- Ensure SSH is installed and running on servers  
- Validate SSH port and firewall rules
- Test SSH connectivity before using in script
- Consider specifying SSH host key
- Limit SSH access to script needs
- Use scp explicitly if connection intermittent
- Set backup file permissions after transfer
- Add SSH connection logging/error handling
- Monitor authentication attempts for retries

Proper documentation and SSH configuration ensures a reliable backup process.
