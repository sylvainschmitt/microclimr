# FFT reconstruct

Fast Fourier Transform (FFT): Reconstruct the temperatures at time t,
whose coefficients are 'c' associate to frequencies 'f'

## Usage

``` r
fft_reconstruct(coefficients, frequencies, times)
```

## Arguments

- coefficients:

  num. The Fourier coefficients.

- frequencies:

  num. The harmonics frequencies.

- times:

  num. Time array.

## Value

\\s\\ an array that contains the value of the series of temperature
\\s(t)\\.

## Examples

``` r

fft_reconstruct(
  coefficients = fft_rfft(temperatures = hobo$t_hobo[1:(24 * 5)]),
  frequencies = fft_freq(samples = 24 * 5, time_window = 24 * 5),
  times = 1:24 * 5
)
#>  [1] 18.32238 18.33862 16.70438 15.86362 13.93138 16.53063 23.56938 14.52663
#>  [9] 16.22837 19.57562 15.84638 15.29163 18.60838 17.10162 23.66537 14.52662
#> [17] 19.17837 16.91163 20.13037 19.28962 17.18037 18.62363 19.46438 19.57563
```
