# Browser Cache Sorunu - Çözüm Rehberi

## 🔴 Sorun

Hard refresh (Ctrl+Shift+R) yapınca eski kod çalışıyor, ama gizli sekmede (incognito) sorun yok. Bu browser cache sorunudur.

## ✅ Çözümler

### 1. Tarayıcı Cache'ini Temizleme

#### Chrome/Edge:
1. `Ctrl+Shift+Delete` tuşlarına bas
2. "Cached images and files" seçeneğini işaretle
3. "Time range" → "All time" seç
4. "Clear data" butonuna tıkla

#### Firefox:
1. `Ctrl+Shift+Delete` tuşlarına bas
2. "Cache" seçeneğini işaretle
3. "Time range" → "Everything" seç
4. "Clear Now" butonuna tıkla

### 2. Developer Tools ile Cache Devre Dışı

#### Chrome DevTools:
1. `F12` tuşuna bas (Developer Tools aç)
2. Network sekmesine git
3. "Disable cache" checkbox'ını işaretle
4. Developer Tools açıkken sayfayı yenile

### 3. Hard Refresh (Cache Bypass)

- **Windows/Linux**: `Ctrl+Shift+R` veya `Ctrl+F5`
- **Mac**: `Cmd+Shift+R`

### 4. Application Tab'dan Cache Temizleme

#### Chrome:
1. `F12` → Application sekmesi
2. Storage → Clear site data
3. "Clear site data" butonuna tıkla

### 5. VPS'te Nginx Cache Headers Düzeltme

VPS'te şu komutları çalıştır:

```bash
cd /var/www/campscape
git pull origin main
chmod +x VPS_NGINX_FIX.sh
./VPS_NGINX_FIX.sh
```

Bu script HTML dosyalarının cache'lenmesini engelleyecek.

### 6. Vite Build Cache Temizleme

VPS'te:

```bash
cd /var/www/campscape
rm -rf node_modules/.vite
rm -rf dist
npm run build
```

## 🔍 Sorunun Tespiti

### Cache Sorunu Olduğunu Nasıl Anlarsınız?

1. **Gizli sekmede çalışıyor ama normal sekmede çalışmıyor** → Browser cache
2. **Hard refresh yapınca eski kod çalışıyor** → Service worker veya browser cache
3. **Network tab'de 304 Not Modified görüyorsunuz** → Cache sorunu

### Network Tab Kontrolü

1. `F12` → Network sekmesi
2. Sayfayı yenile
3. `index.html` dosyasına bak:
   - **200 OK** → Yeni dosya yüklendi (cache yok)
   - **304 Not Modified** → Cache'den geldi (sorun burada)
   - **200 (from disk cache)** → Browser cache'den geldi

## 🚀 Hızlı Çözüm

### Kullanıcılar İçin:
1. `Ctrl+Shift+Delete` → Cache temizle
2. Sayfayı yenile (`F5`)

### Geliştiriciler İçin:
1. Developer Tools açık (`F12`)
2. Network sekmesinde "Disable cache" işaretle
3. Sayfayı yenile

### VPS Yöneticileri İçin:
```bash
# Nginx config'i güncelle
cd /var/www/campscape
git pull origin main
./VPS_NGINX_FIX.sh

# Frontend'i yeniden build et
npm run build
```

## 📝 Nginx Cache Headers

Yeni config'te:
- **HTML dosyaları**: `Cache-Control: no-cache, no-store, must-revalidate`
- **Static assets (JS/CSS)**: `Cache-Control: public, immutable` (1 yıl)
- **Images**: `Cache-Control: public` (30 gün)

Bu sayede:
- HTML her zaman yeni yüklenir
- Static assets cache'lenir (performans için)
- Images cache'lenir

## ⚠️ Önemli Notlar

1. **Production'da**: Static assets cache'lenmeli (performans)
2. **Development'da**: Tüm cache devre dışı olmalı
3. **HTML dosyaları**: Hiçbir zaman cache'lenmemeli

## 🔗 İlgili Dosyalar

- `nginx-campscape-config.conf` - HTTP config
- `nginx-campscape-ssl.config.conf` - HTTPS config
- `VPS_NGINX_FIX.sh` - Otomatik düzeltme scripti

