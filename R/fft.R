#' @importFrom stats fft
#' @importFrom dplyr arrange reframe mutate full_join rename_with pick
#' @importFrom dplyr select join_by
#' @importFrom tidyr unnest
#' @importFrom tidyselect everything
#' @importFrom tibble tibble
#' @importFrom runner runner
#' @importFrom rlang :=
NULL

#' Fourier coefficients
#'
#' Fast Fourier Transform (FFT) of a series of temperatures.
#'
#' @param temperatures num. Series of temperatures at constant interval.
#'
#' @details
#'
#' A series \eqn{S=S_1,\ldots,S_N} consisting of \eqn{N} samples measured at a
#' time interval \eqn{\Delta t} can be analyzed by a Fourier series
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
#' \,, \quad n=0,\ldots, \ell-1} with \eqn{b_{0}=0}. Hence, we
#' have the relation \deqn{a_{n} = \Re (c_{n}) \text{ and }  b_{n} = -
#' \Im(c_{n})\,, \quad n=0,\ldots,\ell \,.}
#'
#' @returns
#'
#' \eqn{c} the Fourier coefficients of \eqn{S} of length \eqn{\ell}, whose
#' coefficients are \eqn{c_{0},c_{1},\ldots,c_{\ell-1}}
#'
#' @export
#'
#' @examples
#'
#' fft_rfft(temperatures = hobo$t_hobo[1:(24 * 5)])
#'
fft_rfft <- function(temperatures) {
  n <- length(temperatures)
  l <- ifelse(n %% 2 == 0, (n %/% 2 + 1), ((n + 1) %/% 2))
  coeffs <- fft(temperatures)[1:l] / n
  coeffs[2:l] <- coeffs[2:l] * 2
  return(coeffs) # nolint
}

#' FFT amplitude
#'
#' Fast Fourier Transform (FFT): get amplitudes from coefficients
#'
#' @param coefficients num. The Fourier coefficients.
#'
#' @returns
#'
#' \eqn{a_{n}} array of amplitudes.
#'
#' @export
#'
#' @examples
#'
#' fft_rfft(temperatures = hobo$t_hobo[1:(24 * 5)]) |>
#'   fft_amplitude()
#'
fft_amplitude <- function(coefficients) {
  Re(coefficients)
}

#' FFT phase
#'
#' Fast Fourier Transform (FFT): get phases from coefficients
#'
#' @param coefficients num. The Fourier coefficients.
#'
#' @returns
#'
#' \eqn{b_{n}} array of phases.
#'
#' @export
#'
#' @examples
#'
#' fft_rfft(temperatures = hobo$t_hobo[1:(24 * 5)]) |>
#'   fft_phase()
#'
fft_phase <- function(coefficients) {
  Im(coefficients)
}

#' FFT Rebuild coefficient
#'
#' Fast Fourier Transform (FFT): get coefficients from amplitude and phase
#'
#' @param amplitudes num. The Fourier amplitudes
#' @param phases num. The Fourier phases
#'
#' @returns
#'
#' \eqn{c} the Fourier coefficients of \eqn{S} of length \eqn{\ell}, whose
#' coefficients are \eqn{c_{0},c_{1},\ldots,c_{\ell-1}}
#'
#' @export
#'
#' @examples
#'
#' c <- fft_rfft(temperatures = hobo$t_hobo[1:(24 * 5)])
#' a <- fft_amplitude(c)
#' p <- fft_phase(c)
#' fft_coefficient(amplitudes = a, phases = p)
#'
fft_coefficient <- function(amplitudes, phases) {
  complex(real = amplitudes, imaginary = phases)
}

#' FFT frequency
#'
#' Fast Fourier Transform (FFT):  frequencies for a real signal of length T (in
#' time) with n samples.
#'
#' @param samples int. Number of samples.
#' @param time_window int. Time window, \eqn{T=n\Delta t} where \eqn{\Delta t}
#'   is the sampling interval.
#'
#' @returns
#'
#' \eqn{f} the harmonics frequencies \eqn{1/t,\ldots (\ell-1)/t}
#'
#' @export
#'
#' @examples
#'
#' fft_freq(samples = 201, time_window = 10)
#'
fft_freq <- function(samples, time_window) {
  seq(1, samples %/% 2) / time_window
}

