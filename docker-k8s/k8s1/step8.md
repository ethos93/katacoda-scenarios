마지막으로 LoadBalancer Type의 서비스를 생성해 보겠습니다.

다음을 선택하여 에디터를 통해 파일을 열거나 `loadbalancer_svc.yaml`{{open}} , `vi loadbalancer_svc.yaml`{{execute}} 를 통해 vi를 사용하셔도 됩니다.

<pre class="file" data-filename="loadbalancer_svc.yaml" data-target="replace">apiVersion: v1
kind: Service
metadata:
  name: httpd-loadbalancer-service
spec:
  selector:
    app: httpd-deployment
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: LoadBalancer
</pre>

Manifest를 살펴보면, Kind에는 Service를 지정하였고, Selector에 app: httpd-deployment 을 지정하였는데, 이것은 앞에서 Deployment 을 생성할 때 Pod의 Label과 일치 합니다.

Type을 보면 LoadBalancer로 지정되어 있습니다.

apply로 yaml 파일을 통해 object를 생성해 보겠습니다.

`kubectl apply -f loadbalancer_svc.yaml`{{execute}}

명령을 실행 시키면, "service/httpd-loadbalancer-service created" 라고 출력되면서 서비스가 만들어집니다.

`kubectl get services`{{execute}} 를 통해 httpd-loadbalancer-service 라는 서비스가 추가로 생성된 것을 확인할 수 있습니다.

<pre>
NAME                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
httpd-loadbalancer-service   LoadBalancer     10.107.189.63   	&lt;pending&gt;         80:31973/TCP     37m
</pre>

CLUSTER-IP와 PORT는 다르겠지만 위와 같은 형태로 출력이 됩니다.
CLUSTER-IP는 clusterIP Type으로 생성했을 때와 동일하게 Kubernetes cluster 내에서 사용가능한 IP이며 다른 Pod에서 해당 IP로 호출이 가능합니다.
또한 NodePort Type으로 생성했을 때와 같이 PORT(S) 부분에 80 이외에 31973과 같이 30000번대의 Port가 추가로 보이는 것을 확인 할 수 있습니다.

추가로 EXTERNAL-IP 부분에 &lt;pending&gt; 이라고 되어 있는 것을 확인할 수 있는데, LoadBalancer Type을 지원하는 Kubernetes Cluster에서는 외부IP가 할당이 되며 이때 포트는 기본 포트(예, 80)을 사용하게 됩니다.
Katacoda는 EXTERNAL-IP를 할당해 주지 않기 때문에 계속 &lt;pending&gt;으로 남아 있는 것을 확인할 수 있습니다.

LoadBalancer Type으로 서비스를 생성하여도 ClusterIP의 속성과 NodePort의 속성을 모두 동일하게 가지고 있기 때문에, ClusterIP Type에서 사용한 것과 동일하게 Cluster내에서는 ClusterIP 혹은 서비스명으로 호출하는 것도 가능하며, NodePort를 통해 호출하는 것도 가능합니다.
