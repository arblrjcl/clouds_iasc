
locals {
  iam_admins_group_name = "admins"
}

module "iam_users_groups" {
  source                = "../../../tf_modules/aws/iam_users_groups/"
  project_name          = local.common_tags.PROJECT_NAME
  iam_group_names       = ["developers", local.iam_admins_group_name, "testers"]
  iam_admins_group_name = local.iam_admins_group_name
}



