library(dplyr)
library(magrittr)
library(httr2)
library(purrr)

#' Get Bikeshare Feed URLs
#'
#' Returns a tibble of available feed URLs for bikeshare data
#' @importFrom tibble tibble
#' @importFrom magrittr %>%
#' @importFrom dplyr filter
#' @return A tibble with feed names and corresponding URLs
#' @export
#' @examples
#' \dontrun{
#' feeds_urls() %>%
#'   filter(name == "system_information")
#' }
feeds_urls <- function(){
  tibble::tibble(
    name = c(
      "system_information",
      "station_information",
      "station_status",
      "free_bike_status",
      "system_hours",
      "system_calendar",
      "system_regions",
      "system_pricing_plans",
      "system_alerts",
      "vehicle_types"
    ),
    url = c(
      "https://gbfs.lyft.com/gbfs/2.3/dca-cabi/en/system_information.json",
      "https://gbfs.lyft.com/gbfs/2.3/dca-cabi/en/station_information.json",
      "https://gbfs.lyft.com/gbfs/2.3/dca-cabi/en/station_status.json",
      "https://gbfs.lyft.com/gbfs/2.3/dca-cabi/en/free_bike_status.json",
      "https://gbfs.lyft.com/gbfs/2.3/dca-cabi/en/system_hours.json",
      "https://gbfs.lyft.com/gbfs/2.3/dca-cabi/en/system_calendar.json",
      "https://gbfs.lyft.com/gbfs/2.3/dca-cabi/en/system_regions.json",
      "https://gbfs.lyft.com/gbfs/2.3/dca-cabi/en/system_pricing_plans.json",
      "https://gbfs.lyft.com/gbfs/2.3/dca-cabi/en/system_alerts.json",
      "https://gbfs.lyft.com/gbfs/2.3/dca-cabi/en/vehicle_types.json"
    )
  )
}



#' Retrieve Bikeshare Data from GBFS Feed
#'
#' @param url URL of the GBFS feed to retrieve
#' @importFrom dplyr filter rename pull
#' @importFrom httr2 request req_perform resp_body_json
#' @importFrom purrr pluck map_dfr
#' @importFrom stringr str_detect
#' @importFrom tibble tibble
#' @importFrom tidyr unnest_wider
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @return A list containing the data and last updated time stamp
#' @export
#' @details
#' This package provides functions to retrieve and process bike-sharing system data using the General Bikeshare Feed Specification (GBFS).
#' It allows users to easily fetch and analyze bikeshare information from various data feeds.
#'
#' @examples
#' \dontrun{
#' feeds_urls() %>%
#'   filter(name == "station_information") %>%
#'   pull(url) %>%
#'   get_data()
#'}
get_data <- function(url) {
  # Perform the request
  response <- request(url) %>% req_perform()

  json_data <- resp_body_json(response)

  if (stringr::str_detect(url, "station_information")) {
    station_info <- json_data %>%
      pluck("data", "stations") %>%
      map_dfr(
        \(x) {
          tibble(
            name = x %>% pluck("name"),
            short_name = x %>% pluck("short_name"),
            station_id = x %>% pluck("station_id"),
            region_id = x %>% pluck("region_id"),
            capacity = x %>% pluck("capacity"),
            lat = x %>% pluck("lat"),
            lon = x %>% pluck("lon")
          )
        }
      )

    return(list(
      data = station_info,
      last_updated = as.POSIXct(json_data$last_updated, origin = "1970-01-01 00:00:00 UTC")
    ))

  } else if (stringr::str_detect(url, "station_status")) {
    station_status <- json_data %>%
      pluck("data", "stations") %>%
      map_dfr(
        \(x) {
          tibble(
            last_reported = as.POSIXct(x %>% pluck("last_reported"), origin = "1970-01-01 00:00:00 UTC"),
            station_id = x %>% pluck("station_id"),
            num_scooters_available = x %>% pluck("num_scooters_available"),
            vehicle_types_available = x %>% pluck("vehicle_types_available"),
            num_docks_available = x %>%  pluck("num_docks_available"),
            num_bikes_available = x %>% pluck("num_bikes_available"),
            is_renting = x %>% pluck("is_renting"),
            is_returning = x %>% pluck("is_returning"),
            is_installed = x %>% pluck("is_installed"),
            num_ebikes_available = x %>% pluck("num_ebikes_available"),
            num_bikes_disabled = x %>% pluck("num_bikes_disabled"),
            num_docks_disabled = x %>% pluck("num_docks_disabled"),
            num_scooters_unavailable = x %>% pluck("num_scooters_unavailable")
          )
        }
      ) %>%
      tidyr::unnest_wider("vehicle_types_available") %>%
      rename(vehicle_count = .data$count)

    return(list(
      data = station_status,
      last_updated = as.POSIXct(json_data$last_updated, origin = "1970-01-01 00:00:00 UTC")
    ))
  } else {
    # Handle other types of URLs or unexpected input
    stop("Unsupported URL type. Please use station_information or station_status URL.")
  }
}



# station information data
#station_info <- feeds_urls() %>%
#  filter(name == "station_information") %>%
#  pull(url) %>%
#  get_data()


# station status data
#station_status <- feeds_urls() %>%
#  filter(name == "station_status") %>%
#  pull(url) %>%
#  get_data()













