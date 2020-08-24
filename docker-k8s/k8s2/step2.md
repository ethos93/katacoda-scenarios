Kubernetes 에서 Deployment는 배포 전략을 지정할 수 있으며, Rollback도 가능하다고 앞서 언급하였습니다.

실재로 어떤 식으로 동작되는지에 대한 실습을 진행해 보도록 하겠습니다.

이전에 작성하였던 Deployment를 수정해 보도록하겠습니다.

에디터 탭에서 deployment.yaml을 선택하여 여시거나, `vi deployment.yaml`{{execute}} 를 통해 vi를 사용하셔도 됩니다.

strategy의 type이 RollingUpdate로 되어 있는 것을 확인할 수 있으며, 여기서 container 이미지의 version을 변경해 보도록 하겠습니다.

ethos93/go-httpd:v1 으로 되어 있는 부분을 ethos93/go-httpd:v2 로 tag만 v2로 변경한 뒤에 저장합니다.

이제 `kubectl apply -f deployment.yaml`{{execute}} 명령을 통해 Deployment 을 생성합니다.

명령을 실행 시키면, "deployment.apps/httpd-deployment configured" 라고 출력되면서 Deployment 가 수정됩니다.

이전에 생성한 debugging용 pod과 반복적으로 수행되는 curl 명령을 통해 Image의 버전이 바뀐것을 확인해 보도록 하겠습니다.
다음 명령을 실행하면, 0.5초에 한번씩 curl 명령을 통해 httpd-nodeport-service 를 호출합니다.

`while sleep 0.5; do kubectl exec -it curlpod -- curl httpd-nodeport-service; done`{{execute}}

응답메시지를 보면, v1으로 응답을 주던 것들이 점차 v2로 응답을 주는 것을 확인할 수 있습니다.

이 처럼 Deployment의 RollingUpdate는 서비스의 중단 없이 순차적으로 Pod의 Image를 변경하면서 Update를 진행하는 것을 확인할 수 있습니다.

Ctrl + C 를 눌러 curl 명령을 중단 시킵니다.

이제, 다시 Rollback을 수행해 보겠습니다.

`kubectl rollout history deployment httpd-deployment`{{execute}} 명령을 실행하면 배포 이력이 나타납니다.

`kubectl rollout history deployment httpd-deployment --revision=1`{{execute}} 과 같이 --revision= 옵션을 주면, 해당 Revision의 상세 내용이 나타납니다.

`kubectl rollout history deployment httpd-deployment --revision=2`{{execute}}

최초 배포가 Revision 1이고, 두번째로 v2 로 변경한 배포가 Revision 2 입니다. 따라서 현재가 Revision 2 상태입니다.

Rollback을 위해서 다음 명령을 실행하면, Revision 1로 돌아갈 수 있습니다.

`kubectl rollout undo deployment httpd-deployment --to-revision=1`{{execute}}

명령을 실행 시키면, "deployment.apps/httpd-deployment rolled back"와 함께 지정된 Revision으로 돌아가게 됩니다.

다시한번 curl 명령을 통해 v1로 Rollback이 잘 이루어 지는지 확인해 보겠습니다.

`while sleep 0.5; do kubectl exec -it curlpod -- curl httpd-nodeport-service; done`{{execute}}

역시 순차적으로 v1으로 변경이 되는 것을 확인할 수 있습니다.
