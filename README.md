
# BikeDataCollection






## Overview

BikeDataCollection is an R package designed to simplify the process of collecting data from the Capital Bikeshare API. It contains functions for interacting with data from https://capitalbikeshare.com. 


### API Endpoints in Capital Bikeshare
The Capital Bikeshare API provides multiple feeds (API endpoints) to access various types of data about the bike-sharing system. Each feed serves a specific purpose, such as retrieving system-wide information, station details, or real-time availability.

### Example Feeds
Below are some of the available feeds and their respective endpoints:


| **Feed Name**           | **Description**                                      | **Endpoint URL**                                                                                  |
|--------------------------|------------------------------------------------------|--------------------------------------------------------------------------------------------------|
| `system_information`     | General information about the system, such as name and location. | [System Information](https://gbfs.capitalbikeshare.com/gbfs/en/system_information.json)          |
| `station_information`    | Detailed data about bike stations, including location and capacity. | [Station Information](https://gbfs.capitalbikeshare.com/gbfs/en/station_information.json)        |
| `station_status`         | Real-time status of bike stations, such as bike availability. | [Station Status](https://gbfs.capitalbikeshare.com/gbfs/en/station_status.json)                 |


### How to Use BikeDataCollection to Access a Feed
The BikeDataCollection package makes it easy to fetch data from these feeds. You can use the feeds_urls() function to view all available feeds and their endpoints.

## Installation
You can install the package directly from GitHub using the remotes/devtools packages:

#### Install remotes if not already installed
install.packages("remotes")

#### Install BikeDataCollection
remotes::install_github("Omidoben/BikeDataCollection")

#### Step 1: View All Feeds

library(BikeDataCollection)

Retrieve and view all feeds 

feeds <- feeds_urls() 

print(feeds)

#### Step 2: Collect Data from a Specific Feed
To collect data from a specific feed, filter for the desired feed name, extract its URL, and fetch the data using the get_data() function.

Example: Fetching Station Information

feeds_urls() %>%  
filter(name == "station_information") %>%  
pull(url) %>%  
get_data()

