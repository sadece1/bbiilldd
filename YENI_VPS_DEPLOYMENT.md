# 🚀 YENİ VPS DEPLOYMENT - sadece1deneme.com

## 📋 Bilgiler

- **Repository:** https://github.com/sadece1/bbiilldd.git
- **Domain:** sadece1deneme.com
- **VPS IP:** 31.97.216.176
- **SSH:** root@31.97.216.176

---

## ⚡ HIZLI DEPLOYMENT (10 Dakika)

### ADIM 1: SSH Bağlantısı

```bash
ssh root@31.97.216.176
```

**İlk bağlantı sorusu:**
```
Are you sure you want to continue connecting (yes/no)?
```
**Yazın:** `yes` → Enter

**Şifre girin** (görünmez)

---

### ADIM 2: Sistem Güncelleme

```bash
# Paket listelerini güncelle
sudo apt update

# Tüm paketleri güncelle
sudo apt upgrade -y

# Gereksiz paketleri temizle
sudo apt autoremove -y

# Sistemi yeniden başlat
sudo reboot
```

**1-2 dakika bekleyin**, sonra tekrar bağlanın:
```bash
ssh root@31.97.216.176
```

---

### ADIM 3: Proje Klonla

```bash
# /var/www dizinine git
cd /var/www

# Projeyi klonla
git clone https://github.com/sadece1/bbiilldd.git campscape

# Proje dizinine git
cd campscape

# Dosyaları kontrol et
ls -la
```

**Görmeli:**
- ubuntu-quick-deploy.sh ✅
- server/ ✅
- src/ ✅
- SIFIRDAN_DEPLOY_SON.md ✅

---

### ADIM 4: Otomatik Kurulum

```bash
# Script'i çalıştırılabilir yap
chmod +x ubuntu-quick-deploy.sh

# Script'i çalıştır
./ubuntu-quick-deploy.sh
```

---

### ADIM 5: Script Soruları

**Soru 1: Domain adınız**
```
Domain adınız (örn: example.com): sadece1deneme.com
```
**Yazın:** `sadece1deneme.com` → Enter

**Soru 2: MySQL root şifresi**
```
MySQL root şifresi (yeni kurulum için boş bırakabilirsiniz):
```
**Yazın:** *(Boş bırakın)* → Enter

**Soru 3: Database kullanıcı şifresi**
```
Database kullanıcı şifresi:
```
**Yazın:** `Sadece1DB2025!` → Enter
*(Bu şifreyi kaydedin!)*

**Soru 4: Admin email**
```
Admin email adresi:
```
**Yazın:** `admin@sadece1deneme.com` → Enter

**Soru 5: Devam onayı**
```
Devam etmek istiyor musunuz? (y/n):
```
**Yazın:** `y` → Enter

---

### ADIM 6: Otomatik Kurulum Süreci (~10 dakika)

Script şunları otomatik yapacak:

✅ **1. Sistem Güncelleme** (~1 dk)
```
============================================
1. SİSTEM GÜNCELLEMESİ
============================================
✅ Sistem güncellendi
```

✅ **2. Yazılım Kurulumu** (~3 dk)
```
============================================
2. GEREKLİ YAZILIMLARI KURMA
============================================
✅ Node.js v18.x.x kuruldu
✅ PM2 kuruldu
✅ Nginx kuruldu
✅ MySQL kuruldu
✅ Certbot kuruldu
```

✅ **3. Firewall** (~10 sn)
```
============================================
3. FIREWALL YAPILANDIRMASI
============================================
✅ Firewall yapılandırıldı
```

✅ **4. Database** (~30 sn)
```
============================================
4. MYSQL DATABASE OLUŞTURMA
============================================
✅ Database oluşturuldu
```

✅ **5. Backend Build** (~2 dk)
```
============================================
6. BACKEND DEPLOYMENT
============================================
📦 Backend dependencies yükleniyor...
📝 Backend .env dosyası oluşturuldu
🔨 Backend build ediliyor...
✅ Backend hazır
```

✅ **6. Frontend Build** (~2 dk)
```
============================================
7. FRONTEND DEPLOYMENT
============================================
📦 Frontend dependencies yükleniyor...
🔨 Frontend build ediliyor...
✅ Frontend hazır
```

✅ **7. Nginx Yapılandırması** (~10 sn)
```
============================================
8. NGINX YAPILANDIRMASI
============================================
✅ Nginx yapılandırıldı
```

