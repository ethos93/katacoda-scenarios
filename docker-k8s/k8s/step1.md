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

