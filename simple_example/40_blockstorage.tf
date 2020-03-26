# ------ Create a 500GB block volume
resource "oci_core_volume" "tf-demo01-ol7-vol1" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "tf-demo01-ol7-vol1"
  size_in_gbs = "250"
}

# ------ Attach the new block volume to the ol7 compute instance after it is created
resource "oci_core_volume_attachment" "tf-demo01-ol7-vol1-attach" {
  attachment_type = "iscsi"
  compartment_id = "${var.compartment_ocid}"
  instance_id = "${oci_core_instance.tf-demo01-ol7.id}"
  volume_id = "${oci_core_volume.tf-demo01-ol7-vol1.id}"

}
