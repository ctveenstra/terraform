resource "oci_core_instance_pool" "test_instance_pool" {
  compartment_id            = var.compartment_ocid
  instance_configuration_id = oci_core_instance_configuration.test_instance_configuration.id
  size                      = 2
  state                     = "RUNNING"
  display_name              = "TestInstancePool"

  placement_configurations {
    availability_domain = data.oci_identity_availability_domain.ad.name
    fault_domains       = ["FAULT-DOMAIN-1"]
    primary_subnet_id   = oci_core_subnet.test_subnet.id
  }

  load_balancers {
    backend_set_name = oci_load_balancer_backend_set.test_backend_set.name
    load_balancer_id = oci_load_balancer.test_load_balancer.id
    port             = 80
    vnic_selection   = "primaryvnic"
  }
}

data "oci_core_instance_configuration" test_instance_configuration_datasource {
  instance_configuration_id = oci_core_instance_configuration.test_instance_configuration.id
}

data "oci_core_instance_configurations" test_instance_configurations_datasource {
  compartment_id = var.compartment_ocid

  filter {
    name   = "id"
    values = [oci_core_instance_configuration.test_instance_configuration.id]
  }
}

data "oci_core_instance_pool" "test_instance_pool_datasource" {
  instance_pool_id = oci_core_instance_pool.test_instance_pool.id
}

data "oci_core_instance_pools" "test_instance_pools_datasource" {
  compartment_id = var.compartment_ocid
  display_name   = "TestInstancePool"
  state          = "RUNNING"

  filter {
    name   = "id"
    values = [oci_core_instance_pool.test_instance_pool.id]
  }
}

data "oci_core_instance_pool_instances" "test_instance_pool_instances_datasource" {
  compartment_id   = var.compartment_ocid
  instance_pool_id = oci_core_instance_pool.test_instance_pool.id
  display_name     = "TestInstancePool"
}

data "oci_core_instance_pool_load_balancer_attachment" test_instance_pool_load_balancer_attachment {
  instance_pool_id                          = oci_core_instance_pool.test_instance_pool.id
  instance_pool_load_balancer_attachment_id = oci_core_instance_pool.test_instance_pool.load_balancers.0.id
}

output "load_balancer_backend_set_name" {
  value = ["data.oci_core_instance_pool_load_balancer_attachment.test_instance_pool_load_balancer_attachment.backend_set_name"]
}


/* 
# Usage of singular instance datasources to show the public_ips, private_ips, and hostname_labels for the instances in the pool
data "oci_core_instance" "test_instance_pool_instance_singular_datasource" {
  count = 2
  #  instance_id = "lookup(data.oci_core_instance_pool_instances.test_instance_pool_instances_datasource.instances[count.index], "id")"
  instance_id = "lookup(data.oci_core_instance_pool_instances.test_instance_pool_instances_datasource.instances[count.index], id)"
}

output "pooled_instances_private_ips" {
  value = [data.oci_core_instance.test_instance_pool_instance_singular_datasource.*.private_ip]
}

output "pooled_instances_public_ips" {
  value = [data.oci_core_instance.test_instance_pool_instance_singular_datasource.*.public_ip]
}

output "pooled_instances_hostname_labels" {
  value = [data.oci_core_instance.test_instance_pool_instance_singular_datasource.*.hostname_label]
}
*/
