#!/bin/bash

# VPS'te uploads sorununu kesin çözüm

set -e

echo "=========================================="
echo "Uploads Sorunu Kesin Çözüm"
echo "=========================================="

cd /var/www/campscape

echo ""
echo "1. Git pull..."
git stash
git pull origin main

echo ""
echo "2. Backend build ve restart..."
cd server
npm run build
pm2 restart campscape-backend
cd ..

echo ""
echo "3. Uploads dizinini kontrol et..."
# Backend'in çalıştığı dizini PM2'den al
BACKEND_CWD=$(pm2 info campscape-backend 2>/dev/null | grep "cwd" | awk '{print $2}' || echo "/var/www/campscape/server")
UPLOADS_DIR="$BACKEND_CWD/uploads"

echo "Backend CWD: $BACKEND_CWD"
echo "Uploads dizini: $UPLOADS_DIR"

# Uploads dizinini oluştur
sudo mkdir -p "$UPLOADS_DIR"
sudo mkdir -p /var/www/campscape/server/uploads

# İzinleri düzelt
sudo chown -R www-data:www-data "$UPLOADS_DIR"
sudo chown -R www-data:www-data /var/www/campscape/server/uploads
sudo chmod -R 755 "$UPLOADS_DIR"
sudo chmod -R 755 /var/www/campscape/server/uploads

echo "✅ Uploads dizinleri hazır"

echo ""
echo "4. Nginx konfigürasyonunu güncelle..."

# SSL kontrolü
if [ -f "/etc/letsencrypt/live/sadece1deneme.com/fullchain.pem" ]; then
    CONFIG_FILE="nginx-campscape-ssl.config.conf"
else
    CONFIG_FILE="nginx-campscape-config.conf"
fi

# Nginx konfigürasyonunu kopyala
sudo cp "$CONFIG_FILE" /etc/nginx/sites-available/campscape

# Uploads dizinini Nginx konfigürasyonuna ekle (hem backend CWD hem de server/uploads)
sudo sed -i "s|alias /var/www/campscape/server/uploads/;|alias $UPLOADS_DIR/;|g" /etc/nginx/sites-available/campscape

# Nginx test
sudo nginx -t

if [ $? -eq 0 ]; then
    sudo systemctl reload nginx
    echo "✅ Nginx güncellendi"
else
    echo "❌ Nginx test hatası!"
    exit 1
fi

echo ""
echo "5. Backend .env kontrolü..."
cd server
if [ -f ".env" ]; then
    if ! grep -q "UPLOAD_DIR" .env; then
        echo "UPLOAD_DIR=./uploads" >> .env
    fi
else
    if [ -f "env.example.txt" ]; then
        cp env.example.txt .env
        echo "UPLOAD_DIR=./uploads" >> .env
    fi
fi
cd ..

echo ""
echo "6. Test: Uploads dizinindeki dosyaları listele..."
ls -la "$UPLOADS_DIR" | head -10 || echo "Dizin boş veya yok"
ls -la /var/www/campscape/server/uploads | head -10 || echo "Dizin boş veya yok"

echo ""
echo "=========================================="
echo "✅ Düzeltme tamamlandı!"
echo "=========================================="
echo ""
echo "Kontrol edilenler:"
echo "- Backend CWD: $BACKEND_CWD"
echo "- Uploads dizini: $UPLOADS_DIR"
echo "- Nginx konfigürasyonu güncellendi"
echo "- Backend yeniden başlatıldı"
echo ""
echo "Eğer hala 404 alıyorsanız:"
echo "1. Dosyanın gerçekten yüklendiğini kontrol edin: ls -la $UPLOADS_DIR"
echo "2. Nginx loglarını kontrol edin: sudo tail -f /var/log/nginx/campscape-error.log"

