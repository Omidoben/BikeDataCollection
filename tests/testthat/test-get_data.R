feeds <- feeds_urls()

url <- feeds %>%
  filter(name == "station_status") %>%
  pull(url)

test_that("`get_data` returns a `bike_data` type", {
  data <- get_data(url)
  expect_type(data, "list")
})

