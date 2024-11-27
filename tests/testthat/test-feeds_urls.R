test_that("feeds_urls returns correct tibble", {
  url_data <- feeds_urls()

  expect_s3_class(url_data, "tbl_df")

  expect_named(url_data, c("name", "url"))

  expect_true("station_information" %in% url_data$name)
})


# expect_s3_class(object, class): checks if an object belongs to a specific S3 class.
#                                 Here it checks if url_data is a tibble

# expect_named(object, expected_names): Verifies that an object (like a list or data frame) has specific column or element names












