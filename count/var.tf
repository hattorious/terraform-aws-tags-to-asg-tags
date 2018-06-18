variable "map" {
  type    = "map"
  default = {}
}

output "count" {
  value = "${length(var.map)}"
}
