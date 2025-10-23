#' HOBO micrloclimatic data from the Mormal forest
#'
#' Air temperature at 1-m above the ground at every hour for the sensor
#' "59-32-a" in 2023 within plot "59-32" from the Mormal forest. Data are from
#' the ANR IMPRINT Project (2019-2023): temperature time series of each plot for
#' the three studied forests (Mormal, Blois and Aigoual). Two HOBO sensors were
#' placed at the center of each of 60 plots, to measure air temperature (1 m
#' above the ground; every hour), and soil temperature (8 cm below the ground;
#' every two hours). This dataset is a compilation of all soil and air
#' temperatures measured by HOBO sensors in each plot: (1) Mormal forest: the
#' time series ranges from 2020-08-03 to 2023-10-23; (2) Blois forest: the time
#' series ranges from 2020-07-11 to 2023-08-28; (3) Aigoual forest: the time
#' series ranges from 2020-07-31 to 2023-09-17. Note that some plots may have
#' holes (missing data) in the time series.
#'
#' - [Dataverse](https://data.indores.fr/dataset.xhtml?persistentId=doi:10.48579/PRO/ZQBQUW) #nolint
#' - [Gril et al. 2024](https://onlinelibrary.wiley.com/doi/full/10.1111/jvs.13241) #nolint
#'
#' @format A data frame with 6,927 observations and 9 variables: \describe{
#'   \item{id_sensor}{the plot ID and position, corresponding to a single HOBO
#'   sensor} \item{id_plot}{the plot ID, with two parts: the first corresponds
#'   to the forest location (code of the French department), and the second to
#'   an arbitrary number from 01 to 60 in each forest} \item{position_sensor}{
#'   the first corresponds to the forest location (code of the French
#'    department), and the second to an arbitrary number from 01 to 60
#'    in each forest} \item{datetime}{the date and time of the measurement, on a
#'     GMT+0 time zone}
#'   \item{month}{month, in word format ("January", "February"…)}
#'   \item{month_num}{ month, in number format (from 1 to 12)} \item{date}{date
#'   without the time} \item{time}{time without the date}
#'   \item{t_hobo}{temperature measured by the air or soil HOBO sensor}}
#'
"hobo"

# hobo <- readr::read_tsv("inst/extdata/hobo.tsv") #nolint
# usethis::use_data(hobo, overwrite = TRUE) #nolint
