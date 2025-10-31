test_that("fft", {
  f <- fft_rfft(hobo$t_hobo[1:(24 * 5)])
  freq <- fft_freq(24 * 5, 24 * 5)
  temp <- fft_reconstruct(f, freq, 1:(24 * 5))
  expect_equal(temp[1], 19.8443750)
  expect_equal(fft_mean(f), 17.6199250)
  expect_equal(fft_period(freq)[1], 120)
  expect_equal(fft_powers(f)[1], 1.16716029)
  expect_equal(fft_energy(f), 317.647568)
  expect_equal(fft_variance(f), 9286.57923)
  expect_equal(fft_delay(f, freq)[1], 24.14719469)
  expect_s3_class(fft_tab(hobo$t_hobo[1:(24 * 5)], 24 * 5), "data.frame")
  expect_s3_class(fft_roll(hobo, 24 * 5, "datetime", "t_hobo"), "data.frame")
  expect_s3_class(fft_roll(hobo, 24 * 5, "datetime", "t_hobo"), "data.frame")
  data <- era %>%
    dplyr::rename(era = tas, datetime = time) %>%
    dplyr::select(datetime, era) %>%
    dplyr::left_join(dplyr::select(hobo, datetime, t_hobo) %>%
                       dplyr::rename(hobo = t_hobo))
  expect_s3_class(fft_ratio(data, 24 * 5, "datetime", "hobo", "era"),
                  "data.frame")
})
