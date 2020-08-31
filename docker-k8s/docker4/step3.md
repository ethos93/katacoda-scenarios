## node.js 참고

node.js로 Web Application을 작성하는 방법은 아래 Link를 참고하시기 바랍니다.

https://nodejs.org/en/docs/guides/getting-started-guide/

Node 버전은 12를 사용하며,

app.js 및 Dockerfile을 생성 해 주어야 합니다.

vi 를 통해 직접 파일을 생성, 편집하시거나, 아래 명령을 통해 file을 생성한 뒤에 Editor를 통해 편집하실 수 있습니다.

`touch app.js`{{execute}}
`touch Dockerfile`{{execute}}

node.js에서 환경변수값을 읽어오는 방법은, process.env.변수명 를 사용하시면 됩니다.
