이전 Setp에서 multi-stage build를 통해 최종 Docker 이미지의 사이즈를 줄이는 방법에 대해 알아보았습니다.
최대한 줄이고자 노력했음에도, Java Application 는 Java Runtime (JRE)가 없으면 구동되지 않으므로 이미지에 JRE가 포함되면서 그 사이즈가 상당히 큰 것을 확인할 수 있습니다.

Go 언어에 대해 익숙하신 분도 계시고, 처음 접하시는 분도 계시겠지만, Go 언어는 모든 Library를 하나의 Static Binary에 포함시켜서 Excutable Binary 하나만으로 배포가 가능한 특징이 있습니다. (각 환경에 맞게 Build해 주어야 하며 각 환경에 맞는 Binary 가 생성됩니다.)

이번에는, Go 언어로 작성된 "Hello Docker!!!"를 출력하는 간단한 Docker Image를 생성해 보도록 하겠습니다.

## Go Application
lab 경로에 HelloDocker.go 파일이 생성되어 있습니다.
에디터로 열려 있으며 수정하시면 자동 저장됩니다.

vi가 익숙하시면 vi를 사용하셔도 됩니다.
`vi HelloDocker.go`{{execute}}

<pre class="file" data-filename="HelloDocker.go" data-target="replace">package main
import "fmt"
func main() {
    fmt.Println("Hello Docker!!!")
}
</pre>

실행시 "Hello Docker!!!"를 출력하고 종료되는 아주 간단한 Application 입니다.
원하신다면 go code를 직접 수정해 보셔도 좋습니다.

## Dockerfile 수정
Dockerfile을 아래와 같이 수정합니다.

역시 vi가 익숙하시면 vi를 사용하셔도 됩니다.
`vi Dockerfile`{{execute}}

<pre class="file" data-filename="Dockerfile" data-target="replace">FROM golang:alpine AS build-stage
WORKDIR $GOPATH/src/HelloDocker/
COPY HelloDocker.go .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags="-w -s" -o /hello/HelloDocker

FROM scratch as production-stage
COPY --from=build-stage /hello/HelloDocker /hello/HelloDocker
CMD ["/hello/HelloDocker"]
</pre>

1. Go SDK이 포함된 이미지를 build-stage 로 정하고
2. 작업 경로를 GOPATH 아래로 정하여 이동
3. $GOPATH/src/HelloDocker/ 경로에 HelloDocker.go 파일을 복사하고
4. HelloDocker.go 를 컴파일 (Library가 Static Linking되도록 하고, Binary는 /hello 경로에 HelloDocker 로 생성)
5. 아무것도 포함되지 않은 빈 이미지(Scratch)를 production-stage 로 정하고
6. build-stage 이미지로의 /hello/HelloDocker 파일을 production-stage로 복사하고
7. docker container가 구동되면 /hello/HelloDocker 파일을 실행

Dockerfile을 잘 수정하였다면, 이제 이미지를 생성합니다.

## docker 이미지 생성
hellodocker이미지를 v3 tag를 붙여서 생성합니다.

`docker build -t hellodocker:v3 .`{{execute}}

출력되는 로그를 보시면, production-stage를 위한 Base Image는 scratch 이미지이기 때문에 별도로 다운 받는 것 없이 Dockerfile에 명시된 대로, 진행됩니다.

## docker 이미지 확인
hellodocker 이미지가 정상적으로 생성 되었는지 확인합니다.

`docker images`{{execute}}

v1 과 v2와 달리 v3의 이미지 사이즈는 엄청나게 차이가 납니다.
아무것도 포함되지 않은 Scratch 이미지에 Go 실행파일 하나만 포함되었기 때문입니다.

Kubernetes의 엔진을 포함한 대부분이 Go 언어로 개발되었으며, 성능이 뛰어나고 개발 편의성도 높기 때문에 최근 매우 많이 사용되고 있습니다.

생성된 이미지가 잘 실행되는지도 확인합니다.

`docker run hellodocker:v3`{{execute}}
