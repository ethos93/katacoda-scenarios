앞에서 Pod를 생성하는 방법들에 대해 알아 보았습니다. (Pod 단독 생성, ReplicaSet을 이용하여 복제본을 생성, Deployment를 이용하여 Update 가능한 복제본 생성)

Pod를 구성하는 Container의 이미지가 ethos93/go-httpd 였으며, 이것은 go로 만든 단순한 웹서버라고 했습니다.
웹서버는 외부에 http 서비스를 제공하여야 하니, 한번 호출해 보도록 하겠습니다.

`kubectl get pods -o wide`{{execute}} 를 실행시켜보면, 각 pod 들의 ip를 확인할 수 있습니다.

curl 명령을 사용하여 http 서비스를 호출해 보세요. (pod ip는 생성될 때마다 달라지니 다음과 같이 호출 하시면 됩니다.)

curl {pod ip}:8080

"This version is v1 and hostname is httpd" 과 같이 버전과 함께 hostname이 출력됩니다.
Deployment로 배포된 pod도 호출해 보시면 hostname이 다른 것을 확인할 수 있습니다.

Kubernetes Node 에서의 호출은 pod ip로 호출이 가능합니다.
그런데, pod은 상황(Worker Node가 갑자기 죽는다거나, Deployment로 새 버전을 배포한다거나, 
Replica 의 수를 변경한다거나)에 따라 새로 생성되기도, 없어지기도 하며, 이때 마다 pod의 ip는 계속 달라집니다. 따라서 pod의 ip로 호출하도록 하면 안됩니다.

Kubernetes는 pod을 호출하기 위해 "서비스" 라는 object를 사용합니다.

서비스의 Type에는 ClusterIP, NodePort, LoadBalancer 가 있으며 LoadBanaler는 Katacoda 환경에서 실습이 불가능하므로 ClusterIP와 NodePort에 대해 실습해 보도록 하겠습니다.

## ClusterIP

ClusterIP Type의 서비스를 생성해 보겠습니다.

다음을 선택하여 에디터를 통해 파일을 열거나 `pod.yaml`{{open}} , `vi pod.yaml`{{execute}} 를 통해 vi를 사용하셔도 됩니다.

<pre class="file" data-filename="clusterip.yaml" data-target="replace">apiVersion: v1
kind: Pod
metadata:
  name: httpd
  labels:
    run: httpd
spec:
  containers:
  - image: ethos93/go-httpd:v1
    imagePullPolicy: Always
    name: httpd
    ports:
    - containerPort: 8080
      protocol: TCP
</pre>
