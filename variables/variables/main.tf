resource "null_resource" "readcontentfile" {
  provisioner "local-exec" {
  command = "echo ${var.first} ${var.last}"
}
}
