#!/bin/sh

# ./manage.py が存在しなければ初期セットアップ未とみなす
test ! -f manage.py && { 
  # プロジェクトを作成する (config/ と manage.py が作成される)
  django-admin.py startproject config .
  # マイグレーションを実施する
  python manage.py makemigrations
  python manage.py migrate
  # 物理ホストから config/. 以下を編集できるように権限を付与する
  chmod -R 777 config
}
exec "$@"

