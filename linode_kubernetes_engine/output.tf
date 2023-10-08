resource "local_file" "kubeconfig" {
    depends_on = [ linode_lke_cluster.personal_cluster ]
    filename = "config"
    content = base64decode(linode_lke_cluster.personal_cluster.kubeconfig)  
}
