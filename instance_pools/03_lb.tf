resource "oci_load_balancer" "test_load_balancer" {
  shape          = "100Mbps"
  compartment_id = var.compartment_ocid

  subnet_ids = [
    oci_core_subnet.test_subnet.id,
  ]

  display_name = "TestLoadBalancer"
  is_private   = true
}

resource "oci_load_balancer_backend_set" "test_backend_set" {
  name             = "lb-bes1"
  load_balancer_id = oci_load_balancer.test_load_balancer.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = "80"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
  }
}

