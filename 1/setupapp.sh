#!/bin/bash

# 旧データを削除する
sudo rm -rf web/app

# docker-compose.yml で書かれたサービスのコンテナ、イメージ、ネットワークを削除する
docker-compose down --rmi all --volumes

# 環境を削除が目的の場合は、下記「exit 0」を有効にする
# exit 0

# 必須ディレクトリを作成する
sudo mkdir -p web/app

# entrypoint.sh を配置する
sudo cp ./web/assets/entrypoint.sh ./web/app/

# Dockerイメージビルドを行う. 
docker-compose build

# Docker コンテナ起動を行う. 
docker-compose up -d

# 起動完了を待つ. (== entrypoint.sh の成功を待つ)
sleep 2

# manage.py が作成されていなければ Django のプロジェクト作成に失敗したとみなす
test ! -f ./web/app/manage.py && {
  echo "ERROR: Django のプロジェクト作成に失敗した"
  exit 2
}

# コンテナ内でのマイグレーション終了を待つ.
sleep 4

# 「Django管理サイト」の管理者アカウントを作成する. (ID「admin」, PW「admin」とする)
docker-compose exec web bash -c "python manage.py makemigrations"
docker-compose exec web bash -c "python manage.py migrate auth"
docker-compose exec web bash -c "python manage.py migrate"
docker-compose exec web bash -c "echo \"from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'admin')\" | python manage.py shell"

# Django を再起動する
docker-compose restart web

