## MySQL backup script with auto-created directory structure ##

This script will create a year/month/day/hour directory structure and backup any non-excluded databases with gzip compression.
use the env.sample to make your own .env file to store credentials, server host, and databases excluded from backups
To use, add cron entry (or entries) at whatever schedule you would like and the script does the rest
