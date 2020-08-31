## Java Spring Boot 참고

Spring boot으로 Web Application을 작성하는 방법은 아래 Link를 참고하시기 바랍니다.

https://spring.io/guides/gs/spring-boot/

source 코드를 가져온 뒤에 편집하여 사용하시면 됩니다.

`git clone https://github.com/spring-guides/gs-spring-boot.git`{{execute}}

/root/lab/gs-spring-boot/initial project를 통해 web application을 작성할 수 있습니다.

Java JDK 버전을 1.8을 사용하며,

git clone 된 source 코드를 vi 나 Editor에서 열어 편집하여 사용하시면 됩니다.

java에서 환경변수값을 읽어오는 방법은, System.getenv("변수명"); 를 사용하시면 됩니다.

빌드는 gradlew build 명령을 통해 가능하며, build가 완료되면, build/libs 디렉토리 하위에 spring-boot-0.0.1-SNAPSHOT.jar 와 같이 jar 파일이 생성됩니다.

서버 구동은 java -jar spring-boot-0.0.1-SNAPSHOT.jar 와 같이 하면 됩니다.

위의 내용들을 참고하여 Web Application Image를 생성하고 container에서 해당 서버를 구동시켜 테스트 하여 보시기 바랍니다.
