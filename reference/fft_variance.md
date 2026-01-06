# FFT variance

Fast Fourier Transform (FFT): variance

## Usage

``` r
fft_variance(f)
```

## Arguments

- f:

  num. The Fourier coefficients.

## Value

\\V\\ the variance.

## Details

interpreted as a variance by the formula \$\$\frac 1 2
\sum\_{n=1}^{\ell-1} \|c\_{n}\|^{2} = \frac 1 T \int\_{0}^{T}
\|s(t)-c\_{0}\|^{2}dt \simeq \frac 1 N \sum\_{n=1}^{N}
\|S\_{n}-c\_{0}\|^{2}\$\$

## Examples

``` r
fft_rfft(hobo$t_hobo[1:(24 * 5)]) %>%
  fft_variance()
#> [1] 9286.579
```
