resource "kubernetes_namespace" "app_ns" { 
metadata { 
name = var.namespace 
 } 
} 
resource "helm_release" "nginx_ingress" { 
name       = "ingress-nginx"
namespace  = "ingress-nginx" 
create_namespace = true 
repository = "https://kubernetes.github.io/ingress-nginx" 
chart      = "ingress-nginx" 
version    = "4.7.0" 
} 
resource "kubernetes_deployment" "coffee_shop" { 
metadata { 
name      = "coffee-shop" 
namespace = var.namespace 
} 
spec { 
replicas = 1 
selector { 
match_labels = { 
app = "coffee-shop" 
 } 
} 
template { 
metadata { 
labels = { 
app = "coffee-shop" 
 } 
} 
spec { 
container { 
image = "registry.gitlab.com/o_sgoncalves/coffee-shop:latest"
name  = "coffee-shop" 
port { 
container_port = 8000 
     } 
    } 
   } 
  } 
 } 
} 
resource "kubernetes_service" "coffee_shop_svc" { 
metadata { 
name      = "coffee-shop" 
namespace = var.namespace 
} 
spec { 
selector = { 
app = "coffee-shop" 
} 
port 
{ port        = 80 
target_port = 8000 
} 
type = "ClusterIP" 
 } 
}