#' FFT periods
#'
#' Fast Fourier Transform (FFT):  periods for a real signal of length T (in
#' time) with n samples.
#'
#' @param frequencies num. The harmonics frequencies.
#'
#' @returns
#'
#' \eqn{p} the harmonics periods, \eqn{p=1/f}.
#'
#' @export
#'
#' @examples
#'
#' fft_freq(samples = 201, time_window = 10) |>
#'   fft_period()
#'
fft_period <- function(frequencies) {
  1 / frequencies
}

#' FFT mean
#'
#' Fast Fourier Transform (FFT): mean temperature
#'
#' @param coefficients num. The Fourier amplitudes.
#'
#' @details
#'
#' The amplitude \eqn{a_{0}} plays a particular role, it is the mean
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
#' fft_rfft(temperatures = hobo$t_hobo[1:(24 * 5)]) |>
#'   fft_mean()
#'
fft_mean <- function(coefficients) {
  Re(coefficients[1])
}

#' FFT power
#'
#' Fast Fourier Transform (FFT): powers
#'
#' @param coefficients num. The Fourier coefficients.
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
#' fft_rfft(temperatures = hobo$t_hobo[1:(24 * 5)]) |>
#'   fft_power()
#'
fft_power <- function(coefficients) {
  abs(coefficients[2:length(coefficients)])
}

#' FFT energy
#'
#' Fast Fourier Transform (FFT): energy
#'
#' @param coefficients num. The Fourier coefficients.
#'
#' @details
#'
#' On the other hand, the so-called Parseval formula gives the *energy*:
#' \deqn{E = |c_{0}|^{2} + \frac 1 2\sum_{n=1}^{\ell-1} |c_{n}|^{2} = \frac 1 T
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
#' fft_rfft(temperatures = hobo$t_hobo[1:(24 * 5)]) |>
#'   fft_energy()
#'
fft_energy <- function(coefficients) {
  sum(abs(coefficients[2:length(coefficients)])**2) / 2 + Re(coefficients[1])**2
}

#' FFT variance
#'
#' Fast Fourier Transform (FFT): variance
#'
#' @param coefficients num. The Fourier coefficients.
#'
#' @details
#'
#' interpreted as a variance by the formula
#' \deqn{V = \frac 1 2 \sum_{n=1}^{\ell-1}
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
#' fft_rfft(temperatures = hobo$t_hobo[1:(24 * 5)]) |>
#'   fft_variance()
#'
fft_variance <- function(coefficients) {
  sum(abs(coefficients[2:length(coefficients)] - coefficients[1])**2) / 2
}

#' FFT delay
#'
#' Fast Fourier Transform (FFT): delay per frequencies
#'
#' @param coefficients num. The Fourier coefficients.
#' @param frequencies num. The harmonics frequencies.
#'
#' @returns
#'
#' \eqn{D} array of delays, \eqn{D[n] =\theta_{n}} for \eqn{n=1,\ldots,\ell-1}.
#'
#' @export
#'
#' @examples
#'
#' fft_rfft(temperatures = hobo$t_hobo[1:(24 * 5)]) |>
#'   fft_delay(fft_freq(samples = 24 * 5, time_window = 24 * 5))
#'
fft_delay <- function(coefficients, frequencies) {
  Arg(coefficients[2:length(coefficients)]) / (2 * pi * frequencies)
}

#' FFT reconstruct
#'
#' Fast Fourier Transform (FFT): Reconstruct the temperatures at time t, whose
#' coefficients are 'c' associate to frequencies 'f'
#'
#' @param coefficients num. The Fourier coefficients.
#' @param frequencies num. The harmonics frequencies.
#' @param times num. Time array.
#'
#' @returns
#'
#' \eqn{s} an array that contains the value of the series of temperature
#' \eqn{s(t)}.
#'
#' @export
#'
#' @examples
#'
#' fft_reconstruct(
#'   coefficients = fft_rfft(temperatures = hobo$t_hobo[1:(24 * 5)]),
#'   frequencies = fft_freq(samples = 24 * 5, time_window = 24 * 5),
#'   times = 1:24 * 5
#' )
#'
fft_reconstruct <- function(coefficients,
                            frequencies,
                            times) {
  temperatures <- Re(coefficients[1])
  for (n in seq_along(frequencies)) {
    temperatures <- temperatures +
      Re(coefficients[n + 1]) * cos(2 * pi * frequencies[n] * times) -
      Im(coefficients[n + 1]) * sin(2 * pi * frequencies[n] * times)
  }
  return(temperatures) # nolint
}

