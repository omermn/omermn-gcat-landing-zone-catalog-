##############################################################################
# Account Variables
# Copyright 2020 IBM
##############################################################################

# Comment this variable if running in schematics
variable ibmcloud_api_key {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
  type        = string
  sensitive   = true
}

# Comment out if not running in schematics
variable TF_VERSION {
 default     = "1.0"
 type        = string
 description = "The version of the Terraform engine that's used in the Schematics workspace."
}

variable prefix {
    description = "A unique identifier need to provision resources. Must begin with a letter"
    type        = string
    default     = "gcat-multizone"

    validation  {
      error_message = "Unique ID must begin and end with a letter and contain only letters, numbers, and - characters."
      condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.prefix))
    }
}

variable region {
  description = "Region where resources will be created"
  type        = string
  default     = "us-south"
}

##############################################################################


##############################################################################
# Secrets Manager Variables
##############################################################################

variable cos_resource_group {
  description = "Name of the resource group where the secrets mananger instance is provisione"
  type        = string
}

variable cos_instance {
  description = "Name of the COS Instnance where the VPC data is stored"
  type        = string
}

variable cos_bucket {
  description = "Name of the bucket where the VPC data is stored"
  type        = string
}

variable object_name {
  description = "Name of the object where the VPC data is stored"
  type        = string
}

##############################################################################


##############################################################################
# VPC Variables
##############################################################################

variable resource_group {
    description = "Name of resource group where all infrastructure will be provisioned"
    type        = string
    default     = "gcat-landing-zone-dev"

    validation  {
      error_message = "Unique ID must begin and end with a letter and contain only letters, numbers, and - characters."
      condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.resource_group))
    }
}


variable classic_access {
  description = "Enable VPC Classic Access. Note: only one VPC per region can have classic access"
  type        = bool
  default     = false
}

##############################################################################