# Use the PowerShell Core base image
FROM mcr.microsoft.com/powershell:latest

# Set the working directory
WORKDIR /scripts

# Copy the PowerShell script into the container
COPY ./Post-SteamToDiscord.ps1 .

# Create the Feeds directory inside the container
RUN mkdir -p ./Feeds

# Copy FeedSettings.csv into the Feeds directory inside the container
COPY ./Feeds/FeedSettings.csv ./Feeds/
