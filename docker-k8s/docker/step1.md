우선, ubuntu 최신 이미지를 Repository로 부터 pull 하여 local에 저장해 보겠습니다.

## docker 프로세스와 이미지를 확인해 봅니다.
docker 프로세스 확인은 다음과 같이 할 수 있습니다.

`docker ps -a`{{execute}}

docker image 확인은 다음과 같이 할 수 있습니다.

`docker images`{{execute}}

## 실습전에 모든 docker process와 이미지를 삭제합니다.
`docker rm -f $(docker ps -aq)`{{execute}}

`docker rmi -f $(docker images -aq)`{{execute}}

## 다시 한번 docker 이미지가 있는지 확인합니다.
`docker images`{{execute}}

## Ubuntu 이미지 pull

다음 명령을 통해 ubuntu 이미지를 pull 할 수 있습니다.

`docker pull ubuntu`{{execute}}

이미지는 하나의 파일로 다운로드 되는 것이 아니라, 여러 layer가 순차적으로 다운로드 됩니다.

## ubuntu 이미지가 정상적으로 pull 되었는지 확인합니다.
`docker images`{{execute}}
