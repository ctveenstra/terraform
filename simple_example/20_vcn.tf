#--------getthelistofavailableADs
data"oci_identity_availability_domains""ADs"{
  compartment_id="${var.tenancy_ocid}"
}

#------CreateanewVCN
variable"VCN-CIDR"{default="10.0.0.0/16"}

resource"oci_core_virtual_network""tf-demo01-vcn"{
  cidr_block="${var.VCN-CIDR}"
  compartment_id="${var.compartment_ocid}"
# display_name="tf-CV-demo01-vcn"
  display_name="CV_ORCL_VCN"
  dns_label="tfdemovcn"
}

#------CreateanewInternetGateway
resource"oci_core_internet_gateway""tf-demo01-ig"{
  compartment_id="${var.compartment_ocid}"
  display_name="tf-demo01-internet-gateway"
  vcn_id="${oci_core_virtual_network.tf-demo01-vcn.id}"
}

#------CreateanewRouteTable
resource"oci_core_route_table""tf-demo01-rt"{
  compartment_id="${var.compartment_ocid}"
  vcn_id="${oci_core_virtual_network.tf-demo01-vcn.id}"
  display_name="tf-demo01-route-table"
  route_rules{
    cidr_block="0.0.0.0/0"
    network_entity_id="${oci_core_internet_gateway.tf-demo01-ig.id}"
  }
}

#------Createanewsecuritylisttobeusedinthenewsubnet
resource"oci_core_security_list""tf-demo01-subnet1-sl"{
  compartment_id="${var.compartment_ocid}"
  display_name="tf-demo01-subnet1-security-list"
  vcn_id="${oci_core_virtual_network.tf-demo01-vcn.id}"
  egress_security_rules=[{
    protocol="all"
    destination="0.0.0.0/0"
  }]
  ingress_security_rules=[{
    protocol="6"#tcp
    source="${var.VCN-CIDR}"
  },
  {
    protocol="6"#tcp
    source="0.0.0.0/0"
    source="${var.authorized_ips}"
    tcp_options{
    "min"=22
    "max"=22
    }
  }]
}

#------Createapublicsubnet1inAD1inthenewVCN
resource"oci_core_subnet""tf-demo01-public-subnet1"{
  availability_domain="${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  cidr_block="10.0.1.0/24"
  display_name="tf-demo01-public-subnet1"
  dns_label="subnet1"
  compartment_id="${var.compartment_ocid}"
  vcn_id="${oci_core_virtual_network.tf-demo01-vcn.id}"
  route_table_id="${oci_core_route_table.tf-demo01-rt.id}"
  security_list_ids=["${oci_core_security_list.tf-demo01-subnet1-sl.id}"]
  dhcp_options_id="${oci_core_virtual_network.tf-demo01-vcn.default_dhcp_options_id}"
}

