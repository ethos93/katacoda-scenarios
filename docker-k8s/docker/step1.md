우선, ubuntu 최신 이미지를 Repository로 부터 pull 하여 local에 저장해 보겠습니다.

## Ubuntu 이미지 pull

다음 명령을 통해 ubuntu 이미지를 pull 할 수 있습니다.
`docker pull ubuntu`{{execute}}

이미지는 하나의 파일로 다운로드 되는 것이 아니라, 여러 layer가 순차적으로 다운로드 됩니다.
