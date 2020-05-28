ConfigMap은 Key:Value 형식으로 저장이 됩니다.

문자로 생성하는 방식과 파일로 생성하는 방식이 있으며, 문자로 생성하는 방식은 일반적인 Key:Value 로 저장되지만, 파일로 생성하는 경우에는 Key는 파일명이 되고 Value는 파일의 전체 내용이 됩니다.

## ConfigMap from Literal

첫번째 실습을 위해 디렉토리를 이동합니다.

`cd /root/lab`{{execute}}

문자로 생성하는 방법은 kubectl create configmap 명령을 사용하여 다음과 같이 생성할 수 있습니다.

kubectl create configmap configmap이름 --from-literal=key=value

myconfigmap 이라는 이름의 configmap에 key는 company, value는 samsung 이라고 만들고 싶다면,

`kubectl create configmap myconfigmap --from-literal=company=Samsung`{{execute}} 로 실행하면 됩니다.

원하는대로 잘 생성되었는지는 describe를 통해 확인 가능합니다.

`kubectl describe configmaps myconfigmap`{{execute}}

또한 yaml 파일로도 생성할 수 있으며, key:value를 여러쌍 포함시킬 수도 있습니다.

다음을 선택하여 에디터를 통해 파일을 열거나 `myconfigmapyaml.yaml`{{open}} , `vi myconfigmapyaml.yaml`{{execute}} 를 통해 vi를 사용하셔도 됩니다.

<pre class="file" data-filename="myconfigmapyaml.yaml" data-target="replace">apiVersion: v1
kind: ConfigMap
metadata:
  name: myconfigmapyaml
data:
  location: Jamsil
  business: ITService
</pre>

작성된 yaml을 적용하겠습니다.
`kubectl apply -f myconfigmapyaml.yaml`{{execute}}

동일하게 describe로 확인해 봅니다.

`kubectl describe configmaps myconfigmapyaml`{{execute}}

문자로 생성한 ConfigMap은 Pod에서 환경변수로 넘길수가 있습니다.

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
              name: myconfigmap
              key: company
        - name: LOCATION
          valueFrom:
            configMapKeyRef:
              name: myconfigmapyaml
              key: location
        - name: BUSINESS
          valueFrom:
            configMapKeyRef:
              name: myconfigmapyaml
              key: business
  restartPolicy: Never
</pre>

Manifest를 보면, 아주 가벼운 busybox shell 만 포함하고 있는 이미지를 사용하며, kubectl cli를 통해 생성했던, myconfigmap에서 company키에 해당하는 value를 COMPANY 환경 변수에 담아주고, yaml을 통해 생성했던, myconfigmapyaml에서 location과 business key에 해당하는 value를 LOCATION과 BUSINESS 환경 변수에 담아 준 뒤 pod를 생성하도록 하였습니다.

해당 pod의 환경변수에 어떤 값들이 들어갔는지 확인해 보겠습니다.

`kubectl exec -it configmap-pod env`{{execute}} 를 실행해 봅니다. 참고로 env는 linux에서 환경변수의 값들을 출력하는 명령입니다.

