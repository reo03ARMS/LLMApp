FROM python:3.12.7

# 必要パッケージのインストール（MySQL対応）
RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    build-essential \
    libssl-dev \
    libffi-dev \
    libmariadb-dev \
    dos2unix \
    netcat-openbsd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# エントリポイントシェルの追加と権限設定
COPY entrypoint.sh ./entrypoint.sh
RUN dos2unix ./entrypoint.sh && chmod +x ./entrypoint.sh

# アプリケーションコードをコピー
COPY . .

# デフォルトコマンド（entrypoint.sh を通じて起動）
ENTRYPOINT ["/app/entrypoint.sh"]

EXPOSE 8000

