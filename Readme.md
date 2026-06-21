# Caso Práctico 2 — Despliegue en Azure con Terraform, Ansible, Podman y Kubernetes

## 1. Despliegue paso a paso

### 1.1 Desplegar la infraestructura y la aplicaciones (Terraform y Ansible)

```bash
ansible/deploy.sh
```

## 2. Verificación del servicio en la VM (Podman + Nginx)

### Comprobar que el servicio systemd está activo
```bash
ssh -i ~/.ssh/id_rsa azureuser@<IP_VM>
sudo systemctl status nginx-podman
```

### Comprobar que el contenedor está corriendo
```bash
sudo podman ps
```

### Comprobar acceso HTTPS con autenticación básica
```bash
curl -k -u admin:admin https://<IP_VM>
```
(`-k` ignora la advertencia de certificado autofirmado)

### Gestionar el servicio manualmente
```bash
sudo systemctl stop nginx-podman
sudo systemctl start nginx-podman
sudo systemctl restart nginx-podman
```

---

## 3. Verificación del servicio en Kubernetes (AKS + Apache)

### Configurar el acceso al cluster
```bash
export KUBECONFIG=$(pwd)/ansible/kubeconfig
kubectl get nodes
```

### Comprobar los recursos desplegados
```bash
kubectl get deployments
kubectl get pods
kubectl get pvc
kubectl get service apache-service
```

### Obtener la IP pública de acceso
```bash
kubectl get service apache-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

### Acceder a la aplicación
```bash
curl http://<IP_APACHE>
```

### Comprobar que el almacenamiento es persistente

```bash
# 1. Anota el contenido actual (incluye hostname y fecha de creación)
curl http://<IP_APACHE>

# 2. Identifica el pod actual
kubectl get pods

# 3. Bórralo (el Deployment lo recreará automáticamente)
kubectl delete pod <nombre_del_pod>

# 4. Espera unos segundos y comprueba el nuevo pod
kubectl get pods

# 5. Vuelve a consultar la web
curl http://<IP_APACHE>
```

**Resultado esperado:** la fecha de creación del contenido se mantiene igual, pero el hostname mostrado cambia — esto demuestra que los datos persisten en el volumen (PVC) aunque el pod se destruya y se recree.

---

## 6. Destruir todo el entorno

```bash
cd terraform
terraform destroy -auto-approve
```

> Nota: el recurso **Network Watcher** que Azure crea automáticamente en algunas regiones no es gestionado por Terraform y puede requerir borrado manual:
> ```bash
> az group delete --name NetworkWatcherRG --yes
> ```

---

## 6. Requisitos del entorno

Generados automáticamente con `generate-requirements.sh`:
- `requirements.txt` — dependencias Python (`kubernetes`, `ansible-core`)
- `requirements.yml` — colecciones de Ansible (`containers.podman`, `kubernetes.core`)
- `VERSIONS.md` — versiones de Terraform, Podman, kubectl, Python y Azure CLI

Instalación:
```bash
pip install -r requirements.txt --break-system-packages
ansible-galaxy collection install -r requirements.yml
```