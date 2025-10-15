library(dataverse)
library(tidyverse)
microclim <- get_dataframe_by_doi("10.48579/PRO/ZQBQUW/GBVNRR",
  server = "data.indores.fr"
) %>%
  filter(
    id_sensor == "59-32-a",
    year(datetime) == 2023
  )
write_tsv(microclim, "inst/extdata/hobo.tsv")
plot <- get_dataframe_by_doi("10.48579/PRO/RSBT3C/IJAKFT",
  server = "data.indores.fr"
) %>%
  filter(idplot == unique(microclim$id_plot))
