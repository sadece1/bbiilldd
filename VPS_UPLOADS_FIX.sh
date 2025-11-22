#!/bin/bash

# VPS'te uploads dizini ve Nginx konfigürasyonunu düzelt

set -e

echo "=========================================="
echo "Uploads Dizini ve Nginx Düzeltmesi"
echo "=========================================="

# Frontend dizinine git
cd /var/www/campscape

echo ""
echo "1. Git'ten son değişiklikleri çekiyorum..."
git stash
git pull origin main

echo ""
echo "2. Backend uploads dizinini kontrol ediyorum..."

# Backend dizinine git
cd /var/www/campscape/server

# Backend'in çalıştığı dizini kontrol et (PM2'den)
BACKEND_DIR=$(pm2 info campscape-backend | grep "cwd" | awk '{print $2}' || echo "/var/www/campscape/server")

echo "Backend çalışma dizini: $BACKEND_DIR"

# Uploads dizinini kontrol et
UPLOADS_DIR="$BACKEND_DIR/uploads"

if [ ! -d "$UPLOADS_DIR" ]; then
    echo "Uploads dizini yok, oluşturuluyor: $UPLOADS_DIR"
    sudo mkdir -p "$UPLOADS_DIR"
    sudo chown -R www-data:www-data "$UPLOADS_DIR"
    sudo chmod -R 755 "$UPLOADS_DIR"
    echo "✅ Uploads dizini oluşturuldu!"
else
    echo "✅ Uploads dizini mevcut: $UPLOADS_DIR"
    # İzinleri kontrol et ve düzelt
    sudo chown -R www-data:www-data "$UPLOADS_DIR"
    sudo chmod -R 755 "$UPLOADS_DIR"
    echo "✅ İzinler güncellendi!"
fi

# Alternatif olarak server/uploads dizinini de kontrol et
if [ ! -d "/var/www/campscape/server/uploads" ]; then
    echo "Alternatif uploads dizini oluşturuluyor..."
    sudo mkdir -p /var/www/campscape/server/uploads
    sudo chown -R www-data:www-data /var/www/campscape/server/uploads
    sudo chmod -R 755 /var/www/campscape/server/uploads
fi

echo ""
echo "3. Nginx konfigürasyonunu güncelliyorum..."

cd /var/www/campscape

# SSL durumunu kontrol et
if [ -f "/etc/letsencrypt/live/sadece1deneme.com/fullchain.pem" ]; then
    echo "SSL sertifikası bulundu, SSL konfigürasyonu kullanılıyor..."
    CONFIG_FILE="nginx-campscape-ssl.config.conf"
else
    echo "SSL sertifikası bulunamadı, HTTP konfigürasyonu kullanılıyor..."
    CONFIG_FILE="nginx-campscape-config.conf"
fi

# Nginx konfigürasyonunu güncelle
if [ -f "$CONFIG_FILE" ]; then
    echo "Nginx konfigürasyonunu kopyalıyorum..."
    sudo cp "$CONFIG_FILE" /etc/nginx/sites-available/campscape
    
    # Nginx konfigürasyonunda uploads dizinini kontrol et
    echo "Nginx konfigürasyonunda uploads dizini kontrol ediliyor..."
    
    # Backend dizinini Nginx konfigürasyonuna ekle
    sudo sed -i "s|alias /var/www/campscape/server/uploads/;|alias $UPLOADS_DIR/;|g" /etc/nginx/sites-available/campscape
    
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
echo "4. Backend .env dosyasını kontrol ediyorum..."

cd /var/www/campscape/server

if [ -f ".env" ]; then
    # UPLOAD_DIR'i kontrol et
    if ! grep -q "UPLOAD_DIR" .env; then
        echo "UPLOAD_DIR .env dosyasına ekleniyor..."
        echo "UPLOAD_DIR=./uploads" >> .env
    fi
    
    # UPLOAD_DIR değerini kontrol et
    CURRENT_UPLOAD_DIR=$(grep "UPLOAD_DIR" .env | cut -d '=' -f2 | tr -d ' ')
    echo "Mevcut UPLOAD_DIR: $CURRENT_UPLOAD_DIR"
    
    # Backend'i yeniden başlat
    echo "Backend yeniden başlatılıyor..."
    pm2 restart campscape-backend
    echo "✅ Backend yeniden başlatıldı!"
else
    echo "⚠️  .env dosyası bulunamadı, oluşturuluyor..."
    if [ -f "env.example.txt" ]; then
        cp env.example.txt .env
        echo "UPLOAD_DIR=./uploads" >> .env
        echo "✅ .env dosyası oluşturuldu!"
    fi
fi

echo ""
echo "=========================================="
echo "✅ Uploads dizini ve Nginx düzeltmesi tamamlandı!"
echo "=========================================="
echo ""
echo "Kontrol edilenler:"
echo "- Uploads dizini: $UPLOADS_DIR"
echo "- Nginx konfigürasyonu güncellendi"
echo "- Backend yeniden başlatıldı"
echo ""
echo "Test için:"
echo "1. Bir resim yükleyin"
echo "2. /api/uploads/[dosya-adı] URL'sini kontrol edin"