✅ **8. PM2 Başlatma** (~10 sn)
```
============================================
9. PM2 İLE BACKEND BAŞLATMA
============================================
✅ Backend PM2 ile başlatıldı
```

---

### ADIM 7: SSL Kurulumu (Opsiyonel)

**ÖNEMLİ:** Önce domain DNS ayarlarını yapın!

**Hostinger/Domain Panel'den:**
- A kaydı: `@` → `31.97.216.176`
- A kaydı: `www` → `31.97.216.176`

**DNS yayılması 5-30 dakika sürer!**

**DNS'i test edin:**
```bash
nslookup sadece1deneme.com
# Çıktı: 31.97.216.176 görünmeli
```

**Script soracak:**
```
SSL kurmak istiyor musunuz? (y/n):
```

**DNS hazırsa:** `y` → Enter

**Certbot soruları:**
- Email: `admin@sadece1deneme.com`
- Terms: `A` (Agree)
- Share email: `N` (No)
- Redirect HTTP to HTTPS: `2` (Yes)

---

### ADIM 8: TAMAMLANDI! 🎉

```
============================================
✅ DEPLOYMENT TAMAMLANDI!
============================================

🧪 Backend test ediliyor...
✅ Backend çalışıyor!

═══════════════════════════════════════════
       🎉 CampScape Deployment Bilgileri
═══════════════════════════════════════════

🌐 Website: http://sadece1deneme.com
🔧 Backend API: http://sadece1deneme.com/api
🏥 Health Check: http://sadece1deneme.com/health

👤 Varsayılan Admin Giriş Bilgileri:
   Email: admin@campscape.com
   Şifre: Admin123!
   ÖNEMLİ: İlk girişte şifreyi değiştirin!
```

---

### ADIM 9: Test Edin

#### A) Backend Test
```bash
# Health check
curl http://localhost:3000/health

# Çıktı olmalı:
{"status":"ok","timestamp":"2025-11-21..."}
```

#### B) PM2 Status
```bash
pm2 status
```

**Görmeli:**
```
┌────┬────────────────────┬─────────┬─────────┬──────────┐
│ id │ name               │ mode    │ status  │ cpu      │
├────┼────────────────────┼─────────┼─────────┼──────────┤
│ 0  │ campscape-backend  │ fork    │ online  │ 0%       │
└────┴────────────────────┴─────────┴─────────┴──────────┘
```

**Kontrol:**
- ✅ status: **online**
- ✅ ↺: **0** (restart count)
- ❌ ↺: 15 (crash oluyor - sorun var!)

#### C) Backend Logları
```bash
pm2 logs campscape-backend --lines 20
```

**Görmeli:**
```
✅ Environment variables validated
🚀 Server is running on port 3000
Database connected successfully
```

**GÖRMEMELİ:**
```
❌ ECONNREFUSED ::1:3306
❌ Failed to start server
```

#### D) Tarayıcıda Test
```
http://sadece1deneme.com
```

**veya SSL kurduysan:**
```
https://sadece1deneme.com
```

---

### ADIM 10: Admin Panele Giriş

```
https://sadece1deneme.com/admin/login
```

**Giriş Bilgileri:**
- Email: `admin@campscape.com`
- Şifre: `Admin123!`

**İLK YAPILACAKLAR:**
1. **Profil** → **Şifre Değiştir** (zorunlu!)
2. **Email Güncelle** → `admin@sadece1deneme.com`
3. Site ayarlarını kontrol et

---

## 🔧 Yönetim Komutları

### Backend Yönetimi
```bash
# Backend restart
pm2 restart campscape-backend

# Backend logs
pm2 logs campscape-backend

# Backend stop
pm2 stop campscape-backend

# Backend start
pm2 start campscape-backend

# PM2 monitoring
pm2 monit

# Tüm process'leri listele
pm2 list
```

### Nginx Yönetimi
```bash
# Nginx reload (config değişikliklerinden sonra)
sudo systemctl reload nginx

# Nginx restart
sudo systemctl restart nginx

# Nginx status
sudo systemctl status nginx

# Nginx config test
sudo nginx -t

# Nginx logları
sudo tail -f /var/log/nginx/campscape-access.log
sudo tail -f /var/log/nginx/campscape-error.log
```

### MySQL Yönetimi
```bash
# MySQL'e bağlan
mysql -h 127.0.0.1 -u campscape_user -p
# Şifre: Sadece1DB2025!

# MySQL status
sudo systemctl status mysql

# MySQL restart
sudo systemctl restart mysql

# MySQL logları
sudo tail -f /var/log/mysql/error.log
```

