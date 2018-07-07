// I'm abusing a few Terraform constructs here
variable "tags" {
  type    = "map"
  default = {}
}

module "count" {
  source = "./count"
  map    = "${var.tags}"
}

data "null_data_source" "tag" {
  // In some cases, wrapping a count interpolation in a module pushes the
  // interpolation forward in the graph so that Terraform calculates it earlier
  // in the plan. This doesn't always work and will not work with if the
  // interpolation has a dependency on managed resources.
  // https://github.com/hashicorp/terraform/issues/12570#issuecomment-318414280
  count = "${module.count.count}"

  // null_data_source exports the `inputs` and `outputs` attributes as the declared
  // map so we can use it to create a map of known keys to interpolated values.
  inputs = {
    // the keys() and values() interpolations return lists in the same order
    key                 = "${element(keys(var.tags), count.index)}"
    value               = "${element(values(var.tags), count.index)}"
    propagate_at_launch = "true"
  }
}

output "tags" {
  // splat collects up the attributes in a list
  value = "${data.null_data_source.tag.*.outputs}"
}
