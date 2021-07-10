FROM python:3.8.3-slim-buster 

## プロキシサーバを使う場合
# ENV http_proxy="http://proxy.co.jp:8080"	
# ENV https_proxy="http://proxy.co.jp:8080"

# コンテナ内に /usr/src/app を作成して且つ移動する
WORKDIR /usr/src/app
 
# Python に関する環境変数
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
 
# 時刻を日本に合わせる
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# pip を更新したうえで必要なパッケージをインストールする
RUN pip install --upgrade pip==21.0.1
COPY assets/requirements.txt .
RUN pip install -r requirements.txt
 
# entrypoint.sh の中で 初回の処理 (startproject, マイグレーション, createsuperuser) を実施する
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]

