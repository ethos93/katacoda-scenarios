## WordPress Tips

WordPress는 Docker Hub 에서 검색하여 공식 이미지를 사용합니다.

https://hub.docker.com/_/wordpress

WordPress는 최신 버전을 사용합니다. (잘 모르겠다면, 아무거나 선택해도 상관없습니다.)

Docker Hub WordPress 설명에도 나와 있지만, Container로 구동 시키기 위해 반드시 필요한 환경 변수들이 있습니다.

WORDPRESS_DB_HOST (MySQL DB에 접근하기 위한 Host명, 여기서는 MySQL 서비스 이름), WORDPRESS_DB_USER (MySQL 구성 시 생성한 사용자 계정), WORDPRESS_DB_PASSWORD (MySQL 구성 시 생성한 사용자 계정에 대한 패스워드), WORDPRESS_DB_NAME (MySQL 구성 시 생성한 DB 이름)

WORDPRESS_DB_HOST는 Value에 서비스 명을 직접 적어주고, 나머지는 MySQL 구성시 사용한 ConfigMaps과 Secret을 그대로 사용하여 Deployment 명세 작성시 환경변수 Value로 넘겨 줍니다.


## Yaml 작성

1. WordPress Deployment

`wordpress-deployment.yaml`{{open}}

2. WordPress Service

`wordpress-service.yaml`{{open}}
