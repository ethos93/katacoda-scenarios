Host 에서 Layer를 조회하여 보면 4개의 Layer가 조회되는 것을 확인할 수 있습니다.

## overlay 이미지 확인
/var/lib/docker/overlay 경로에 이미지가 조회됩니다.

`ls -1 -t /var/lib/docker/overlay`{{execute}}

## Docker Container 실행
`docker run -it --name myubuntu ubuntu /bin/bash`{{execute}}

ubuntu 이미지를 미리 pull 했기 때문에 바로 Run 되지만, 만약 실행하고자 하는 Docker 이미지가 로컬 환경에 없다면, 자동으로 ubuntu 이미지를 다운받은 뒤에 Run 됩니다.

Docker Container 환경으로 접속되었으며, os-release 정보를 통해 현재 접속되어 있는 Container의 os를 확인할 수 있습니다.

`cat /etc/os-release`{{execute}}

Terminal 1 Tab에서 overlay 이미지를 다시 확인해 봅니다.

`ls -1 -t /var/lib/docker/overlay`{{execute}}

docker run 이전에는 4개의 layer가 있었으나, docker run 이 된 후에는 layer가 하나 추가 된 것을 확인할 수 있습니다.

기존 4개의 layer는 Read Only Layer이며, Continer가 실행되면 이미지가 변경될 Layer가 생성되며 해당 Layer는 Read Write가 모두 가능합니다.

## Docker Container로 부터 이미지를 생성
Docker Container에 접속되어 있는 Terminal Tab에서 아래 명령으로 파일을 생성합니다.

`echo "hello ubuntu" > hello.txt`{{execute}}

다시 Terminal 1 Tab으로 이동하여, Commit 명령을 통해 hello.txt 파일이 포함된 새로운 이미지를 생성합니다.

`docker commit -a sds -m "add hello.txt" myubuntu myununtu:1.0`{{execute}}

Terminal 1 Tab에서 overlay 이미지를 다시 확인해 봅니다.

`ls -1 -t /var/lib/docker/overlay`{{execute}}

또 다른 layer가 추가된 것을 확인할 수 있으며, commit에 의해 Read Only Layer가 추가된 것입니다.

이제 실행중인 컨테이너를 삭제합니다.

`docker rm -f myubuntu`{{execute}}

다시한번 overlay 이미지를 확인해 보면 `ls -1 -t /var/lib/docker/overlay`{{execute}} Container가 실행되면서 생성되었던 Read Write Layer는 삭제되고 Read Only Layer만 5개가 남은 것을 확인할 수 있습니다.

마지막으로, 신규로 생성한 이미지도 확인해 봅니다.

`docker images`{{execute}}


