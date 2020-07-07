ConfigMap은 Key:Value 형식으로 저장이 됩니다.

문자로 생성하는 방식과 파일로 생성하는 방식이 있습니다.

## ConfigMap from Literal

첫번째 실습을 위해 디렉토리를 이동합니다.

`cd /root/lab`{{execute}}

문자로 생성하는 방법은 kubectl create configmap 명령을 사용하여 다음과 같이 생성할 수 있습니다.

kubectl create configmap configmap이름 --from-literal=key=value

literal-config 이라는 이름의 configmap에 key는 company, value는 samsung 이라고 만들고 싶다면,

`kubectl create configmap literal-config --from-literal=company=Samsung`{{execute}} 로 실행하면 됩니다.

원하는대로 잘 생성되었는지는 describe를 통해 확인 가능합니다.

`kubectl describe configmaps literal-config`{{execute}}

## ConfigMap from File

파일을 통해 생성하는 방법은 동일하게 kubectl create configmap 명령을 사용하며 Option이 조금 다릅니다.

--from-file=파일명 을 사용하거나 --from-env-file=파일명 을 사용하는 것입니다.

--from-file 을 사용하면, key 는 파일명이 되고 value는 파일의 내용 자체가 됩니다.
--from-env-file 을 사용하면, 파일내에 key=value로 선언되어 있는 것들이 각각의 data로 configmap에 저장이 됩니다.

실제로 한번 작성해 보면서 그 차이를 확인해 보겠습니다.

우선 Properties 파일을 하나 만들어 봅니다.

다음을 선택하여 에디터를 통해 파일을 열거나 `app.properties`{{open}} , `vi app.properties`{{execute}} 를 통해 vi를 사용하셔도 됩니다.

<pre class="file" data-filename="app.properties" data-target="replace">database.url=192.168.0.88
database.port=5432
database.db=employee
database.user=hojoon
database.password=elqlvotmdnjem
</pre>

이제 이 파일을 통해 configmap을 만들어 보겠습니다.

먼저 --from-file 을 사용하여 file-config 라는 이름의 configmap을 만듭니다.

`kubectl create configmap file-config --from-file=./app.properties`{{execute}}

다음으로 --from-env-file 을 사용하여 file-env-config 라는 이름의 configmap을 만듭니다.

`kubectl create configmap file-env-config --from-env-file=./app.properties`{{execute}}

두개의 configmap 을 만들었고, 앞에서와 동일하게 각각의 configmap을 describe를 통해 확인해 보겠습니다.

`kubectl describe configmaps file-config`{{execute}}

`kubectl describe configmaps file-env-config`{{execute}}

Data 부분에 Key와 Value가 각각 어떻게 저장되었는지 확인할 수 있습니다.

## ConfigMap from Yaml

yaml 파일로도 생성할 수 있으며, key:value를 여러쌍 포함시킬 수도 있습니다.

다음을 선택하여 에디터를 통해 파일을 열거나 `yaml-config.yaml`{{open}} , `vi yaml-config.yaml`{{execute}} 를 통해 vi를 사용하셔도 됩니다.

<pre class="file" data-filename="yaml-config.yaml" data-target="replace">apiVersion: v1
kind: ConfigMap
metadata:
  name: yaml-config
data:
  location: Jamsil
  business: ITService
</pre>

작성된 yaml을 적용하겠습니다.
`kubectl apply -f yaml-config.yaml`{{execute}}

동일하게 describe로 확인해 봅니다.

`kubectl describe configmaps yaml-config`{{execute}}

## ConfigMap의 사용

ConfigMap은 Pod에서 환경변수로 넘길수가 있습니다.

ConfigMap의 Key와 Value를 Pod으로 전달하는 yaml를 작성해 보겠습니다.

다음을 선택하여 에디터를 통해 파일을 열거나 `configmappod.yaml`{{open}} , `vi configmappod.yaml`{{execute}} 를 통해 vi를 사용하셔도 됩니다.

<pre class="file" data-filename="configmappod.yaml" data-target="replace">apiVersion: v1
kind: Pod
metadata:
  name: configmap-pod
spec:
  containers:
    - name: configmap-container
      image: k8s.gcr.io/busybox
      command: [ "/bin/sh", "-c", "while true; do echo hi; sleep 10; done" ]
      env:
        - name: COMPANY
          valueFrom:
            configMapKeyRef:
              name: literal-config
              key: company
        - name: LOCATION
          valueFrom:
            configMapKeyRef:
              name: yaml-config
              key: location
        - name: BUSINESS
          valueFrom:
            configMapKeyRef:
              name: yaml-config
              key: business
        - name: DBURL
          valueFrom:
            configMapKeyRef:
              name: file-env-config
              key: database.url
      volumeMounts:
      - name: config-volume
        mountPath: /etc/config
  volumes:
    - name: config-volume
      configMap:
        name: file-config
  restartPolicy: Never
</pre>

Manifest를 보면, 아주 가벼운 busybox shell 만 포함하고 있는 이미지를 사용하며, kubectl cli를 통해 생성했던, literal-config에서 company키에 해당하는 value를 COMPANY 환경 변수에 담아주고, yaml을 통해 생성했던, yaml-config에서 location과 business key에 해당하는 value를 LOCATION과 BUSINESS 환경 변수에 담아주도록 하였습니다.
그리고, 파일로 부터 생성한 file-env-config의 database.url을 DBURL 환경 변수에 담아 주고, 마지막으로 file-config는 Volume으로 정의한 후 /etc/config 경로에 app.properties 파일로 Mount 시켰습니다.

이제 작성한 Manifest를 통해 Pod을 생성합니다.

`kubectl apply -f configmappod.yaml`{{execute}}

해당 pod의 환경변수에 어떤 값들이 들어갔는지 확인해 보겠습니다.

`kubectl exec -it configmap-pod -- env`{{execute}} 를 실행해 봅니다. 참고로 env는 linux에서 환경변수의 값들을 출력하는 명령입니다.

마지막으로, Volume으로 Mount된 파일의 내용도 확인해 보겠습니다.

`kubectl exec -it configmap-pod -- cat /etc/config/app.properties`{{execute}} 를 실행해 봅니다.

