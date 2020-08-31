이전 Step에서 Java Application을 포함하는 docker 이미지를 생성해 보았는데,
base image로 java8을 사용하였기 때문에, Compiler를 포함하여 Java JDK가 모두 포함되어 이미지의 크기가 큽니다.

docker는 multi-stage build 기능을 제공하기 때문에 최종 docker 이미지에는 binary만 포함될 수 있도록 할 수가 있습니다.

HelloDocker.java 파일은 그대로 두고 Dockerfile만 수정해 보겠습니다.

## Dockerfile 수정
Dockerfile을 아래와 같이 수정합니다.

역시 vi가 익숙하시면 vi를 사용하셔도 됩니다.
`vi Dockerfile`{{execute}}

<pre class="file" data-filename="Dockerfile" data-target="replace">FROM openjdk:8 as build-stage
COPY HelloDocker.java /hello/
WORKDIR /hello
RUN javac HelloDocker.java

FROM openjdk:8-jre as production-stage
COPY --from=build-stage /hello/HelloDocker.class /hello/HelloDocker.class
WORKDIR /hello
CMD ["java","HelloDocker"]
</pre>

1. openjdk8이 포함된 이미지를 build-stage 로 정하고
2. /hello 경로에 HelloDocker.java 파일을 복사하고
3. /hello 경로로 이동한 뒤
4. HelloDocker.java 를 컴파일한뒤
5. openjdk8의 jre만 포함된 이미지를 production-stage 로 정하고
6. build-stage 이미지로의 /hello/HelloDocker.class 파일을 production-stage로 복사하고
7. 작업 경로를 /hello로 변경
8. docker container가 구동되면 java HelloDocker 를 실행

Dockerfile을 잘 수정하였다면, 이제 이미지를 생성합니다.

## docker 이미지 생성
hellodocker이미지를 v2 tag를 붙여서 생성합니다.

`docker build -t hellodocker:v2 .`{{execute}}

출력되는 로그를 보시면, build-stage를 위한 Base Image는 이미 이전에 받았기 때문에, production-stage를 위한 Base Image를 Pull 한 뒤에 Dockerfile에 명시된 대로, 진행됩니다.

## docker 이미지 확인
hellodocker 이미지가 정상적으로 생성 되었는지 확인합니다.

`docker images`{{execute}}

v1 과 v2 는 Java Application은 동일하지만, base image의 차이때문에 이미지 전체의 사이즈가 크게 차이가 납니다.
이와 같이 어떻게 Dockerfile를 작성하느냐에 따라 최종 이미지의 사이즈가 달라질 수 있으며, 이러한 차이가 이미지를 생성할때, Registry에 Push할때, Pull할때 네트워크 및 스토리지, 소요 시간등의 차이를 가져오기 때문에 가급적 이미지를 최소화 할 수 있도록 하는 노력이 필요합니다.

생성된 이미지가 잘 실행되는지도 확인합니다.

`docker run hellodocker:v2`{{execute}}
