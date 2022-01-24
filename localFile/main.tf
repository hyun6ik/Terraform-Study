provider "local" {
}

resource "local_file" "foo" {
  # ${path.module} : 해당 파일이 위치한 디렉토리 경로
  # main.tf 파일이 위치한 디렉토리에 "Hello World!" 라는 내용을 가진 foo.txt 파일을 생성한다.
  content = "Hello World!"
  filename = "${path.module}/foo.txt"
}
