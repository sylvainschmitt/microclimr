#' @importFrom stats fft
NULL

#' Fourier coefficients
#'
#' Fast Fourier Transform (FFT) of a series of temperatures.
#'
#' @param s num. Sampled temperatures at constant interval.
#'
#' @details
#'
#' A series \eqn{S} consisting of \eqn{N} samples measured at a time interval
#' \eqn{\Delta t} can be analyzed by a Fourier series
#'
#' \deqn{s(t) = a_{0} +  \sum_{n=1}^{\ell} a_{n} \cos(2\pi \tfrac{n}{T} t) +
#' b_{n}\sin(2\pi \tfrac n T t)}
#'
#' where \eqn{a_n} and \eqn{b_n} are the Fourier coefficients obtained from the
#' fast fourier transform (FFT) of \eqn{S}. Note, the time reference of the
#' first measure is \eqn{t=0}.
#'
#' The number of coeffcients is
#' \deqn{
#' \ell =
#' \begin{cases}
#' N/2 + 1 & \text{if } N \text{ is even} \\
#' (N+1)/2 & \text{if } N \text{ is odd}
#' \end{cases}
#' }
#'
#' Generally they take the form of complex number \deqn{c_{n} = a_{n} - i b_{n}
#' \,, \quad n=0,\ldots, \ell-1} with the convention \eqn{b_{0}=0}. Hence, we
#' have the relation \deqn{a_{n} = \Re (c_{n}) \text{ and }  b_{n} = -
#' \Im(c_{n})\,, \quad n=0,\ldots,\ell \,.}
#'
#' @returns
#'
#' \eqn{f} the Fourier coefficients of \eqn{s} of length \eqn{\ell}, whose
#' coefficients are \eqn{c_{0},c_{1},\ldots,c_{\ell-1}}
#'
#' @export
#'
#' @examples
#'
#' fft_rfft(hobo$t_hobo[1:(24 * 5)])
#'
fft_rfft <- function(s) {
  n <- length(s)
  l <- ifelse(n %% 2 == 0, (n %/% 2 + 1), ((n + 1) %/% 2))
  f <- fft(s)[1:l] / n
  f[2:l] <- f[2:l] * 2
  return(f) # nolint
}

#' FFT frequencies
#'
#' Fast Fourier Transform (FFT):  frequencies for a real signal of length t (in
#' time) with n samples.
#'
#' @param n int. Number of samples.
#' @param t int. Time window, \eqn{t=N\Delta t} where \eqn{\Delta t} is the
#'   sampling interval.
#'
#' @returns
#'
#' \eqn{f} the harmonics frequencies \eqn{1/y,\ldots \ell/t}.
#'
#' @export
#'
#' @examples
#'
#' fft_freq(201, 10)
#'
fft_freq <- function(n, t) {
  seq(1, n %/% 2) / t
}

#' FFT periods
#'
#' Fast Fourier Transform (FFT):  periods for a real signal of length t (in
#' time) with n samples.
#'
#' @param f num. The harmonics frequencies.
#'
#' @returns
#'
#' \eqn{p} the harmonics periods.
#'
#' @export
#'
#' @examples
#'
#' fft_freq(201, 10) %>%
#'   fft_period()
#'
fft_period <- function(f) {
  1 / f
}

#' FFT mean
#'
#' Fast Fourier Transform (FFT): mean temperature
#'
#' @param f num. The Fourier coefficients.
#'
#' @details
#'
#' The coefficient \eqn{a_{0}=c_{0}} plays a particular role, it is the mean
#' \deqn{a_{0} = \frac 1 N \sum_{n=1}^{N}S_{n}\,.}
#'
#' @returns
#'
#' \eqn{f[1]} the first real component of \eqn{f}.
#'
#' @export
#'
#' @examples
#'
#' fft_rfft(hobo$t_hobo[1:(24 * 5)]) %>%
#'   fft_mean()
#'
fft_mean <- function(f) {
  Re(f[1])
}

#' FFT powers
#'
#' Fast Fourier Transform (FFT): powers
#'
#' @param f num. The Fourier coefficients.
#'
#' @details
#'
#' The power of the \eqn{n}-th harmonics is
#' \deqn{|c_{n}| = \sqrt{a_{n}^{2}+b_{n}^{2}}\,,}
#' its frequency is \eqn{n/T} and period \eqn{T/n}, for \eqn{n=1,\ldots,\ell-1}.
#'
#' @returns
#'
#' \eqn{P} array of powers, \eqn{P[n] = |c_{n}|} for \eqn{n=1,\ldots,\ell-1}.
#'
#' @export
#'
#' @examples
#'
#' fft_rfft(hobo$t_hobo[1:(24 * 5)]) %>%
#'   fft_powers()
#'
fft_powers <- function(f) {
  abs(f[2:length(f)])
}

