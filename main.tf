##############################################################################
# Parent Account IBM Cloud Provider
##############################################################################

provider ibm {
  # ibmcloud_api_key      = var.ibmcloud_api_key
  region                = var.region
  ibmcloud_timeout      = 60
}

##############################################################################


##############################################################################
# Get Secrets Manager Data
##############################################################################

data ibm_resource_group cos_resource_group {
  name     = var.cos_resource_group
}

data ibm_resource_instance cos_instance {
  name              = var.cos_instance
  resource_group_id = data.ibm_resource_group.cos_resource_group.id
  service           = "cloud-object-storage"
}

data ibm_cos_bucket cos_bucket {
  resource_instance_id = data.ibm_resource_instance.cos_instance.id
  bucket_name          = var.cos_bucket
  bucket_type          = "region_location"
  bucket_region        = var.region
}

data ibm_cos_bucket_object cos_object {
  bucket_crn      = data.ibm_cos_bucket.cos_bucket.crn
  bucket_location = data.ibm_cos_bucket.cos_bucket.bucket_region
  key             = var.object_name
}

##############################################################################


##############################################################################
# Create Landing Zone
##############################################################################

locals {
  cos_object_body = jsondecode(data.ibm_cos_bucket_object.cos_object.body)
}

module landing_zone {
  source               = "./landing_zone"
  prefix               = var.prefix
  region               = var.region
  resource_group       = var.resource_group
  classic_access       = var.classic_access
  access_groups        = local.cos_object_body.access_groups
  subnets              = local.cos_object_body.subnets
  use_public_gateways  = local.cos_object_body.use_public_gateways
  acl_rules            = local.cos_object_body.acl_rules
  security_group_rules = local.cos_object_body.security_group_rules
}

##############################################################################