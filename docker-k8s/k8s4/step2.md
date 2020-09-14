## MySQL Tips

MySQL는 Docker Hub 에서 검색하여 공식 이미지를 사용합니다.

https://hub.docker.com/_/mysql

WordPress에서는 MySQL 5.6 버전 이상이면 지원이 된다고 하니, 아직까지는 가장 많이 사용되는 5.7 버전을 선택합니다. (다른 버전을 선택해도 상관없습니다.)

Docker Hub MySQL 설명에도 나와 있지만, Container로 구동 시키기 위해 반드시 필요한 환경 변수들이 있습니다.

다음 4개의 항목을 환경변수로 설정하여 주면 됩니다.

MYSQL_ROOT_PASSWORD (root 계정의 패스워드), MYSQL_DATABASE (처음 생성되는 Database명), MYSQL_USER (처음 생성되는 사용자 계정), MYSQL_PASSWORD (처음 생성되는 사용자 계정에 대한 패스워드)

ConfigMaps 에 MYSQL_DATABASE와 MYSQL_USER 정보를 저장하고, Secret에는 MYSQL_ROOT_PASSWORD와 MYSQL_PASSWORD 정보를 저장하여 Deployment 명세 작성시 환경변수 Value로 넘겨 줍니다.

## ConfigMap 및 Secret 생성

ConfigMap

kubectl create configmap configmap이름 --from-literal=key1=value1 --from-literal=key2=value2

Secret

kubectl create secret generic secret이름 --from-literal=key1=value1 --from-literal=key2=value2

## Yaml 작성

1. MySQL Deployment

`mysql-deployment.yaml`{{open}}

2. MySQL Service

`mysql-service.yaml`{{open}}

configmap과 secret를 환경변수로 사용하는 방법은 이전 K8S 실습 3번에 포함 되어 있습니다.
Deployment와 Service Yaml을 작성하는 방법은 K8S 실습 1번에 포함 되어 있습니다.
