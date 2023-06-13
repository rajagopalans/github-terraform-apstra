# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    apstra = {
      source = "Juniper/apstra"
      url = "https://13.37.222.29:21809/"
    }
  }
}

provider "apstra" {
  tls_validation_disabled = true
  blueprint_mutex_disabled = true
}

data "apstra_property_sets" "all" {}

# Loop over Property Set IDs, creating an instance of `apstra_property_set` for each.
data "apstra_property_set" "each_ps" {
  for_each = toset(data.apstra_property_sets.all.ids)
  id = each.value
}

# Output the property set report
output "apstra_property_set_report" {
  value = {for k, v in data.apstra_property_set.each_ps : k => {
    name = v.name
    data = jsondecode(v.data)
    blueprints = v.blueprints
  }}
}
