module "datadog" {
  source                      = "toluna-terraform/datadog-integration/aws"
  dd_api_key                  = "WVOuMv1Bahntpr8No4H34P2GdxPIpAum"
  dd_app_key                  = "fp4E7qcjJ2mQHWZVqXn94o3y88YA6abb"
  metrics_collection_enabled  = "false"
  resource_collection_enabled = "false"
}