### Sistem Monitoring
```bash
# Disk kullanımı
df -h

# Memory kullanımı
free -h

# CPU ve process'ler
htop

# Port dinleme kontrolü
sudo netstat -tlnp | grep -E ':(80|443|3000|3306)'
```

---

## 🆘 Sorun Giderme

### 1. Backend Çalışmıyor (Status: errored)

```bash
# Logları kontrol et
pm2 logs campscape-backend --lines 50

# Manuel başlatmayı dene
cd /var/www/campscape/server
node dist/server.js

# .env dosyasını kontrol et
cat .env | grep DB_HOST
# Çıktı: DB_HOST=127.0.0.1 olmalı ✅
```

### 2. MySQL Bağlantı Hatası

**Hata:** `ECONNREFUSED ::1:3306`

```bash
# MySQL çalışıyor mu?
sudo systemctl status mysql

# MySQL'i başlat
sudo systemctl start mysql

# .env'de 127.0.0.1 var mı kontrol et
cat /var/www/campscape/server/.env | grep DB_HOST

# Yoksa düzelt
cd /var/www/campscape/server
sed -i 's/DB_HOST=localhost/DB_HOST=127.0.0.1/g' .env

# PM2 restart
pm2 restart campscape-backend
```

### 3. Frontend 404 Hatası

```bash
# Nginx config test
sudo nginx -t

# Frontend dosyaları var mı?
ls -la /var/www/campscape/frontend/

# Nginx'i restart et
sudo systemctl restart nginx
```

### 4. SSL Sertifika Hatası

```bash
# Domain DNS'i kontrol et
nslookup sadece1deneme.com

# Certbot logları
sudo tail -f /var/log/letsencrypt/letsencrypt.log

# Manuel SSL kurulumu
sudo certbot --nginx -d sadece1deneme.com -d www.sadece1deneme.com
```

---

## 📊 Başarı Kontrol Listesi

Deployment sonrası kontrol edin:

- [ ] `pm2 status` → **online** ✅
- [ ] `pm2 status` → **↺ 0** ✅
- [ ] `curl http://localhost:3000/health` → `{"status":"ok"}` ✅
- [ ] `pm2 logs campscape-backend` → "Database connected" ✅
- [ ] Backend loglarında **ECONNREFUSED yok** ✅
- [ ] `https://sadece1deneme.com` → Ana sayfa yükleniyor ✅
- [ ] SSL aktif (yeşil kilit) ✅
- [ ] `https://sadece1deneme.com/admin/login` → Giriş yapılıyor ✅
- [ ] Admin şifresi değiştirildi ✅

---

## 🔄 Güncelleme (Update)

Proje güncellemesi yapacağınızda:

```bash
# SSH ile bağlan
ssh root@31.97.216.176

# Proje dizinine git
cd /var/www/campscape

# Son değişiklikleri çek
git pull origin main

# Backend güncelle
cd server
npm install
npm run build
pm2 restart campscape-backend

# Frontend güncelle
cd ..
npm install
npm run build
sudo cp -r dist/* /var/www/campscape/frontend/

# Nginx reload
sudo systemctl reload nginx

# Database migration (gerekirse)
cd server
npm run db:migrate

# Test et
pm2 logs campscape-backend --lines 10
curl http://localhost:3000/health
```

---

## 📝 Önemli Bilgiler

### Kayıt Edilen Şifreler
- **Database Şifresi:** `Sadece1DB2025!`
- **Admin Email:** `admin@sadece1deneme.com`
- **Admin Şifre (ilk):** `Admin123!` (değiştirin!)

### Dosya Konumları
- **Proje:** `/var/www/campscape/`
- **Backend:** `/var/www/campscape/server/`
- **Frontend:** `/var/www/campscape/frontend/`
- **Backend .env:** `/var/www/campscape/server/.env`
- **Nginx config:** `/etc/nginx/sites-available/campscape`
- **SSL sertifika:** `/etc/letsencrypt/live/sadece1deneme.com/`

### Portlar
- **Backend:** 3000
- **Frontend (Nginx):** 80, 443
- **MySQL:** 3306

---

## 🎉 BAŞARILAR!

Artık **sadece1deneme.com** canlıda ve çalışıyor!

**Repository:** https://github.com/sadece1/bbiilldd.git
**Website:** https://sadece1deneme.com
**Admin:** https://sadece1deneme.com/admin

---

**Son Güncelleme:** 2025-11-21

