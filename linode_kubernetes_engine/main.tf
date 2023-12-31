terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "2.8.0"
    }
  }
}

provider "linode" {
    token = var.linode_token
  
}

resource "linode_lke_cluster" "personal_cluster" {
    label       = "personal_cluster"
    k8s_version = "1.27"
    region      = "eu-west"
    tags        = ["personal"]

    pool {
        type  = "g6-standard-1"
        count = 2
    }
}

resource "null_resource" "copy_files" {
  triggers = {
    always_run = "${timestamp()}"
    }

  provisioner "local-exec" {
    command = "cp ${var.source_path} ${var.destination_path}"
  }
  depends_on = [ linode_lke_cluster.personal_cluster ]
}

