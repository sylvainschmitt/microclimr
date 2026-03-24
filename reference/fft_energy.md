# FFT energy

Fast Fourier Transform (FFT): energy

## Usage

``` r
fft_energy(f)
```

## Arguments

- f:

  num. The Fourier coefficients.

## Value

\\E\\ the energy.

## Details

On the other hand, the so-called Parseval formula gives the *energy*:
\$\$E = \|c\_{0}\|^{2} + \frac 1 2\sum\_{n=1}^{\ell-1} \|c\_{n}\|^{2} =
\frac 1 T \int\_{0}^{T} \|s(t)\|^{2}dt \simeq \frac 1 N \sum\_{n=1}^{N}
\|S\_{n}\|^{2}\$\$

## Examples

``` r
fft_rfft(hobo$t_hobo[1:(24 * 5)]) %>%
  fft_energy()
#> [1] 317.6476
```