#' Fourier table
#'
#' Fast Fourier Transform (FFT) of a series of temperatures with resulting
#' frequencies, periods, amplitudes, phase, and powers in a single table.
#'
#' @param temperatures num. Series of temperatures at constant interval.
#' @param time_window int. Time window, \eqn{T=n\Delta t} where \eqn{\Delta t}
#'   is the sampling interval.
#' @param period bool. To include period or not, default TRUE.
#' @param power bool. To include power or not, default TRUE.
#'
#' @returns
#'
#' A table with:
#' * \eqn{f} the harmonics frequencies \eqn{1/t,\ldots \ell/t}
#' * \eqn{p} the harmonics periods
#' * \eqn{a_{n}} the amplitudes of the Fourier coefficients of \eqn{s}
#' of length \eqn{\ell}, whose values are \eqn{a_{0},a_{1},\ldots,c_{\ell-1}}
#' * \eqn{b_{n}} the phases of the Fourier coefficients of \eqn{s}
#' of length \eqn{\ell}, whose values are \eqn{a_{0},a_{1},\ldots,c_{\ell-1}}
#' * \eqn{P} array of powers, \eqn{P[n] = |c_{n}|} for \eqn{n=1,\ldots,\ell-1}
#'
#' @export
#'
#' @examples
#'
#' fft_tab(temperatures = hobo$t_hobo[1:(24 * 5)], time_window = 24 * 5)
#'
fft_tab <- function(temperatures, time_window, period = TRUE, power = TRUE) {
  coefs <- fft_rfft(temperatures)
  freqs <- fft_freq(length(temperatures), time_window)
  tibble(
    frequency = c(0, freqs),
    period = c(0, fft_period(freqs)),
    amplitude = fft_amplitude(coefs),
    phase = fft_phase(coefs),
    power = c(
      fft_mean(coefs),
      fft_power(coefs)
    )
  )
}

#' Fourier roll
#'
#' Fast Fourier Transform (FFT) of a series of temperatures in a table with a
#' rolling window across a time index with resulting frequencies, periods,
#' coefficients and powers per window in a single table.
#'
#' @param data df. The data frame with a column containing the time index and a
#'   column containing the temperature.
#' @param time_window int. Time window, \eqn{T=n\Delta t} where \eqn{\Delta t}
#'   is the sampling interval.
#' @param time_col char. The name of the column containing the time index.
#' @param temperature_col char. The name of the column containing the
#'   temperature series.
#' @param window time. Window size, can be expressed in time units see
#'   [runner::runner], default is 5 days
#' @param step time. Window step,  can be expressed in time units see
#'   [runner::runner], defaults is 3 days.
#' @param period bool. To include period or not, default TRUE.
#' @param power bool. To include power or not, default TRUE.
#'
#' @details
#'
#' Can be used with a grouped table, see vignette *to be linked*.
#'
#' @returns
#'
#' A table with:
#' * the datetime of the window
#' * \eqn{f} the harmonics frequencies \eqn{1/y,\ldots \ell/t}
#' * \eqn{p} the harmonics periods
#' * \eqn{a_{n}} the amplitudes of the Fourier coefficients of \eqn{s}
#' of length \eqn{\ell}, whose values are \eqn{a_{0},a_{1},\ldots,c_{\ell-1}}
#' * \eqn{b_{n}} the phases of the Fourier coefficients of \eqn{s}
#' of length \eqn{\ell}, whose values are \eqn{a_{0},a_{1},\ldots,c_{\ell-1}}
#' * \eqn{P} array of powers, \eqn{P[n] = |c_{n}|} for \eqn{n=1,\ldots,\ell-1}
#'
#' @export
#'
#' @examples
#'
#' fft_roll(
#'   data = hobo, time_window = 24 * 5,
#'   time_col = "datetime", temperature_col = "t_hobo"
#' )
#'
fft_roll <- function(
  data,
  time_window,
  time_col,
  temperature_col,
  window = "5 days",
  step = "3 days",
  period = TRUE,
  power = TRUE
) {
  .data <- NULL
  data |>
    arrange(.data[[time_col]]) |>
    reframe(
      fft = runner(
        x = pick(everything()),
        k = window,
        at = seq(min(as.data.frame(pick(everything()))[, time_col]),
          max(as.data.frame(pick(everything()))[, time_col]),
          by = step
        ),
        idx = time_col,
        f = function(x) {
          if (nrow(x) == time_window) {
            fft_tab(as.data.frame(x)[, temperature_col], time_window,
              period = period, power = power
            ) |>
              mutate({{ time_col }} := mean(as.data.frame(x)[, time_col]), #nolint
                .before = 1
              )
          }
        }
      )
    ) |>
    unnest(fft)
}

