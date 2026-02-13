### 一、部署Apollo2.1.0 到 x86 环境的k8s集群中，使用达梦数据库。

**步骤 1：若镜像在 Harbor，创建拉取密钥**

已执行 `kubectl apply -f scripts/k8s/namespace.yaml` 之后执行（或先单独 apply 一次 namespace.yaml）：

```bash
kubectl create secret docker-registry harborlogin -n gw-middleware \
  --docker-server=你的harbor地址 \
  --docker-username=你的harbor账号 \
  --docker-password=你的harbor密码
```


**步骤 2：部署 Apollo（在含 `scripts/k8s/` 的目录的上一级执行）**

```bash
cd /path/to/apollo-2.1.0   # 或你解压后的目录，保证能访问 scripts/k8s/

kubectl apply -f scripts/k8s/namespace.yaml
kubectl apply -f scripts/k8s/apollo-dm-configmap.yaml
kubectl apply -f scripts/k8s/apollo-dm-secret.yaml

kubectl apply -f scripts/k8s/configservice-deployment.yaml
kubectl apply -f scripts/k8s/configservice-service.yaml
kubectl apply -f scripts/k8s/adminservice-deployment.yaml
kubectl apply -f scripts/k8s/adminservice-service.yaml
kubectl apply -f scripts/k8s/portal-deployment.yaml
kubectl apply -f scripts/k8s/portal-service.yaml
```

**步骤 3：验证与访问**

```bash
kubectl get pods -n gw-middleware   # 等 3 个 Pod 均为 Running
```

Portal 通过 NodePort **30001** 暴露。浏览器访问：**http:// IP:30001**，默认账号 **apollo / admin**。




---

## 一、前置条件

- 已安装 `kubectl` 并能访问目标 K8s 集群 
- 达梦库已就绪，且集群内 Pod 能访问达梦 
- 镜像已构建并推送到 Harbor 或当前集群可拉取
- 镜像清单（x86）：
- busybox:1.36
- harborURL/apollo-adminservice:2.1.0
- harborURL/apollo-configservice:2.1.0
- harborURL/apollo-portal:2.1.0

## 二、达梦数据库配置

### 2.1 非敏感信息：ConfigMap

文件：`apollo-dm-configmap.yaml`

| 键                      | 说明                                           | 示例                                              |
| ----------------------- | ---------------------------------------------- | ------------------------------------------------- |
| `CONFIG_DB_URL`         | ConfigService/AdminService 使用的达梦 JDBC URL | `jdbc:dm://DMDBIP:5236?SCHEMA=APOLLOCONFIGDB` |
| `PORTAL_DB_URL`         | Portal 使用的达梦 JDBC URL                     | `jdbc:dm://DMDBIP:5236?SCHEMA=APOLLOPORTALDB` |
| `APOLLO_PROFILE_CONFIG` | Config/Admin 的 profile                        | `github,dm`                                       |
| `APOLLO_PROFILE_PORTAL` | Portal 的 profile                              | `github,auth,dm`                                  |
| `DEV_META`              | Portal 使用的 meta 地址（ConfigService）       | `http://apollo-configservice:8080`                |


修改方式：

- 编辑 YAML 后重新 `kubectl apply -f apollo-dm-configmap.yaml`
- 或：`kubectl edit configmap apollo-dm-config -n gw-middleware`

### 2.2 敏感信息：Secret

文件：`apollo-dm-secret.yaml`

| 键            | 说明       |
| ------------- | ---------- |
| `DB_USERNAME` | 达梦用户名 |
| `DB_PASSWORD` | 达梦密码   |

**建议**：生产环境不要将密码写在 YAML 中，可先删除 `apollo-dm-secret.yaml` 中的 `stringData`，再单独创建 Secret：

```bash
kubectl create secret generic apollo-dm-secret -n gw-middleware \
  --from-literal=DB_USERNAME=SYSDBA \
  --from-literal=DB_PASSWORD=你的密码
```

更新密码：

```bash
kubectl delete secret apollo-dm-secret -n gw-middleware
kubectl create secret generic apollo-dm-secret -n gw-middleware \
  --from-literal=DB_USERNAME=SYSDBA \
  --from-literal=DB_PASSWORD=新密码
# 若未使用 RollingUpdate，可重启 Pod 使新密码生效
kubectl rollout restart deployment -n gw-middleware -l app.kubernetes.io/name=apollo
```




