# Fourier table

Fast Fourier Transform (FFT) of a series of temperatures with resulting
frequencies, periods, amplitudes, phase, and powers in a single table.

## Usage

``` r
fft_tab(temperatures, time_window, period = TRUE, power = TRUE)
```

## Arguments

- temperatures:

  num. Series of temperatures at constant interval.

- time_window:

  int. Time window, \\T=n\Delta t\\ where \\\Delta t\\ is the sampling
  interval.

- period:

  bool. To include period or not, default TRUE.

- power:

  bool. To include power or not, default TRUE.

## Value

A table with:

- \\f\\ the harmonics frequencies \\1/t,\ldots \ell/t\\

- \\p\\ the harmonics periods

- \\a\_{n}\\ the amplitudes of the Fourier coefficients of \\s\\ of
  length \\\ell\\, whose values are \\a\_{0},a\_{1},\ldots,c\_{\ell-1}\\

- \\b\_{n}\\ the phases of the Fourier coefficients of \\s\\ of length
  \\\ell\\, whose values are \\a\_{0},a\_{1},\ldots,c\_{\ell-1}\\

- \\P\\ array of powers, \\P\[n\] = \|c\_{n}\|\\ for
  \\n=1,\ldots,\ell-1\\

## Examples

``` r

fft_tab(temperatures = hobo$t_hobo[1:(24 * 5)], time_window = 24 * 5)
#> # A tibble: 61 × 5
#>    frequency period amplitude  phase  power
#>        <dbl>  <dbl>     <dbl>  <dbl>  <dbl>
#>  1   0          0     17.6     0     17.6  
#>  2   0.00833  120      0.352   1.11   1.17 
#>  3   0.0167    60      0.0169  0.306  0.306
#>  4   0.025     40      0.787  -0.491  0.928
#>  5   0.0333    30     -0.366   0.406  0.547
#>  6   0.0417    24      0.562  -0.706  0.902
#>  7   0.05      20     -0.700   0.909  1.15 
#>  8   0.0583    17.1   -0.130   0.151  0.199
#>  9   0.0667    15      0.260   0.262  0.369
#> 10   0.075     13.3   -0.835   0.247  0.871
#> # ℹ 51 more rows
```
