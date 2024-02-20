terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
      version = "3.36.1"
    }
  }
}

provider "datadog" {
  # Configuration options
  api_key = "${locals.dd_api_key}" 
  app_key = "${locals.dd_app_key}"
}