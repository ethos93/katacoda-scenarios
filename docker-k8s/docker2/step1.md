Docker Command 에 대한 실습을 진행합니다.

본 시나리오에서는 Jenkins (CI/CD 툴)을 Docker로 구동 시키고, 관리하는 부분을 다루도록 하겠습니다.

## Docker Pull
docker pull 은 이미 앞서 사용했던 Command 입니다. 그리고, 반드시 pull을 하지 않더라도 pull 이 필요하면 자동으로 pull을 수행합니다.

Jenkins Docker Image를 pull 받아야 하니, 다음과 같이 command를 사용합니다.

`docker pull jenkins:alpine`{{execute}}

조금 더 작은 사이즈의 이미지를 pull 하기 위해 alpine tag 가 붙은 이미지를 pull 받았습니다.

다음 command를 통해 local에 받아진 image를 확인해 봅니다.

`docker images`{{execute}}

좀 더 상세한 이미지 정보를 확인하기 위해서는 inspect 명령을 사용할 수 있습니다.

`docker inspect jenkins:alpine`{{execute}}

## Docker Run
이미지로 부터 Container를 생성하여 Process를 구동시키는 명령은 run 입니다.

한번 run을 통해 구동시켜 보겠습니다. --name 옵션은 docker conatiner의 이름을 지정하는 옵션입니다.

`docker run --name myjenkins jenkins:alpine`{{execute}}

Jenkins 구동 로그가 보여지면서 Process 가 실행되는 것을 확인할 수 있습니다.

Jenkins를 사용해 보신 분들은 아시겠지만, Jenkins는 Web UI로 구동되는 툴입니다. 그런데, Container 에서 구동되다 보니, Web UI를 통해 접속할 수 있는 방법이 필요합니다.

그리고, foreground 로 Docker process가 구동되다보니, 터미널을 종료하면 process도 함께 종료됩니다.

우선 구동 중인 process 를 종료하기 위해 Ctrl+C 를 통해 process 를 종료시킵니다.

Container에 대한 확인은 ps 이며, 특히 종료된 conatiner를 포함한 확인은 -a 옵션을 추가하면 됩니다.

`docker ps -a`{{execute}}

종료된 Container를 삭제하는 Command는 rm 입니다.

`docker rm myjenkins`{{execute}}

앞서 생성했던 myjenkins container를 Daemon 모드로 구동시키면서 Web UI 접속이 가능하도록 옵션을 추가하겠습니다.

그리고, jenkins Job을 영구적으로 저장할 수 있도록 volume 도 생성하여 추가하도록 하겠습니다.

volume을 생성하는 command는 다음과 같습니다.

`docker volume create myvolume`{{execute}}

volume 이 잘 생성되었는지에 대한 확인은 volume ls를 하면 됩니다.

`docker volume ls`{{execute}}

이제 jenkins를 다시 구동시켜 보도록 하겠습니다.

`docker run --name myjenkins -d -p 8080:8080 -v myvolume:/var/jenkins_home -e JAVA_OPTS=-Dhudson.footerURL=http://www.samsungsds.com jenkins:alpine`{{execute}}

명령이 많이 길어졌습니다.

-d 옵션은 daemon 모드 (Background)로 구동시키도록 하는 옵션입니다.

-p 옵션은 port-forward 옵션이며, hostport:containerport 로 사용합니다.

-v 옵션은 volume을 mount하는 옵션으로 미리 만들어 둔 myvolume을 conatiner 내부의 /var/jenkins_home 에 mount 합니다.

-e 옵션은 환경변수로 지정하는 옵션으로 이렇게 전달된 환경 변수는 jenkins가 구동될때 참조하여 구동됩니다. (footerURL을 삼성SDS홈페이지로 변경하도록 해봤습니다.)

`docker ps`{{execute}} 를 통해서 myjenkins container가 잘 생성되었는지 확인할 수 있습니다.

그리고 Port 8080 탭을 눌러보시면 Jenkins가 web UI로 구동되어있는 것을 확인할 수 있습니다. (조금 시간이 걸릴 수 있습니다)

