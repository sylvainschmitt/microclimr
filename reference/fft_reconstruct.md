# FFT reconstruct

Fast Fourier Transform (FFT): Reconstruct the temperatures at time t,
whose spectrum is 'f' associate to frequencies 'freq'

## Usage

``` r
fft_reconstruct(f, freq, time)
```

## Arguments

- f:

  num. The Fourier coefficients.

- freq:

  num. The harmonics frequencies.

- time:

  num. Time array.

## Value

\\s\\ an array that contains the value of \\s(t)\\.

## Examples

``` r
fft_reconstruct(
  fft_rfft(hobo$t_hobo[1:(24 * 5)]),
  fft_freq(24 * 5, 24 * 5),
  1:24 * 5
)
#>  [1] 18.32238 18.33862 16.70438 15.86362 13.93138 16.53063 23.56938 14.52663
#>  [9] 16.22837 19.57562 15.84638 15.29163 18.60838 17.10162 23.66537 14.52662
#> [17] 19.17837 16.91163 20.13037 19.28962 17.18037 18.62363 19.46438 19.57563
```
