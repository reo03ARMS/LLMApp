#!/bin/sh

# DBが起動するまで待機（MySQL用）
echo "Waiting for MySQL..."
while ! nc -z db 3306; do
  sleep 1
done
echo "MySQL started"

# マイグレーションフラグファイルがなければ実行
if [ ! -f /app/.migrated ]; then
  echo "== 初回マイグレーション実行 =="
  python manage.py migrate && touch /app/.migrated
else
  echo "== 既にマイグレーション済み =="
fi

# サーバー起動
exec gunicorn LLMAPP.wsgi:application --bind 0.0.0.0:8000
