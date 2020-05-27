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
        - containerPort: 80
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

다시 Editor나 vi를 이용하여 replicaset.yaml에서 replicas 값을 3에서 5로 변경해 봅니다.
`kubectl apply -f replicaset.yaml`{{execute}} 명령을 통해 변경한 값을 적용합니다.

`kubectl get pods`{{execute}} 를 통해 Pod 개수가 5개로 변경된 것을 확인할 수 있습니다.
