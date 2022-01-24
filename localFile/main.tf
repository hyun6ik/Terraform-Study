provider "local" {
}

resource "local_file" "foo" {
  # ${path.module} : 해당 파일이 위치한 디렉토리 경로
  # main.tf 파일이 위치한 디렉토리에 "Hello World!" 라는 내용을 가진 foo.txt 파일을 생성한다.
  content = "Hello World!"
  filename = "${path.module}/foo.txt"
}

# 데이터를 읽을 용도
data "local_file" "bar" {
  filename = "${path.module}/bar.txt"
}

# 데이터를 출력
# file_bar 라는 Object 생성
output "file_bar" {
  value = data.local_file.bar
}