locals {
  project  = "netology"
  env      = "develop"
  platform = "platform"

  vm_web_name = "${local.project}-${local.env}-${local.platform}-web"
  vm_db_name  = "${local.project}-${local.env}-${local.platform}-db"
}
