Katacoda의 환경 제약으로 네트워크 볼륨은 사용할 수 없기 때문에 emptyDir 볼륨에 대한 실습만 진행하도록 하겠습니다.

emptyDir 볼륨은 Pod가 노드에 할당 될 때 처음 생성되며, 해당 노드에서 Pod가 실행되는 동안에만 존재합니다. 이름에서 알 수 있듯이 emptyDir 볼륨은 비어있는 볼륨이 생성됩니다. Pod 내에 모든 Container는 emptyDir 볼륨에서 동일한 파일을 읽고 쓸 수 있지만, 볼륨은 각각의 Container에 동일하거나 다른 경로에 마운트 될 수 있습니다.

Pod가 제거된다면 emptyDir 볼륨 내의 데이터는 영구적으로 삭제되게 됩니다.

## 실습을 위한 이미지

실습을 진행하기 위해 제가 사전에 만들어 놓은 Docker Image 와 Apache httpd Image를 사용할 예정입니다.

첫번째로 제가 만들어 놓은 이미지의 소스는 GitHub( https://github.com/ethos93/fortunes )에 있으며, 이미지는 Docker Hub( https://hub.docker.com/repository/docker/ethos93/fortune )에 Push 되어 있습니다.

소스에는 shell script와 Docker 파일이 있으며, fortuneloop.sh 라는 shell script는 Ubuntu의 Fortune package를 사용하여 2초에 한번씩 명언(?)을 /var/htdocs/index.html 파일로 저장하는 기능을 하도록 만들었습니다.

<pre class="file">
while :
do
  echo $(date) Writing fortune to /var/htdocs/index.html
  /usr/games/fortune > /var/htdocs/index.html
  sleep 2
done
</pre>


두번째로 Apache httpd Image는 Docker hub에 있는 공식 이미지를 사용합니다.

## Pod Manifest

다음을 선택하여 에디터를 통해 파일을 열거나 `fortune-httpd.yaml`{{open}} , `vi fortune-httpd.yaml`{{execute}} 를 통해 vi를 사용하셔도 됩니다.

<pre class="file" data-filename="fortune-httpd.yaml" data-target="replace">apiVersion: v1
kind: Pod
metadata:
  name: fortune
  labels:
    app: fortune
spec:
  containers:
  - image: ethos93/fortune
    name: html-generator
    volumeMounts:
    - name: html
      mountPath: /var/htdocs
  - image: httpd
    name: web-server
    volumeMounts:
    - name: html
      mountPath: /usr/local/apache2/htdocs
      readOnly: true
    ports:
    - containerPort: 80
      protocol: TCP
  volumes:
  - name: html
    emptyDir: {}
</pre>

emptyDir 볼륨을 html 이라는 이름으로 정의를 하였고, ethos93/fortune 이미지를 사용하는 html-generator Container 에서는 html Volume을 /var/htdocs 에 마운트 하도록 정의하였습니다.
Apache Httpd 이미지를 사용하는 web-server Container에서는 html Volume을 웹서버의 root directory 인 /usr/local/apache2/htdocs 에 마운트 하도록 정의하였습니다.

작성된 yaml을 적용하겠습니다.

`kubectl apply -f fortune-httpd.yaml`{{execute}}

Container를 두개 포함하고 있는 Pod 가 생성되면서, emptyDir 볼륨도 생성이 됩니다.

이후 내부에 Container 2개가 생성되면서 html-generator Container는 2초에 한번씩 명언을 emptyDir 볼륨에 index.html로 저장하고, web-server Container는 emptyDir 볼륨의 index.html를 웹서비스로 제공하게 됩니다.

Pod이 정상적으로 생성되었는지 확인 후 여기에 연결할 서비스도 만들어 보겠습니다.

`kubectl get pods`{{execute}}

다음을 선택하여 에디터를 통해 파일을 열거나 `fortune-svc.yaml`{{open}} , `vi fortune-svc.yaml`{{execute}} 를 통해 vi를 사용하셔도 됩니다.

<pre class="file" data-filename="fortune-svc.yaml" data-target="replace">apiVersion: v1
kind: Service
metadata:
  name: fortune-svc
spec:
  selector:
    app: fortune
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: NodePort
</pre>

NodePort Service 에 대한 Menifest 입니다.

작성된 yaml을 적용하겠습니다.

`kubectl apply -f fortune-svc.yaml`{{execute}}

Service가 생성되었으니, 이제 nodePort를 확인하고 한번 호출해 보겠습니다.

`kubectl get svc`{{execute}}

curl 127.0.0.1:노드포트 를 실행하면 10초마다 달라지는 출력을 확인할 수 있습니다.

아래 링크를 사용하면 브라우저에서도 확인 가능합니다. (새로 열리는 창에서 Display port를 NodePort로 지정하시면 됩니다.)

https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com
