# Terraform AWS tags to AWS AutoScaling Group (ASG) tags
Converts a [Terraform](https://www.terraform.io) map of `${length(n)}` into a list of [AWS AutoScaling Group tags](https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html) which will propogate at launch.

AWS ASGs have a different tagging structure which can cause pain when implementing a tagging policy; this module allows you to use the same map of tags on ASGs and other AWS resources.

## Usage
```HCL
module "aws_asg_tags" {
  source = "git@github.com:mavin/terraform-aws-tags-to-asg-tags.git"

  tags = "${map(
    "key1", "value1",
    "key2", "value2",
  )}"
}

...

resource "aws_autoscaling_group" "foo" {

  ...

  tags = "${module.aws_asg_tags.tags}"
}
```

Tested on Terraform v0.11.7 and `terraform-provider-null_v1.0.0`
