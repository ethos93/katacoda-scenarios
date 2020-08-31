이번에는 직접 간단한 Web Application Image를 생성하고 구동시켜보는 실습을 진행하겠습니다.

실습을 위해 디렉토리를 이동합니다.

`cd /root/lab`{{execute}}

## 사용 언어 및 Framework

만들어 볼 Web Application은 Java Spring Boot, Node.js, Python 어느것으로 작성하여도 무방하며, 이외에도 본인이 직접 작성할 수 있는 Application이 있다면 자유롭게 작성하셔도 상관없습니다.

이후 Step에서 Java Spring Boot, Node.js, Python으로 Application을 작성할 때 참고 할 수 있는 사이트의 링크를 알려드리겠습니다.

참고하셔서 작성하여 주시면 됩니다.

## 서버의 구동

만들어진 Web Application 서버는 deamon 으로 동작할 수 있도록 만들어 주세요.

(docker run 시 -d 옵션 사용)

## Web 서버의 포트

각 언어별로 Default Port 들이 있지만, 최종적으로 Docker로 구동되는 웹서버의 Listening Port는 80 포트로 만들어 주세요.

(docker run 시 -p 옵션 사용)

## Http 요청시 응답

서버 구동시 환경변수를 사용하여 Hello + "NAME" 으로 출력될 수 있도록 만들어 주세요. 여기서 NAME은 환경변수를 사용하여 구동시 값을 변경할 수 있도록 만들어 주세요.

(docker run 시 -e NAME=XXX 옵션 사용)

## 서버가 정상동작하는지 브라우저를 통해 확인

아래 링크를 클릭하여 서버가 80 포트에서 정상 동작하는 지 확인해 주세요.

https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com
