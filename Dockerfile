FROM python:3.12.7

# 必要パッケージのインストール（MySQL対応）
RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    build-essential \
    libssl-dev \
    libffi-dev \
    libmariadb-dev \
    netcat-openbsd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# エントリポイントシェルの追加と権限設定
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# アプリケーションコードをコピー
COPY . .

EXPOSE 8000

CMD ["gunicorn", "LLMAPP.wsgi:application", "--bind", "0.0.0.0:8000"]
