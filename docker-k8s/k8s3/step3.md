Secret은 ConfigMap과 동일하게 Key:Value 형식으로 저장이 됩니다.

차이점은, 저장될 때 base64 encoding이 되어서 저장된다는 점입니다. 사실 암호화되어 저장되는 것도 아니고 단순히 base64 encoding만 되기 때문에 안전하다고 할 수는 없으나 공격자(?)에게는 혼란을 줄 수 있습니다.

## Secret from Literal

문자로 생성하는 방법은 kubectl create secret generic 명령을 사용하여 다음과 같이 생성할 수 있습니다.

kubectl create secret generic secret이름 --from-literal=key=value

literal-secret 이라는 이름의 secret에 key는 company, value는 samsung 이라고 만들고 싶다면,

`kubectl create secret generic literal-secret --from-literal=company=Samsung`{{execute}} 로 실행하면 됩니다.

원하는대로 잘 생성되었는지는 describe를 통해 확인 가능합니다.

`kubectl describe secret literal-secret`{{execute}}

configmap 과 다르게 key는 노출되지만, value는 size만 표시 됩니다.

value까지 확인하려면 get 명령을 사용하면 됩니다.

`kubectl get secret literal-secret -o yaml`{{execute}}

base64 encoding이 된 value 값을 확인할 수 있습니다.

## Secret from File

파일을 통해 생성하는 방법은 동일하게 kubectl create secret generic 명령을 사용하며 Option이 조금 다릅니다.

--from-file=파일명 을 사용하거나 --from-env-file=파일명 을 사용하는 것입니다.

--from-file 을 사용하면, key 는 파일명이 되고 value는 파일의 내용 자체가 됩니다.
--from-env-file 을 사용하면, 파일내에 key=value로 선언되어 있는 것들이 각각의 data로 secret에 저장이 됩니다.

앞서 configmap에서 작성한 파일을 통해 secret을 만들어 보겠습니다.

먼저 --from-file 을 사용하여 file-secret 라는 이름의 secret을 만듭니다.

`kubectl create secret generic file-secret --from-file=./app.properties`{{execute}}

다음으로 --from-env-file 을 사용하여 file-env-secret 라는 이름의 configmap을 만듭니다.

`kubectl create secret generic file-env-secret --from-env-file=./app.properties`{{execute}}

두개의 secret 을 만들었고, 앞에서와 동일하게 각각의 secret을 describe를 통해 확인해 보겠습니다.

`kubectl describe secret file-secret`{{execute}}

`kubectl describe secret file-env-secret`{{execute}}

## Secret from Yaml

yaml 파일로도 생성할 수 있으며, key:value를 여러쌍 포함시킬 수도 있습니다.

단, configmap과 달리 secret을 생성할 때는, value를 base64 encoding한 값으로 작성해야만 합니다.

다음을 선택하여 에디터를 통해 파일을 열거나 `yaml-secret.yaml`{{open}} , `vi yaml-secret.yaml`{{execute}} 를 통해 vi를 사용하셔도 됩니다.

<pre class="file" data-filename="yaml-secret.yaml" data-target="replace">apiVersion: v1
kind: Secret
metadata:
  name: yaml-secret
data:
  location: SmFtc2ls
  business: SVRTZXJ2aWNl
</pre>

location의 value는 Jamsil 을 base64 encoding 한 값이며, business의 value는 ITService를 base64 encoding 한 값입니다.

`echo -n 'Jamsil' | base64`{{execute}}

`echo -n 'ITService' | base64`{{execute}}

작성된 yaml을 적용하겠습니다.
`kubectl apply -f yaml-secret.yaml`{{execute}}

동일하게 describe로 확인해 봅니다.

`kubectl describe secret yaml-secret`{{execute}}

## Secret의 사용

Secret은 Pod에서 환경변수로 넘길수가 있습니다.

Secret의 Key와 Value를 Pod으로 전달하는 yaml를 작성해 보겠습니다.

다음을 선택하여 에디터를 통해 파일을 열거나 `secretpod.yaml`{{open}} , `vi secretpod.yaml`{{execute}} 를 통해 vi를 사용하셔도 됩니다.

<pre class="file" data-filename="secretpod.yaml" data-target="replace">apiVersion: v1
kind: Pod
metadata:
  name: secret-pod
spec:
  containers:
    - name: secret-container
      image: k8s.gcr.io/busybox
      command: [ "/bin/sh", "-c", "while true; do echo hi; sleep 10; done" ]
      env:
        - name: COMPANY
          valueFrom:
            secretKeyRef:
              name: literal-secret
              key: company
        - name: LOCATION
          valueFrom:
            secretKeyRef:
              name: yaml-secret
              key: location
        - name: BUSINESS
          valueFrom:
            secretKeyRef:
              name: yaml-secret
              key: business
        - name: DBURL
          valueFrom:
            secretKeyRef:
              name: file-env-secret
              key: database.url
      volumeMounts:
      - name: secret-volume
        mountPath: /etc/config
  volumes:
    - name: secret-volume
      secret:
        secretName: file-secret
  restartPolicy: Never
</pre>

Manifest를 보면, 아주 가벼운 busybox shell 만 포함하고 있는 이미지를 사용하며, kubectl cli를 통해 생성했던, literal-secret에서 company키에 해당하는 value를 COMPANY 환경 변수에 담아주고, yaml을 통해 생성했던, yaml-secret에서 location과 business key에 해당하는 value를 LOCATION과 BUSINESS 환경 변수에 담아주도록 하였습니다.
그리고, 파일로 부터 생성한 file-env-secret의 database.url을 DBURL 환경 변수에 담아 주고, 마지막으로 file-secret는 Volume으로 정의한 후 /etc/config 경로에 app.properties 파일로 Mount 시켰습니다.

이제 작성한 Manifest를 통해 Pod을 생성합니다.

`kubectl apply -f secretpod.yaml`{{execute}}

해당 pod의 환경변수에 어떤 값들이 들어갔는지 확인해 보겠습니다.

`kubectl exec -it secret-pod -- env`{{execute}} 를 실행해 봅니다. 참고로 env는 linux에서 환경변수의 값들을 출력하는 명령입니다.

마지막으로, Volume으로 Mount된 파일의 내용도 확인해 보겠습니다.

`kubectl exec -it secret-pod -- cat /etc/config/app.properties`{{execute}} 를 실행해 봅니다.
