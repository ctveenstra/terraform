# --------- Get the OCID for the more recent for Oracle Linux 7.4 disk image
data "oci_core_images" "OLImageOCID-ol7" {
  compartment_id = "${var.compartment_ocid}"
  operating_system = "Oracle Linux"
  operating_system_version = "${var.os-version}"

  filter {
    name   = "display_name"
    values = ["^.*${var.os-version}-[^G].*$"]
    regex  = true
  }
}

# ------ Create a compute instance from the more recent Oracle Linux 7.4 image
resource "oci_core_instance" "tf-demo01-ol7" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "${var.dbserver_hostname}"
  hostname_label = "${var.dbserver_hostname}"
  image = "${lookup(data.oci_core_images.OLImageOCID-ol7.images[1], "id")}"
  shape = "VM.Standard1.2"
  subnet_id = "${oci_core_subnet.tf-demo01-public-subnet1.id}"
  metadata {
    ssh_authorized_keys = "${file(var.ssh_public_key_file_ol7)}"
    user_data = "${base64encode(file(var.BootStrapFile_dbserver))}"
  }
  timeouts {
    create = "30m"
  }

#        provisioner "file" {
#                connection {
#                        agent = false
#                        timeout = "10m"
#                        #host = "${oci_core_instance.tf-demo01-ol7.public_ip}"
#                        user = "opc"
#                        private_key = "${file("/home/opc/.ssh/id_rsa")}"
#                }
#        source = "/home/opc/terraform-provider-oci/terraform-provider-oci/docs/examples/storage/nfs/userdata/iscsiattach.sh"
#        destination = "/home/opc/iscsiattach.sh"
#    }


  
}

# ------ Display the public IP of instance
output " Public IP of instance " {
  value = ["${oci_core_instance.tf-demo01-ol7.public_ip}"]
}
