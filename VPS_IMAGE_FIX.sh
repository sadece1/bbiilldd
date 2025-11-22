#!/bin/bash

# VPS'te resim 404 hatalarını düzelt
# Bu script Nginx konfigürasyonunu güncelleyip resimlerin doğru serve edilmesini sağlar

set -e

echo "=========================================="
echo "Resim 404 Hatalarını Düzeltiyorum"
echo "=========================================="

# Frontend dizinine git
cd /var/www/campscape

echo ""
echo "1. Git'ten son değişiklikleri çekiyorum..."
git stash
git pull origin main

echo ""
echo "2. Nginx konfigürasyonunu kontrol ediyorum..."

# SSL durumunu kontrol et
if [ -f "/etc/letsencrypt/live/sadece1deneme.com/fullchain.pem" ]; then
    echo "SSL sertifikası bulundu, SSL konfigürasyonu kullanılıyor..."
    NGINX_CONFIG="/etc/nginx/sites-available/campscape"
    CONFIG_FILE="nginx-campscape-ssl.config.conf"
else
    echo "SSL sertifikası bulunamadı, HTTP konfigürasyonu kullanılıyor..."
    NGINX_CONFIG="/etc/nginx/sites-available/campscape"
    CONFIG_FILE="nginx-campscape-config.conf"
fi

# Nginx konfigürasyonunu güncelle
if [ -f "$CONFIG_FILE" ]; then
    echo "Nginx konfigürasyonunu kopyalıyorum..."
    sudo cp "$CONFIG_FILE" "$NGINX_CONFIG"
    
    echo "Nginx konfigürasyonunu test ediyorum..."
    sudo nginx -t
    
    if [ $? -eq 0 ]; then
        echo "Nginx konfigürasyonu geçerli, yeniden yükleniyor..."
        sudo systemctl reload nginx
        echo "✅ Nginx başarıyla yeniden yüklendi!"
    else
        echo "❌ Nginx konfigürasyon hatası! Lütfen kontrol edin."
        exit 1
    fi
else
    echo "❌ Konfigürasyon dosyası bulunamadı: $CONFIG_FILE"
    exit 1
fi

echo ""
echo "3. Uploads dizinini kontrol ediyorum..."
if [ ! -d "/var/www/campscape/server/uploads" ]; then
    echo "Uploads dizini yok, oluşturuluyor..."
    sudo mkdir -p /var/www/campscape/server/uploads
    sudo chown -R www-data:www-data /var/www/campscape/server/uploads
    sudo chmod -R 755 /var/www/campscape/server/uploads
    echo "✅ Uploads dizini oluşturuldu!"
else
    echo "✅ Uploads dizini mevcut"
fi

echo ""
echo "4. Frontend'i build ediyorum..."
npm install
npm run build

echo ""
echo "=========================================="
echo "✅ Resim 404 hataları düzeltildi!"
echo "=========================================="
echo ""
echo "Yapılan değişiklikler:"
echo "- Nginx'te /api/uploads/ location eklendi"
echo "- Uploads dizini kontrol edildi"
echo "- Frontend build edildi"
echo ""
echo "Artık /api/uploads/ altındaki resimler doğru şekilde serve edilecek."