#' FFT energy
#'
#' Fast Fourier Transform (FFT): energy
#'
#' @param f num. The Fourier coefficients.
#'
#' @details
#'
#' On the other hand, the so-called Parseval formula gives the *energy*:
#' \deqn{|c_{0}|^{2} + \frac 1 2\sum_{n=1}^{\ell-1} |c_{n}|^{2} = \frac 1 T
#' \int_{0}^{T} |s(t)|^{2}dt \simeq \frac 1 N \sum_{n=1}^{N} |S_{n}|^{2}}
#'
#' @returns
#'
#' \eqn{E} the energy.
#'
#' @export
#'
#' @examples
#'
#' fft_rfft(hobo$t_hobo[1:(24 * 5)]) %>%
#'   fft_energy()
#'
fft_energy <- function(f) {
  sum(abs(f[2:length(f)])**2) / 2 + Re(f[1])**2
}

#' FFT variance
#'
#' Fast Fourier Transform (FFT): variance
#'
#' @param f num. The Fourier coefficients.
#'
#' @details
#'
#' interpreted as a variance by the formula \deqn{\frac 1 2 \sum_{n=1}^{\ell-1}
#' |c_{n}|^{2} = \frac 1 T \int_{0}^{T} |s(t)-c_{0}|^{2}dt \simeq \frac 1 N
#' \sum_{n=1}^{N} |S_{n}-c_{0}|^{2}}
#'
#' @returns
#'
#' \eqn{V} the variance.
#'
#' @export
#'
#' @examples
#'
#' fft_rfft(hobo$t_hobo[1:(24 * 5)]) %>%
#'   fft_variance()
#'
fft_variance <- function(f) {
  sum(abs(f[2:length(f)] - f[1])**2) / 2
}

#' FFT delay
#'
#' Fast Fourier Transform (FFT): delay per frequencies
#'
#' @param f num. The Fourier coefficients.
#' @param freq num. The harmonics frequencies.
#'
#' @returns
#'
#' \eqn{D} array of delays, \eqn{D[n] =\theta_{n}} for \eqn{n=1,\ldots,\ell-1}.
#'
#' @export
#'
#' @examples
#'
#' fft_rfft(hobo$t_hobo[1:(24 * 5)]) %>%
#'   fft_delay(fft_freq(24 * 5, 24 * 5))
#'
fft_delay <- function(f, freq) {
  Arg(f[2:length(f)]) / (2 * pi * freq)
}

#' FFT reconstruct
#'
#' Fast Fourier Transform (FFT): Reconstruct the temperatures at time t, whose
#' spectrum is 'f' associate to frequencies 'freq'
#'
#' @param f num. The Fourier coefficients.
#' @param freq num. The harmonics frequencies.
#' @param time num. Time array.
#'
#' @returns
#'
#' \eqn{s} an array that contains the value of \eqn{s(t)}.
#'
#' @export
#'
#' @examples
#'
#' fft_reconstruct(
#'   fft_rfft(hobo$t_hobo[1:(24 * 5)]),
#'   fft_freq(24 * 5, 24 * 5),
#'   1:24 * 5
#' )
#'
fft_reconstruct <- function(f, freq, time) {
  s <- Re(f[1])
  for (n in seq_along(freq)) {
    s <- s + Re(f[n + 1]) * cos(2 * pi * freq[n] * time) -
      Im(f[n + 1]) * sin(2 * pi * freq[n] * time)
  }
  return(s) # nolint
}

#' Fourier decomposition table
#'
#' Fast Fourier Transform (FFT) of a series of temperatures with resulting
#' frequencies, periods, coefficients and powers in a single table.
#'
#' @param s num. Sampled temperatures at constant interval.
#' @param t int. Time window, \eqn{t=N\Delta t} where \eqn{\Delta t} is the
#'   sampling interval.
#' @param period bool. To include period or not, default TRUE.
#' @param power bool. To include power or not, default TRUE.
#'
#' @returns
#'
#' A table with:
#' * \eqn{f} the harmonics frequencies \eqn{1/y,\ldots \ell/t}
#' * \eqn{p} the harmonics periods
#' * \eqn{f} the Fourier coefficients of \eqn{s} of length \eqn{\ell}, whose
#' coefficients are \eqn{c_{0},c_{1},\ldots,c_{\ell-1}}
#' * \eqn{P} array of powers, \eqn{P[n] = |c_{n}|} for \eqn{n=1,\ldots,\ell-1}
#'
#' @export
#'
#' @examples
#'
#' fft_tab(hobo$t_hobo[1:(24 * 5)], 24*5)
#'
fft_tab <- function(s, t, period = TRUE, power = TRUE) {
  fc <- fft_rfft(s)
  freq <- fft_freq(length(s), t)
  data.frame(
    frequency = c(0, freq),
    period = c(0, fft_period(freq)),
    coefficient = fc,
    power = c(fft_mean(fc),
              fft_powers(fc))
  )
}
