# Fourier ratio

Fast Fourier Transform (FFT) of two series of microclimatic and
macroclimatic temperatures in a table with a rolling window across a
time index with resulting frequencies, periods, micro and macro
coefficients and micro and macro powers, and the ratio of power between
the micro and macroclimate per window in a single table.

## Usage

``` r
fft_ratio(
  data,
  time_window,
  time_col,
  microclimate_col,
  macroclimate_col,
  window = "5 days",
  step = "3 days",
  period = TRUE,
  power = TRUE
)
```

## Arguments

- data:

  df. The data frame with a column containing the time index and a
  column containing the temperature.

- time_window:

  int. Time window, \\T=N\Delta t\\ where \\\Delta t\\ is the sampling
  interval.

- time_col:

  char. The name of the column containing the time index.

- microclimate_col:

  char. The name of the column containing the microclimate temperature
  series.

- macroclimate_col:

  char. The name of the column containing the macroclimate temperature
  series.

- window:

  time. Window size, can be expressed in time units see
  [runner::runner](https://rdrr.io/pkg/runner/man/runner.html), default
  is 5 days

- step:

  time. Window step, can be expressed in time units see
  [runner::runner](https://rdrr.io/pkg/runner/man/runner.html), defaults
  is 3 days.

- period:

  bool. To include period or not, default TRUE.

- power:

  bool. To include power or not, default TRUE.

## Value

A table with:

- the datetime of the window

- \\f\\ the harmonics frequencies \\1/y,\ldots \ell/t\\

- \\p\\ the harmonics periods

- \\a\_{n}\\ the amplitudes of the Fourier coefficients of \\s\\ of
  length \\\ell\\, whose values are \\a\_{0},a\_{1},\ldots,c\_{\ell-1}\\

- \\b\_{n}\\ the phases of the Fourier coefficients of \\s\\ of length
  \\\ell\\, whose values are \\a\_{0},a\_{1},\ldots,c\_{\ell-1}\\

- \\P\\ array of powers, \\P\[n\] = \|c\_{n}\|\\ for
  \\n=1,\ldots,\ell-1\\ for micro and macroclimate.

- \\R\\ array of ratios of micro vs. macro-climate powers

## Details

Can be used with a grouped table, see
[vignette](https://sylvainschmitt.github.io/microclimr/reference/Examples.md).

## Examples

``` r

data <- era |>
  dplyr::rename(era = tas, datetime = time) |>
  dplyr::select(datetime, era) |>
  dplyr::left_join(
    dplyr::select(hobo, datetime, t_hobo) |>
      dplyr::rename(hobo = t_hobo),
    by = dplyr::join_by(datetime)
  )
fft_ratio(
  data = data, time_window = 24 * 5, time_col = "datetime",
  microclimate_col = "hobo", macroclimate_col = "era"
) |>
  dplyr::filter(period == 24) |>
  dplyr::summarise_all(mean, na.rm = TRUE)
#> # A tibble: 1 × 10
#>   datetime            frequency period amplitude_macro phase_macro power_macro
#>   <dttm>                  <dbl>  <dbl>           <dbl>       <dbl>       <dbl>
#> 1 2023-07-02 20:09:49    0.0417     24           -2.47        1.08        2.73
#> # ℹ 4 more variables: amplitude_micro <dbl>, phase_micro <dbl>,
#> #   power_micro <dbl>, ratio <dbl>
```
