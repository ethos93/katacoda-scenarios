대부분의 Application 은 환경에 따라 서로 다른 설정값을 사용할 수 있도록 변수로 처리하여 개발을 하게 됩니다.
예를 들어, Database의 IP/Port, Username, Password 와 같이 개발계, 검증계, 운영계 별로 다른 값을 가지게 되는 경우가 대부분 입니다.

이러한 변수값들을 Spring에서는 application.properties 나 application.yaml 로 처리기도 합니다.
Spring은 profile 별로 변수값들을 서로 다르게 처리 할 수 있도록 제공합니다.

Kubenetes는 이러한 변수들을 ConfigMap과 Secret 을 통해 관리 할 수 있습니다.

환경(Namespace) 별로 ConfigMap이나 Secret을 생성해 놓으면, 해당 환경에서 구동되는 Pod들은 각각의 환경에서 정의해 놓은 변수값을 사용할 수 있도록 하는 것입니다.

ConfigMap이나 Secret에서 정의한 값을 Pod로 넘기는 방법에는 크게 두가지가 있습니다.

. 정의해놓은 값을 Pod의 환경 변수로 넘기는 방법

. 정의해놓은 값을 Pod의 디스크 볼륨으로 마운트하는 방법
