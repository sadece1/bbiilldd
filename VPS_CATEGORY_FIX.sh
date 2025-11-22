#!/bin/bash

# VPS'te kategori filtreleme düzeltmesini uygula
# Bu script CategoryPage.tsx'teki kategori filtreleme iyileştirmelerini uygular

set -e

echo "=========================================="
echo "Kategori Filtreleme Düzeltmesi Uygulanıyor"
echo "=========================================="

# Frontend dizinine git
cd /var/www/campscape

echo ""
echo "1. Git'ten son değişiklikleri çekiyorum..."
git pull origin main

echo ""
echo "2. Frontend bağımlılıklarını kontrol ediyorum..."
npm install

echo ""
echo "3. Frontend'i build ediyorum..."
npm run build

echo ""
echo "4. Build tamamlandı!"
echo ""
echo "=========================================="
echo "✅ Kategori filtreleme düzeltmesi uygulandı!"
echo "=========================================="
echo ""
echo "Değişiklikler:"
echo "- Backend UUID'ler doğrudan slug'lara eşleştiriliyor"
echo "- Slug normalizasyonu eklendi (lowercase, trim)"
echo "- İsim bazlı eşleştirme eklendi (fallback)"
echo "- Gelişmiş debug loglama eklendi"
echo ""
echo "Tarayıcıyı yenileyin ve kategori sayfasını test edin."

