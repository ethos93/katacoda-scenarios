Kubernetes에 Application을 배포하고, 외부에서 접속 할 수 있도록 설정을 하는 실습을 해 보겠습니다.

Katacoda 에서 Kubernetes Cluster로 환경을 구성할 경우 Editor사용이 불가능하여, Cluster가 아닌 Master만 있는 환경에서 실습을 진행하겠습니다.
초기 환경 설정까지 시간이 걸릴 수 있으니 잠시 기다려 주시기 바랍니다.
(Cluster 환경에서 실습을 원하신다면, https://www.katacoda.com/tfogo/scenarios/k8s 에서 학습해 볼 수 있습니다.)

현재 kubernetes 환경의 상태를 확인하기 위해서는,

`kubectl cluster-info`{{execute}}

`kubectl get nodes`{{execute}}

`kubectl get pods -A`{{execute}}

를 각각 실행시켜 보시면 됩니다.

Status가 Ready와 Running으로 되어 있다면 kubernetes가 정상적으로 구동 중입니다.

kubernetes의 최소 단위는 POD 이며, POD의 Replica 개수를 지정하는 것이 ReplicaSet, 그리고 ReplicaSet의 배포 및 롤백과 같이 History를 포함하는 것이 Deployment 입니다.

## POD 생성
우선 가장 기본 단위인 POD를 생성하여 보겠습니다.

첫번째 실습을 위해 디렉토리를 이동합니다.

`cd /root/lab`{{execute}}

lab 디렉토리에는 사전에 만들어 놓은 yaml 파일이 세개가 있습니다.
이중 Pod를 생성하는 yaml은 pod.yaml 입니다.

다음을 선택하여 에디터를 통해 파일을 열거나 `/root/lab/pod.yaml`{{open}} , `vi pod.yaml`{{execute}} 를 통해 vi를 사용하셔도 됩니다.

Manifest를 살펴보면, Kind 에는 Object 종류, 그리고 metadata 에는 이름과 Label을 지정하도록 되어 있습니다.
Spec 에는 Pod에 생성될 container의 spec을 지정하도록 되어 있습니다.
containers(복수)로 되어 있는 것을 보면 알 수 있듯, 다수의 contianer를 지정하여 하나의 Pod에 여러개의 Container가 실행될 수 있도록 할 수 있습니다.
여기서는 nginx 이미지를 지정하였으며, 포트는 80을 사용하도록 지정하였습니다.

yaml 파일을 통해 object를 생성하는 방법은, kubectl create -f "yaml 파일명" 입니다.
또 apply 도 사용할 수 있는데, apply는 기존에 동일한 이름의 object가 없다면, create를, 동일한 이름의 object가 없다면 replace를 시켜줍니다.
apply로 yaml 파일을 통해 object를 생성해 보겠습니다.

`kubectl apply -f pod.yaml`{{execute}}

명령을 실행 시키면, "pod/my-nginx created" 라고 출력되면서 pod 이 만들어집니다.

`kubectl get pods`{{execute}} 를 통해 생성된 Pod을 확인할 수 있습니다.


