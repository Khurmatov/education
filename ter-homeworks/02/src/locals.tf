locals {
  lplatform    = "netology-develop-platform"
  lweb         = "web"
  ldb          = "db"
  vm_web_lname = "${ local.lplatform }-${ local.lweb }"
  vm_db_lname  = "${ local.lplatform }-${ local.ldb }"
}