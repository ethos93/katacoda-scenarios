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
      port: 80
      targetPort: 80
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
httpd-clusterip-service   ClusterIP   10.107.189.63   &lt;none&gt;        80/TCP     37m
</pre>

CLUSTER-IP는 다르겠지만 위와 같은 형태로 출력이 됩니다.
CLUSTER-IP는 Kubernetes cluster 내에서 사용가능한 IP이며 다른 Pod에서 해당 IP로 호출이 가능합니다.

또한, Pod 내부에서는 서비스 이름으로도 호출이 가능합니다. Kubernetes Cluster 내부에 DNS 서버(CoreDNS)가 존재하며, 서비스 이름으로 호출하면, DNS에서 서비스의 CLUSTER-IP를 반환해 주며, 이 IP로 호출이 되는 것입니다. (Pod의 IP를 반환하지 않습니다)

CoreDNS는 Cluster내부에서만 사용이 가능하니, Debugging을 위한 Pod을 하나 생성해 보겠습니다. 아래 명령을 통해 debugging용 pod을 생성합니다.
culr을 포함하고 있는 아주 작은 container image 입니다.

`kubectl run curlpod --image=radial/busyboxplus:curl --generator=run-pod/v1 --command -- /bin/sh -c "while true; do echo hi; sleep 10; done"`{{execute}}

curlpod 라는 pod 이 생성되었으니, 이제 curlpod 에서 서버스 이름으로 http 서버를 호출해 보겠습니다.

`kubectl exec -it curlpod -- curl httpd-clusterip-service`{{execute}} 으로 호출해 보면, curlpod 안에서 curl 명령이 실행됩니다.

응답이 정상적으로 오는 것을 확인할 수 있습니다. 동일한 exec 명령을 여러번 실행시켜 보면, 응답 중 hostname이 변하는 것도 확인할 수 있습니다.
이것은, 서비스를 통해 replicaset의 pod들 중 하나에 roundrobin으로 호출되기 때문입니다.
