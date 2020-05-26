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

다음을 선택하여 에디터를 통해 파일을 열거나 `clusterip_svc.yaml`{{open}} , `vi clusterip_svc.yaml`{{execute}} 를 통해 vi를 사용하셔도 됩니다.

<pre class="file" data-filename="clusterip_svc.yaml" data-target="replace">apiVersion: v1
kind: Service
metadata:
  name: httpd-clusterip-service
spec:
  selector:
    app: httpd-replicaset
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8080
  type: ClusterIP
</pre>

Manifest를 살펴보면, Kind에는 Service를 지정하였고, Selector에 app: httpd-replicaset 을 지정하였는데, 이것은 앞에서 ReplicaSet 을 생성할 때 Pod의 Label과 일치 합니다. 이처럼 Label은 Service와 Pod을 연결시켜주는 매우 중요한 Key 이므로 반드시 일치시켜줘야만 합니다. 복수개의 Label을 지정한다면 좀더 세밀하게 매핑을 지정할 수도 있습니다.

Type을 보면 ClusterIP로 지정되어 있으며, ClusterIP는 Service의 Default Type 이므로 생략해도 상관없습니다.

apply로 yaml 파일을 통해 object를 생성해 보겠습니다.

`kubectl apply -f clusterip_svc.yaml`{{execute}}

명령을 실행 시키면, "service/httpd-clusterip-service created" 라고 출력되면서 서비스가 만들어집니다.

`kubectl get services`{{execute}} 를 통해 httpd-clusterip-service 라는 서비스가 하나가 생성된 것을 확인할 수 있습니다.

<pre>
NAME                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
httpd-clusterip-service   ClusterIP   10.107.189.63   <none>        8080/TCP   37m
</pre>

CLUSTER-IP는 다르겠지만 위와 같은 형태로 출력이 됩니다.
CLUSTER-IP는 Kubernetes cluster 내에서 사용가능한 IP이며 다른 Pod에서 해당 IP로 호출이 가능합니다.

또한, Pod 내부에서는 서비스 이름으로도 호출이 가능합니다. Kubernetes Cluster 내부에 DNS 서버(CoreDNS)가 존재하며, 서비스 이름으로 호출하면, DNS에서 IP를 반환해 주며, 이 IP로 호출이 되는 것입니다.

CoreDNS는 Cluster내부에서만 사용이 가능하니, Debugging을 위한 Pod을 하나 생성해 보겠습니다. 아래 명령을 통해 debugging용 pod을 생성합니다.
culr을 포함하고 있는 아주 작은 container image 입니다.

`kubectl run curlpod --image=radial/busyboxplus:curl --command -- /bin/sh -c "while true; do echo hi; sleep 10; done"`{{execute}}

curlpod 라는 pod 이 생성되었으니, 이제 curlpod 에서 서버스 이름으로 http 서버를 호출해 보겠습니다. (kubernetes 최신 버전에서는 pod으로 생성되나, 구 버전에서는 Deployment로 생성되기 때문에 pod의 이름이 curlpod-xxxxxx-xxxx 식으로 만들어져 있을 것입니다.

kubectl exec -it curlpod이름 -- curl httpd-clusterip-service:8080 으로 호출해 보면, curlpod 안에서 curl 명령이 실행됩니다.

응답이 정상적으로 오는 것을 확인할 수 있습니다. 동일한 exec 명령을 여러번 실행시켜 보면, 응답 중 hostname이 변하는 것도 확인할 수 있습니다.
이것은, service 를 통해 replicaset의 pod들 중 하나에 roundrobin으로 호출되기 때문입니다.


