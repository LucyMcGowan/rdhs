skip_if_no_auth <- function(config_path = "rdhs.json") {

  testthat::skip_on_cran()

  have_cred_path <- file.exists(config_path)
  if (!have_cred_path) {
    skip("No authentication available")
  }

  skip_if_slow_API()

}

skip_if_slow_API <- function() {

  if (suppressMessages(last_api_update()) == 0.5) {
    skip("API is down")
  }

}


api_timeout_safe_test <- function(expr) {

  # one that has to paginate
  d <- tryCatch(eval(substitute(expr)), error = function(e) NULL )

  if (is.null(d)) {
    testthat::skip(paste0("Skipping test as API is too ",
                          "slow to return these objects."))
  }

  return(d)

}


new_rand_client <- function() {

  # Create new directory
  td <- file.path(tempdir(), as.integer(Sys.time()))

  # create auth through whichever route is valid for the environment

    cli <- rdhs::client_dhs(
      api_key = "ICLSPH-527168",
      config = read_rdhs_config_file("rdhs.json"),
      root = td
    )

  return(cli)
}
