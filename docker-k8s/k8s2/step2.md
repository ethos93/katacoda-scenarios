우선 가장 기본 단위인 POD를 생성하여 보겠습니다.

첫번째 실습을 위해 디렉토리를 이동합니다.

`cd /root/lab`{{execute}}

다음을 선택하여 에디터를 통해 파일을 열거나 `pod.yaml`{{open}} , `vi pod.yaml`{{execute}} 를 통해 vi를 사용하셔도 됩니다.

<pre class="file" data-filename="pod.yaml" data-target="replace">apiVersion: v1
kind: Pod
metadata:
  name: httpd
  labels:
    app: httpd
spec:
  containers:
  - image: ethos93/go-httpd:v1
    imagePullPolicy: Always
    name: httpd
    ports:
    - containerPort: 80
      protocol: TCP
</pre>

Manifest를 살펴보면, Kind 에는 Object 종류, 그리고 metadata 에는 이름과 Label을 지정하도록 되어 있습니다.
Spec 에는 Pod에 생성될 container의 spec을 지정하도록 되어 있습니다.
containers(복수)로 되어 있는 것을 보면 알 수 있듯, 다수의 contianer를 지정하여 하나의 Pod에 여러개의 Container가 실행될 수 있도록 할 수 있습니다.
여기서는 ethos93/go-httpd:v1 이미지를 지정하였으며, 포트는 80을 사용하도록 지정하였습니다.
go로 만들어진 아주 단순한 웹서버이며, 호출시 현재 이미지 버전 및 hostname을 응답으로 전달해 줍니다.

yaml 파일을 통해 object를 생성하는 방법은, kubectl create -f "yaml 파일명" 입니다.
또 apply 도 사용할 수 있는데, apply는 기존에 동일한 이름의 object가 없다면, create를, 동일한 이름의 object가 없다면 replace를 시켜줍니다.
apply로 yaml 파일을 통해 object를 생성해 보겠습니다.

`kubectl apply -f pod.yaml`{{execute}}

명령을 실행 시키면, "pod/httpd created" 라고 출력되면서 pod 이 만들어집니다.

`kubectl get pods`{{execute}} 를 통해 httpd Pod 하나가 생성된 것을 확인할 수 있습니다.
