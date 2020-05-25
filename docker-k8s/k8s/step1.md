Kubernetes에 Application을 배포하고, 외부에서 접속 할 수 있도록 설정을 하는 실습을 해 보겠습니다.

Katacoda 에서 Kubernetes Cluster로 환경을 구성할 경우 Editor사용이 불가능하여, Cluster가 아닌 Master만 있는 환경에서 실습을 진행하겠습니다.
초기 환경 설정까지 시간이 걸릴 수 있으니 잠시 기다려 주시기 바랍니다.
(Cluster 환경에서 실습을 원하신다면, https://www.katacoda.com/tfogo/scenarios/k8s 에서 학습해 볼 수 있습니다.)

현재 kubernetes 환경의 상태를 확인하기 위해서는,

`kubectl cluster-info`{{execute}}

`kubectl get nodes`{{execute}}

`kubectl get pods -A`{{execute}}

를 각각 실행시켜 보시면 됩니다.

Status가 Ready와 Running으로 되어 있다면 kubernetes가 정상적으로 구동 중입니다.

kubernetes의 최소 단위는 POD 이며, POD의 Replica 개수를 지정하는 것이 ReplicaSet, 그리고 ReplicaSet의 배포 및 롤백과 같이 History를 포함하는 것이 Deployment 입니다.

## POD 생성
우선 가장 기본 단위인 POD를 생성하여 보겠습니다.

첫번째 실습을 위해 디렉토리를 이동합니다.

`cd /root/lab`{{execute}}

다음을 선택하여 에디터를 통해 파일을 열거나 `pod.yaml`{{open}} , `vi pod.yaml`{{execute}} 를 통해 vi를 사용하셔도 됩니다.

<pre class="file" data-filename="pod.yaml" data-target="replace">apiVersion: v1
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

Manifest를 살펴보면, Kind 에는 Object 종류, 그리고 metadata 에는 이름과 Label을 지정하도록 되어 있습니다.
Spec 에는 Pod에 생성될 container의 spec을 지정하도록 되어 있습니다.
containers(복수)로 되어 있는 것을 보면 알 수 있듯, 다수의 contianer를 지정하여 하나의 Pod에 여러개의 Container가 실행될 수 있도록 할 수 있습니다.
여기서는 ethos93/go-httpd:v1 이미지를 지정하였으며, 포트는 8080을 사용하도록 지정하였습니다.
go로 만들어진 아주 단순한 웹서버이며, 호출시 현재 이미지 버전 및 hostname을 응답으로 전달해 줍니다.

yaml 파일을 통해 object를 생성하는 방법은, kubectl create -f "yaml 파일명" 입니다.
또 apply 도 사용할 수 있는데, apply는 기존에 동일한 이름의 object가 없다면, create를, 동일한 이름의 object가 없다면 replace를 시켜줍니다.
apply로 yaml 파일을 통해 object를 생성해 보겠습니다.

`kubectl apply -f pod.yaml`{{execute}}

명령을 실행 시키면, "pod/httpd created" 라고 출력되면서 pod 이 만들어집니다.

`kubectl get pods`{{execute}} 를 통해 생성된 Pod을 확인할 수 있습니다.

## ReplicaSet 생성
앞서 Pod를 생성해 보았는데, Pod으로 생성하게 되면, Pod에 문제가 생겼을 경우 서비스가 중단될 수 있습니다.
물론, Kubernetes는 문제가 생긴 Pod을 종료시키고 새로운 Pod를 생성 시키는 등 자동화 되어 있긴 합니다.
하지만, Kubernetes가 Pod의 문제를 인지하고, 새로운 Pod를 생성하여 서비스가 다시 시작될 때 까지는 서비스가 불가능하기 때문에, Production 환경에서는 반드시 복수개의 Pod을 생성하여 중단 없는 서비스를 제공할 필요가 있습니다.

이를 위해 ReplicatSet이라는 Object가 있습니다. ReplicatSet를 생성해 보도록 하겠습니다.

다음을 선택하여 에디터를 통해 파일을 열거나 `replicaset.yaml`{{open}} , `vi replicaset.yaml`{{execute}} 를 통해 vi를 사용하셔도 됩니다.

<pre class="file" data-filename="replicaset.yaml" data-target="replace">apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: httpd-replicaset
  labels:
    app: httpd-replicaset
spec:
  replicas: 3
  selector:
    matchLabels:
      app: httpd-replicaset
  template:
    metadata:
      labels:
        app: httpd-replicaset
    spec:
      containers:
      - image: ethos93/go-httpd:v1
        imagePullPolicy: Always
        name: httpd-replicaset
        ports:
        - containerPort: 8080
          protocol: TCP
</pre>

Manifest를 살펴보면, Kind 에는 Object 종류, 그리고 metadata 에는 이름과 Label을 지정하도록 되어 있습니다.
Spec을 보면, Pod과는 다르게, replicas 라는 것과 selector 라는 것이 있습니다.

replicas는 몇개의 복제본을 만들 것인지를 지정하는 것이고, selector는 label를 통해 pod를 확인하면서 현재 pod의 수를 관리합니다. selector가 참조하는 label은 template에 정의된 label 입니다.

template에는 Pod의 manifest가 그대로 들어갑니다.

이제 `kubectl apply -f replicaset.yaml`{{execute}} 명령을 통해 ReplicaSet 을 생성합니다.

명령을 실행 시키면, "replicaset.apps//httpd-replicaset created" 라고 출력되면서 ReplicaSet 이 만들어집니다.

`kubectl get replicasets`{{execute}} 를 통해 생성된 ReplicaSet을 확인할 수 있으며, `kubectl get pods`{{execute}} 를 통해 3개의 Pod가 생성된 것을 확인할 수 있습니다.
Pod의 이름은 ReplicaSet 이름 - hash 값으로 자동 생성됩니다.

## Deployment 생성
ReplicaSet을 통해 복제본을 여러개 생성시킬 수 있다는 것은 확인하였습니다.
그런데, ReplicaSet은 image의 tag를 변경하더라도 Pod을 새롭게 만들지 않습니다.
ReplicaSet을 통해 새로운 버전의 image Pod들을 만들기 위해서는, 기존 ReplicaSet을 삭제하고, 새롭게 ReplicaSet를 생성해 주어야만 합니다.
또한 Rollback 등 History 기능도 제공하지 않습니다.

따라서 무중단으로 서비스 되어야 하는 Production 환경에서는 적합하지 않습니다.
Production 환경에서는 Deployment 를 생성하여 서비스 하여야 합니다.

Deployment는 Image의 버전 변경 시 Update 전략에 따라 RollingUpdate 등을 지원합니다. 그리고 Autoscaling도 지원하여 복제본의 수를 부하 상태에 따라 자동 조절도 해 줍니다.

Deployment를 생성해 보도록 하겠습니다.

다음을 선택하여 에디터를 통해 파일을 열거나 `deployment.yaml`{{open}} , `vi deployment.yaml`{{execute}} 를 통해 vi를 사용하셔도 됩니다.

<pre class="file" data-filename="deployment.yaml" data-target="replace">apiVersion: apps/v1
kind: Deployment
metadata:
  name: httpd-deployment
  labels:
    app: httpd-deployment
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
    matchLabels:
      app: httpd-deployment
  template:
    metadata:
      labels:
        app: httpd-deployment
    spec:
      containers:
      - image: ethos93/go-httpd:v1
        imagePullPolicy: Always
        name: httpd-deployment
        ports:
        - containerPort: 8080
          protocol: TCP
</pre>

Manifest를 살펴보면, Kind 에는 Object 종류, 그리고 metadata 에는 이름과 Label을 지정하도록 되어 있습니다.
Spec을 보면, strategy 라는게 ReplicaSet에서 추가되었고, RollingUpdate를 지정하는 경우 maxSurge (지정된 복제본 수 이상으로 만들 Pod 수), maxUnavailable (지정된 복제본 수 보다 적게 서비스 될 수 있는 Pod 수)

나머지는 ReplicaSet과 동일합니다.

이제 `kubectl apply -f deployment.yaml`{{execute}} 명령을 통해 Deployment 을 생성합니다.

명령을 실행 시키면, "deployment.apps/httpd-deployment created" 라고 출력되면서 Deployment 가 만들어집니다.

`kubectl get deployments`{{execute}} 를 통해 생성된 Deployment 를 확인할 수 있으며, `kubectl get replicatsets`{{execute}} 를 통해 생성된 ReplicaSet을 확인할 수 있고, `kubectl get pods`{{execute}} 를 통해 3개의 Pod가 생성된 것을 확인할 수 있습니다.
ReplicaSet은 Deployment 이름 - hash 값으로 자동 생성되고, Pod의 이름은 ReplicaSet 이름 - hash 값으로 자동 생성됩니다.
