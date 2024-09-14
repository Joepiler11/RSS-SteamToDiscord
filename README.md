# RSS-SteamToDiscord

This project runs a simple powershell script to pull and parse RSS data from the Steam News Hub and posts then to discord channels via webhooks.  

The script runs every 5 minutes.  

You can run this with docker or you can find the .ps1 in the "Build" folder.  

The docker image is a linux base running powershell core (mcr.microsoft.com/powershell:latest)

![Screenshot](/Build/img/Screenshot_20240914_224514.png)

# Instructions for docker

### Filestructure

To run a docker container you only need the docker-compose.yml and the Feeds directory with a FeedSettings.csv file.

```markdown
Parent Directory/
├── docker-compose.yml
└── Feeds/
    └── FeedSettings.csv
```

### FeedSettings.csv

Watch out with special characters or space in the Name

> Name;URL;Webhook  
WhateverFloatsYourBoat;RSS feed Url;Discord Webhook URL

> Name;URL;Webhook  
Warhammer40k;https://store.steampowered.com/feeds/news/app/2183900/;https://discord.com/api/webhooks/...  
SeaOfThieves;https://store.steampowered.com/feeds/news/app/1172620/;https://discord.com/api/webhooks/...  

### Running the container

`docker compose up -d`  

### Steam RSS feed URL

[Go to the Steam news hub](https://store.steampowered.com/news/)  

Find a news feed you want to follow and add /feeds in the url:  

"https://store.steampowered.com/news/collection/featured/"  

becomes:  

"https://store.steampowered.com/feeds/news/collection/featured/"

### Discord Webhook URL

[See Discord documenation on webhooks.](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks)
