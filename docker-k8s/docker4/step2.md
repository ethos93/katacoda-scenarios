## Java Spring Boot 참고

Spring boot으로 Web Application을 작성하는 방법은 아래 Link를 참고하시기 바랍니다.

https://spring.io/guides/gs/spring-boot/

Java JDK 버전을 1.8을 사용하며,

app.java, build.gradle 및 Dockerfile을 생성 해 주어야 합니다.

vi 를 통해 직접 파일을 생성, 편집하시거나, 아래 명령을 통해 file을 생성한 뒤에 Editor를 통해 편집하실 수 있습니다.

`touch app.java`{{execute}}
`touch build.gradle`{{execute}}
`touch Dockerfile`{{execute}}

java에서 환경변수값을 읽어오는 방법은, System.getenv("변수명"); 를 사용하시면 됩니다.
