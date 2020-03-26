resource "oci_core_instance" "test_instance" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "TestInstanceForInstancePool"
  shape               = var.instance_shape

  create_vnic_details {
    subnet_id        = oci_core_subnet.test_subnet.id
    display_name     = "PrimaryVnic"
    assign_public_ip = true
    hostname_label   = "testinstanceforinstancepool"
  }

  source_details {
    source_type = "image"
    source_id   = var.instance_image_ocid[var.region]
  }

  timeouts {
    create = "60m"
  }
}

resource "oci_core_image" "custom_image" {
  compartment_id = var.compartment_ocid
  instance_id    = oci_core_instance.test_instance.id
  launch_mode    = "NATIVE"

  timeouts {
    create = "30m"
  }
}

resource "oci_core_instance_configuration" "test_instance_configuration" {
  compartment_id = var.compartment_ocid
  display_name   = "TestInstanceConfiguration"

  instance_details {
    instance_type = "compute"

    launch_details {
      compartment_id = var.compartment_ocid
      ipxe_script    = "ipxeScript"
      shape          = var.instance_shape
      display_name   = "TestInstanceConfigurationLaunchDetails"

      create_vnic_details {
        assign_public_ip       = true
        display_name           = "TestInstanceConfigurationVNIC"
        skip_source_dest_check = false
      }

      extended_metadata = {
        some_string   = "stringA"
        nested_object = "{\"some_string\": \"stringB\", \"object\": {\"some_string\": \"stringC\"}}"
      }

      source_details {
        source_type = "image"
        image_id    = oci_core_image.custom_image.id
      }
    }
  }
}
