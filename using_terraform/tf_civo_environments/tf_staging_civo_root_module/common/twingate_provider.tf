
provider "twingate" {
  api_token      = var.twingate_api_token
  network        = "ABCDE" # Use correct / required network name instead of ABCDE
  http_max_retry = 10      # Specifies a retry limit for the http requests made. The default value is 10
  http_timeout   = 35      # Specifies a time limit in seconds for the http requests made. The default value is 35 seconds.
}

