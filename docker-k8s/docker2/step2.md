Web UI로 접속을 해 보면, Unlock Jenkins 라는 화면이 표시되는 것을 확인할 수 있습니다.

Jenkins는 처음 구동될 때, 관리자에 의해 안전하게 설치되는 것을 확인하기 위해 초기 admin password를 log 와 특정 파일에 기록을 합니다.

하지만 우리는 -d 옵션을 구동을 시켰기 때문에 화면상에 log가 출력되지 않았습니다.

# docker logs

이제 Container에서 출력되는 log를 확인할 수 있는 방법을 알아보겠습니다.

logs 라는 command를 사용하면 됩니다.

`docker logs myjenkins`{{execute}}

위의 명령을 실행하면 conatiner에서 system out 이나 system error로 출력되는 log를 확인할 수 있습니다. -f 옵션을 함께 사용하면 출력되는 로그들을 계속 확인도 가능합니다.

스크롤을 올려보시면 install을 계속해서 진행할 수 있는 password가 보일 것입니다.

# docker exec

Web UI에 출력된 내용을 다시 보시면 log 에서 찾거나 /var/jenkins_home/secrets/initialAdminPassword 이 파일을 확인하라고 되어 있습니다.

이번에는 container 내부의 명령을 실행하는 방법을 알아보겠습니다.

exec 라는 command를 사용하면 됩니다.

`docker exec myjenkins cat /var/jenkins_home/secrets/initialAdminPassword`{{execute}}

위의 명령을 실행하면 container 내부에서 cat /var/jenkins_home/secrets/initialAdminPassword 를 실행한 결과가 출력됩니다.

만약에 container 내부를 terminal을 통해 접속하고자 한다면, -it 옵션을 추가로 사용할 수 있습니다.

이제 확인된 password를 Web UI에 입력하여 jenkins 설치를 완료해 봅니다.

마지막으로, volume에 jenkins 파일들이 생성되었는지도 확인해 봅니다.

`ls -la /var/lib/docker/volumes/myvolume/_data`{{execute}}
