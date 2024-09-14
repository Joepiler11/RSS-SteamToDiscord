function Get-SteamRSS {
    param (
        # Define the parameter that takes the URL of the RSS feed as input.
        [string]$FeedUrl
    )

    # Fetch the RSS feed from the specified URL using the Invoke-WebRequest cmdlet.
    $RSSFeed = Invoke-WebRequest -Uri $FeedUrl

    # Convert the RSS feed content from string format to XML for easier parsing.
    [xml]$XMLContent = $RSSFeed.Content

    # Iterate over each RSS feed item within the XML content.
    $Items = foreach ($Item in $XMLContent.rss.channel.item) {

        # Create a new PowerShell object to hold each RSS feed item's data.
        $Object = New-Object PSObject

        # Loop through all child nodes of the current RSS feed item (like title, link, pubDate, etc.).
        foreach ($child in $item.ChildNodes) {
            
            # Add each child node (RSS field) as a property to the newly created object.
            # The property name is set to the name of the child node, and the value is the inner text of the node.
            $Object | Add-Member -MemberType NoteProperty -Name $child.Name -Value $child.InnerText
        }

        # Output the created object for this RSS feed item.
        $Object
    }

    # Select specific properties (pubDate, title, and link) from the created objects
    # and store them as a list of RSS news items.
    $NewsItems = $Items | Select-Object pubdate,title,link

    # Return the selected RSS feed items.
    return $NewsItems
}


# Ensure the Feeds folder exists
if ($(Test-Path -Path "./Feeds") -eq $false) {
    New-Item -ItemType Directory -Path "./Feeds"
}

# Import the CSV file containing feed settings from the Feeds folder
$Feeds = Import-Csv -Path ./Feeds/FeedSettings.csv -Delimiter ";"

foreach ($Feed in $Feeds) {

    $Webhook = $Feed.Webhook

    # Fetch the current RSS feed for each entry in the CSV
    $Current = Get-SteamRSS -FeedUrl $Feed.URL

    # Load previously stored feeds from CSV if they exist
    if (Test-Path -Path "./Feeds/$($Feed.Name).csv") {
        $Previous = Import-CSV -Path "./Feeds/$($Feed.Name).csv" -Delimiter ";"
    } else {
        $Previous = @()
    }

    # Compare current feed items with previously stored items and post new ones
    foreach ($Item in $Current) {
        if ($Item.Title -notin $Previous.Title) {
            $Message = @{content = "$($Item.title) - $($Item.Link)"}
            $JSON = $Message | ConvertTo-Json
            Invoke-RestMethod -Uri $Webhook -Method Post -Body $JSON -ContentType "application/json"
            Start-Sleep -Seconds 1
        }
    }

    # Store the current feed to a CSV file for future comparison
    $Current | Export-Csv -Path "./Feeds/$($Feed.Name).csv" -Delimiter ";"

}
