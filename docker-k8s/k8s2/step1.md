Kubernetes Deployment 전략을 지정하고 Rollback을 실습하기 위해 앞서 생성했던 것과 동일한 Deployment를 생성해 보겠습니다.

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

이제 `kubectl apply -f deployment.yaml`{{execute}} 명령을 통해 Deployment 을 생성합니다.

다음으로, 앞서 작성한 것과 동일한 NodePort Type의 서비스도 생성해 보겠습니다.

다음을 선택하여 에디터를 통해 파일을 열거나 `nodeport_svc.yaml`{{open}} , `vi nodeport_svc.yaml`{{execute}} 를 통해 vi를 사용하셔도 됩니다.

<pre class="file" data-filename="nodeport_svc.yaml" data-target="replace">apiVersion: v1
kind: Service
metadata:
  name: httpd-nodeport-service
spec:
  selector:
    app: httpd-deployment
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: NodePort
</pre>

`kubectl apply -f nodeport_svc.yaml`{{execute}}

아래 명령을 통해 debugging용 pod을 생성합니다.

curl을 포함하고 있는 아주 작은 container image 입니다.

`kubectl run curlpod --image=radial/busyboxplus:curl --generator=run-pod/v1 --command -- /bin/sh -c "while true; do echo hi; sleep 10; done"`{{execute}}

curlpod 라는 pod 이 생성되었으니, 이제 curlpod 에서 서버스 이름으로 http 서버를 호출해 보겠습니다.

`kubectl exec -it curlpod -- curl httpd-nodeport-service`{{execute}} 으로 호출해 보면, curlpod 안에서 curl 명령이 실행됩니다.

