terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
      version = "3.17.0"
    }
  }
}

provider "datadog" {
  # Configuration options
  api_key = "${var.dd_api_key}"
  app_key = "${var.dd_app_key}"
}