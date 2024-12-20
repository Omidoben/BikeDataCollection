% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/feeds_urls.R
\name{feeds_urls}
\alias{feeds_urls}
\title{Get Bikeshare Feed URLs}
\usage{
feeds_urls()
}
\value{
A tibble with feed names and corresponding URLs
}
\description{
Returns a tibble of available feed URLs for bikeshare data
}
\examples{
\dontrun{
feeds_urls() \%>\%
  filter(name == "system_information")
}
}
