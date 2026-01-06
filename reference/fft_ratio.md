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
  t,
  index_col,
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

- t:

  int. Time window, \\t=N\Delta t\\ where \\\Delta t\\ is the sampling
  interval.

- index_col:

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

- \\f\\ the Fourier coefficients of \\s\\ of length \\\ell\\, whose
  coefficients are \\c\_{0},c\_{1},\ldots,c\_{\ell-1}\\ for micro and
  macroclimate.

- \\P\\ array of powers, \\P\[n\] = \|c\_{n}\|\\ for
  \\n=1,\ldots,\ell-1\\ for micro and macroclimate.

- \\R\\ array of ratios of micro vs. macro-climate powers

## Details

Can be used with a grouped table, see vignette *to be linked*.

## Examples

``` r
data <- era %>%
  dplyr::rename(era = tas, datetime = time) %>%
  dplyr::select(datetime, era) %>%
  dplyr::left_join(dplyr::select(hobo, datetime, t_hobo) %>%
    dplyr::rename(hobo = t_hobo))
#> Joining with `by = join_by(datetime)`
fft_ratio(data, 24 * 5, "datetime", "hobo", "era") %>%
  dplyr::filter(period == 24) %>%
  summary()
#> Joining with `by = join_by(frequency, period, datetime)`
#>    frequency           period   coefficient_macro  power_macro    
#>  Min.   :0.04167   Min.   :24   Length:119        Min.   :0.4197  
#>  1st Qu.:0.04167   1st Qu.:24   Class :complex    1st Qu.:1.5442  
#>  Median :0.04167   Median :24   Mode  :complex    Median :2.8018  
#>  Mean   :0.04167   Mean   :24                     Mean   :2.7343  
#>  3rd Qu.:0.04167   3rd Qu.:24                     3rd Qu.:3.7916  
#>  Max.   :0.04167   Max.   :24                     Max.   :5.4461  
#>                                                                   
#>     datetime                   coefficient_micro  power_micro    
#>  Min.   :2023-01-04 12:30:00   Length:119        Min.   :0.5165  
#>  1st Qu.:2023-04-06 00:30:00   Class :complex    1st Qu.:1.5917  
#>  Median :2023-07-03 12:30:00   Mode  :complex    Median :2.4286  
#>  Mean   :2023-07-02 20:09:49                     Mean   :2.4598  
#>  3rd Qu.:2023-09-30 00:30:00                     3rd Qu.:3.3235  
#>  Max.   :2023-12-27 12:30:00                     Max.   :4.9065  
#>                                                  NA's   :25      
#>      ratio       
#>  Min.   :0.4093  
#>  1st Qu.:0.6407  
#>  Median :0.7461  
#>  Mean   :0.7823  
#>  3rd Qu.:0.9519  
#>  Max.   :1.2607  
#>  NA's   :25      
```