#' Fourier ratio
#'
#' Fast Fourier Transform (FFT) of two series of microclimatic and macroclimatic
#' temperatures in a table with a rolling window across a time index with
#' resulting frequencies, periods, micro and macro coefficients and micro and
#' macro powers, and the ratio of power between the micro and macroclimate per
#' window in a single table.
#'
#' @param data df. The data frame with a column containing the time index and a
#'   column containing the temperature.
#' @param time_window int. Time window, \eqn{T=N\Delta t} where \eqn{\Delta t}
#'   is the sampling interval.
#' @param time_col char. The name of the column containing the time index.
#' @param microclimate_col char. The name of the column containing the
#'   microclimate temperature series.
#' @param macroclimate_col char. The name of the column containing the
#'   macroclimate temperature series.
#' @param window time. Window size, can be expressed in time units see
#'   [runner::runner], default is 5 days
#' @param step time. Window step,  can be expressed in time units see
#'   [runner::runner], defaults is 3 days.
#' @param period bool. To include period or not, default TRUE.
#' @param power bool. To include power or not, default TRUE.
#'
#' @details
#'
#' Can be used with a grouped table, see [vignette](Examples.html).
#'
#' @returns
#'
#' A table with:
#' * the datetime of the window
#' * \eqn{f} the harmonics frequencies \eqn{1/y,\ldots \ell/t}
#' * \eqn{p} the harmonics periods
#' * \eqn{a_{n}} the amplitudes of the Fourier coefficients of \eqn{s}
#' of length \eqn{\ell}, whose values are \eqn{a_{0},a_{1},\ldots,c_{\ell-1}}
#' * \eqn{b_{n}} the phases of the Fourier coefficients of \eqn{s}
#' of length \eqn{\ell}, whose values are \eqn{a_{0},a_{1},\ldots,c_{\ell-1}}
#' * \eqn{P} array of powers, \eqn{P[n] = |c_{n}|} for \eqn{n=1,\ldots,\ell-1}
#' for micro and macroclimate.
#' * \eqn{R} array of ratios of micro vs. macro-climate powers
#'
#' @export
#'
#' @examples
#'
#' data <- era |>
#'   dplyr::rename(era = tas, datetime = time) |>
#'   dplyr::select(datetime, era) |>
#'   dplyr::left_join(
#'     dplyr::select(hobo, datetime, t_hobo) |>
#'       dplyr::rename(hobo = t_hobo),
#'     by = dplyr::join_by(datetime)
#'   )
#' fft_ratio(
#'   data = data, time_window = 24 * 5, time_col = "datetime",
#'   microclimate_col = "hobo", macroclimate_col = "era"
#' ) |>
#'   dplyr::filter(period == 24) |>
#'   dplyr::summarise_all(mean, na.rm = TRUE)
#'
fft_ratio <- function(
  data,
  time_window,
  time_col,
  microclimate_col,
  macroclimate_col,
  window = "5 days",
  step = "3 days",
  period = TRUE,
  power = TRUE
) {
  amplitude <- power_micro <- power_macro <- frequency <- NULL
  full_join(
    fft_roll(
      data = data,
      time_window = time_window,
      time_col = time_col,
      temperature_col = macroclimate_col,
      window = "5 days",
      step = "3 days",
      period = TRUE,
      power = TRUE
    ) |>
      rename_with(~ paste0(., "_macro"), .cols = amplitude:power),
    fft_roll(
      data = data,
      time_window = time_window,
      time_col = time_col,
      temperature_col = microclimate_col,
      window = "5 days",
      step = "3 days",
      period = TRUE,
      power = TRUE
    ) |>
      rename_with(~ paste0(., "_micro"), .cols = amplitude:power),
    by = join_by(frequency, period, {{ time_col }})
  ) |>
    mutate(ratio = power_micro / power_macro)
}
