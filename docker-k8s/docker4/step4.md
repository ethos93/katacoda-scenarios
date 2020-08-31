## Python 참고

Python으로 Web Application을 작성하는 방법은 아래 Link를 참고하시기 바랍니다.

https://webpy.org/cookbook/helloworld

Python3 에서 web.py 라는 모듈을 사용하는 예이며, django나 flask 를 사용하셔도 상관없습니다.
web.py를 import 하기 위해서는, pip를 통해 web.py 모듈을 설치합니다.
(pip install web.py)

app.py 및 Dockerfile을 생성 해 주어야 합니다.

vi 를 통해 직접 파일을 생성, 편집하시거나, 아래 명령을 통해 file을 생성한 뒤에 Editor를 통해 편집하실 수 있습니다.

`touch app.py`{{execute}}
`touch Dockerfile`{{execute}}

Python에서 환경변수값을 읽어오는 방법은, import os를 하시고 os.environ['변수명'] 를 사용하시면 됩니다.
