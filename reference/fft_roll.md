# Fourier roll

Fast Fourier Transform (FFT) of a series of temperatures in a table with
a rolling window across a time index with resulting frequencies,
periods, coefficients and powers per window in a single table.

## Usage

``` r
fft_roll(
  data,
  t,
  index_col,
  temperature_col,
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

- temperature_col:

  char. The name of the column containing the temperature series.

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
  coefficients are \\c\_{0},c\_{1},\ldots,c\_{\ell-1}\\

- \\P\\ array of powers, \\P\[n\] = \|c\_{n}\|\\ for
  \\n=1,\ldots,\ell-1\\

## Details

Can be used with a grouped table, see vignette *to be linked*.

## Examples

``` r

fft_roll(hobo, 24 * 5, "datetime", "t_hobo")
#> # A tibble: 5,795 × 5
#>    frequency period coefficient               power datetime           
#>        <dbl>  <dbl> <cpl>                     <dbl> <dttm>             
#>  1   0          0    9.01535000+0.000000000i 9.02   2023-01-04 12:30:00
#>  2   0.00833  120   -0.12125482+1.794875875i 1.80   2023-01-04 12:30:00
#>  3   0.0167    60    1.30348035-0.038889968i 1.30   2023-01-04 12:30:00
#>  4   0.025     40    0.08618219-0.450934147i 0.459  2023-01-04 12:30:00
#>  5   0.0333    30    0.45434402-0.003320929i 0.454  2023-01-04 12:30:00
#>  6   0.0417    24   -0.82905112-0.014600826i 0.829  2023-01-04 12:30:00
#>  7   0.05      20    0.17581612+0.133959876i 0.221  2023-01-04 12:30:00
#>  8   0.0583    17.1  0.32516988-0.195914277i 0.380  2023-01-04 12:30:00
#>  9   0.0667    15   -0.04565313-0.234288530i 0.239  2023-01-04 12:30:00
#> 10   0.075     13.3 -0.08615347+0.040276157i 0.0951 2023-01-04 12:30:00
#> # ℹ 5,785 more rows
```
