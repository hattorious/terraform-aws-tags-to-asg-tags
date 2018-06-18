variable "tags" {
  type    = "map"
  default = {}
}

module "count" {
  source = "./count"
  map    = "${var.tags}"
}

data "null_data_source" "tag" {
  count = "${module.count.count}"

  inputs = {
    key                 = "${element(keys(var.tags), count.index)}"
    value               = "${element(values(var.tags), count.index)}"
    propagate_at_launch = "true"
  }
}

output "tags" {
  value = "${data.null_data_source.tag.*.outputs}"
}
