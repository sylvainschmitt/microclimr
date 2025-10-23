#' ERA5-Land macroclimatic data for the Mormal forest
#'
#' ERA5-Land temperature at 2ms have been extracted from the Google Earth Engine
#' (GEE) for longitude 3.70 and latitude 50.2 corresponding to the Mormal
#' forest. The ERA5-Land dataset is available for public use for the period from
#' 1950 to 5 days before the current date. ERA5-Land provides hourly high
#' resolution information of surface variables. The data is a replay of the land
#' component of the ERA5 climate reanalysis with a finer spatial resolution:
#' ~9km grid spacing. ERA5-Land includes information about uncertainties for all
#' variables at reduced spatial and temporal resolutions.
#'
#' * [Munoz-Sabater et al. 2021](https://essd.copernicus.org/articles/13/4349/2021/essd-13-4349-2021.html) #nolint
#' * [GEE documentation](https://developers.google.com/earth-engine/datasets/catalog/ECMWF_ERA5_LAND_HOURLY?hl=fr) #nolint
#'
#' @format A data frame with X rows and X variables: \describe{
#'   \item{time}{dttm Date and time of the temperature reanalysis with a
#'   frequency of 1-hr.} \item{lat}{dbl. Latitude in degree.} \item{lon}{dbl.
#'    Longitude in degree.}
#'   \item{tas}{dbl. Temperature at 2m in degree Celsisus. Air temperature 2
#'   metres above the surface of land, sea or inland waters. The 2-metre
#'   temperature is calculated by interpolating between the lowest model level
#'   and the Earth's surface, taking atmospheric conditions into account.}}
#'
"era"

# era <- readr::read_tsv("inst/extdata/era.tsv") #nolint
# usethis::use_data(era, overwrite = TRUE) #nolint
