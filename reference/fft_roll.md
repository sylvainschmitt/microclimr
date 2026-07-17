# Fourier roll

Fast Fourier Transform (FFT) of a series of temperatures in a table with
a rolling window across a time index with resulting frequencies,
periods, coefficients and powers per window in a single table.

## Usage

``` r
fft_roll(
  data,
  time_window,
  time_col,
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

- time_window:

  int. Time window, \\T=n\Delta t\\ where \\\Delta t\\ is the sampling
  interval.

- time_col:

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

- \\a\_{n}\\ the amplitudes of the Fourier coefficients of \\s\\ of
  length \\\ell\\, whose values are \\a\_{0},a\_{1},\ldots,c\_{\ell-1}\\

- \\b\_{n}\\ the phases of the Fourier coefficients of \\s\\ of length
  \\\ell\\, whose values are \\a\_{0},a\_{1},\ldots,c\_{\ell-1}\\

- \\P\\ array of powers, \\P\[n\] = \|c\_{n}\|\\ for
  \\n=1,\ldots,\ell-1\\

## Details

Can be used with a grouped table, see vignette *to be linked*.

## Examples

``` r

fft_roll(
  data = hobo, time_window = 24 * 5,
  time_col = "datetime", temperature_col = "t_hobo"
)
#> # A tibble: 5,795 × 6
#>    datetime            frequency period amplitude    phase  power
#>    <dttm>                  <dbl>  <dbl>     <dbl>    <dbl>  <dbl>
#>  1 2023-01-04 12:30:00   0          0      9.02    0       9.02  
#>  2 2023-01-04 12:30:00   0.00833  120     -0.121   1.79    1.80  
#>  3 2023-01-04 12:30:00   0.0167    60      1.30   -0.0389  1.30  
#>  4 2023-01-04 12:30:00   0.025     40      0.0862 -0.451   0.459 
#>  5 2023-01-04 12:30:00   0.0333    30      0.454  -0.00332 0.454 
#>  6 2023-01-04 12:30:00   0.0417    24     -0.829  -0.0146  0.829 
#>  7 2023-01-04 12:30:00   0.05      20      0.176   0.134   0.221 
#>  8 2023-01-04 12:30:00   0.0583    17.1    0.325  -0.196   0.380 
#>  9 2023-01-04 12:30:00   0.0667    15     -0.0457 -0.234   0.239 
#> 10 2023-01-04 12:30:00   0.075     13.3   -0.0862  0.0403  0.0951
#> # ℹ 5,785 more rows
```
