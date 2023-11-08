#!/bin/bash

port=21
ip=$(hostname -I | awk '{print $1}')

# Check if the port is in use
if nc -z localhost $port; then
    zenity --error --no-wrap \
        --window-icon="/app/share/icons/hicolor/scalable/apps/net.retrodeck.retrodeck.svg" \
        --title "RetroDECK - FTP Server" \
        --text="Port $port is already in use. Please stop any services on that port and try again."
    exit 1
fi

# Start FTP server on port $port
nohup vsftpd /var/config/retrodeck/ftp/vsftpd.conf &

# Get the PID of the FTP server process
ftp_pid=$!

# Function to stop the FTP server
stop_ftp_server() {
    kill -9 $ftp_pid
    exit 0
}

# Create a Zenity window with only the "Stop" button
zenity --icon-name=net.retrodeck.retrodeck --info --no-wrap \
      --window-icon="/app/share/icons/hicolor/scalable/apps/net.retrodeck.retrodeck.svg" \
      --title "RetroDECK - FTP Server" \
      --text="FTP server started.\n\nAddress: $ip\nport: $port\nID:\tretrodeck\nPassword:\tretrodeck\npointing to:\n$rdhome\n\nPress Stop to terminate the server." --ok-label="Stop" || stop_ftp_server

# If the user clicks "Stop", call the function to stop the FTP server
stop_ftp_server
