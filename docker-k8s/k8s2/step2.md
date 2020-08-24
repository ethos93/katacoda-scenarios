이번에는 NodePort Type의 서비스를 생성해 보겠습니다.

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

Manifest를 살펴보면, Kind에는 Service를 지정하였고, Selector에 app: httpd-deployment 을 지정하였는데, 이것은 앞에서 Deployment 을 생성할 때 Pod의 Label과 일치 합니다.

Type을 보면 NodePort로 지정되어 있습니다.

apply로 yaml 파일을 통해 object를 생성해 보겠습니다.

`kubectl apply -f nodeport_svc.yaml`{{execute}}

명령을 실행 시키면, "service/httpd-nodeport-service created" 라고 출력되면서 서비스가 만들어집니다.

`kubectl get services`{{execute}} 를 통해 httpd-nodeport-service 라는 서비스가 추가로 생성된 것을 확인할 수 있습니다.

<pre>
NAME                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
httpd-nodeport-service   NodePort     10.107.189.63   &lt;none&gt;        80:31973/TCP     37m
</pre>

CLUSTER-IP와 PORT는 다르겠지만 위와 같은 형태로 출력이 됩니다.
CLUSTER-IP는 clusterIP Type으로 생성했을 때와 동일하게 Kubernetes cluster 내에서 사용가능한 IP이며 다른 Pod에서 해당 IP로 호출이 가능합니다.
NodePort Type으로 생성했을 때는 PORT(S) 부분에 80 이외에 31973과 같이 30000번대의 Port가 추가로 보이는 것을 확인 할 수 있습니다.

이것이 NodePort의 번호이고, 기본값으로는 30000-32767 중의 하나의 Port가 할당됩니다.
Kubernetes Cluster를 구성하는 모든 Node에 동일한 Port가 오픈되며, 외부에서는 Node들 중 하나의 IP와 NodePort 번호를 통해 Pod에 접근할 수 있게 됩니다.

지금 사용중인 Kubernetes Cluster의 IP를 확인하고 Node의 IP와 NodePort의 Port를 통해 http 서비스를 호출해 보겠습니다.

Kubernetes Cluster의 IP는 다음과 같이 확인할 수 있습니다.

`kubectl get nodes -o wide`{{execute}}

master node와 node01 node의 IP를 확인할 수 있습니다.
이제 확인된 IP로 서비스를 호출해 봅니다.

curl {node ip}:NodePort번호 로 호출해 보면, http 서비스가 정상적인 응답을 줍니다. (master ip나 node01 ip 중 어느것을 사용하여도 동일하게 응답을 받을 수 있습니다.)

NodePort Type으로 서비스를 생성하여도 ClusterIP의 속성은 모두 동일하게 가지고 있기 때문에, ClusterIP Type에서 사용한 것과 동일하게 Cluster내에서는 ClusterIP 혹은 서비스명으로 호출하는 것도 가능합니다.
