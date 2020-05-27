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
  replicas: 10
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
        - containerPort: 80
          protocol: TCP
</pre>

Manifest를 살펴보면, Kind 에는 Object 종류, 그리고 metadata 에는 이름과 Label을 지정하도록 되어 있습니다.
Spec을 보면, strategy 라는게 ReplicaSet에서 추가되었고, RollingUpdate를 지정하는 경우 maxSurge (지정된 복제본 수 이상으로 만들 Pod 수), maxUnavailable (지정된 복제본 수 보다 적게 서비스 될 수 있는 Pod 수)

나머지는 ReplicaSet과 동일합니다.

이제 `kubectl apply -f deployment.yaml`{{execute}} 명령을 통해 Deployment 을 생성합니다.

명령을 실행 시키면, "deployment.apps/httpd-deployment created" 라고 출력되면서 Deployment 가 만들어집니다.

`kubectl get deployments`{{execute}} 를 통해 생성된 Deployment 를 확인할 수 있으며, `kubectl get replicasets`{{execute}} 를 통해 생성된 ReplicaSet을 확인할 수 있고, `kubectl get pods`{{execute}} 를 통해 10개의 Pod가 생성된 것을 확인할 수 있습니다.
ReplicaSet은 Deployment 이름 - hash 값으로 자동 생성되고, Pod의 이름은 ReplicaSet 이름 - hash 값으로 자동 생성됩니다.
