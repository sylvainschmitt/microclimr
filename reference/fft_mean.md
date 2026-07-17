# FFT mean

Fast Fourier Transform (FFT): mean temperature

## Usage

``` r
fft_mean(coefficients)
```

## Arguments

- coefficients:

  num. The Fourier amplitudes.

## Value

\\f\[1\]\\ the first real component of \\f\\.

## Details

The amplitude \\a\_{0}\\ plays a particular role, it is the mean
\$\$a\_{0} = \frac 1 N \sum\_{n=1}^{N}S\_{n}\\.\$\$

## Examples

``` r

fft_rfft(temperatures = hobo$t_hobo[1:(24 * 5)]) |>
  fft_mean()
#> [1] 17.61993
```
