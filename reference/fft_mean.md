# FFT mean

Fast Fourier Transform (FFT): mean temperature

## Usage

``` r
fft_mean(c)
```

## Arguments

- c:

  num. The Fourier coefficients.

## Value

\\f\[1\]\\ the first real component of \\f\\.

## Details

The coefficient \\a\_{0}=c\_{0}\\ plays a particular role, it is the
mean \$\$a\_{0} = \frac 1 N \sum\_{n=1}^{N}S\_{n}\\.\$\$

## Examples

``` r

fft_rfft(hobo$t_hobo[1:(24 * 5)]) |>
  fft_mean()
#> [1] 17.61993
```
