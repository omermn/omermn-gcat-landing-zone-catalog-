##############################################################################
# Access Groups
##############################################################################

output access_groups {
    description = "Access group information"
    value       = module.landing_zone.access_groups
}

##############################################################################


##############################################################################
# VPC
##############################################################################

output vpc_id {
  description = "ID of VPC created"
  value       = module.landing_zone.vpc_id
}

output acl_id {
  description = "ID of ACL created for subnets"
  value       = module.landing_zone.acl_id
}

output public_gateways {
  description = "Public gateways created"
  value       = module.landing_zone.public_gateways
}

##############################################################################

##############################################################################
# Subnet Outputs
##############################################################################

output subnet_ids {
  description = "The IDs of the subnets"
  value       = module.landing_zone.subnet_ids
}

output subnet_detail_list {
  description = "A list of subnets containing names, CIDR blocks, and zones."
  value       = module.landing_zone.subnet_detail_list
}

output subnet_zone_list {
  description = "A list containing subnet IDs and subnet zones"
  value       = module.landing_zone.subnet_zone_list
}

##############################################################################