# Frontend Validation Debug Guide

## Browser Console'da Validation Hatalarını Görmek

1. **Browser'ı açın** (F12 veya Ctrl+Shift+I)
2. **Console sekmesine** gidin
3. **Network sekmesine** gidin
4. **Ürün eklemeyi deneyin**
5. **Network sekmesinde** `/api/gear` isteğini bulun
6. **Response** sekmesine tıklayın
7. **Hata detaylarını** kopyalayın

## Console'da Göreceğiniz Mesajlar

Eğer API interceptor düzgün çalışıyorsa, console'da şunları göreceksiniz:

```
Validation errors: [
  { field: 'category_id', message: 'Category ID must be a valid UUID' },
  { field: 'price_per_day', message: 'Price per day is required' },
  ...
]
```

## Manuel Test için Browser Console'da Çalıştırın

```javascript
// FormData oluştur
const formData = new FormData();
formData.append('name', 'Test Ürün');
formData.append('description', 'Bu bir test açıklamasıdır ve yeterince uzundur');
formData.append('category_id', '51aa1146-7491-434b-8165-3d65a6af5ce2');
formData.append('price_per_day', '100');
formData.append('status', 'for-sale');
formData.append('image_0', 'https://example.com/image.jpg');

// Token al
const token = JSON.parse(localStorage.getItem('auth-storage'))?.state?.token;

// İstek gönder
fetch('/api/gear', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${token}`
  },
  body: formData
})
.then(res => res.json())
.then(data => {
  console.log('Success:', data);
})
.catch(error => {
  console.error('Error:', error);
});
```

## Network Tab'de Response'u İnceleme

1. Network sekmesinde `/api/gear` isteğini bulun
2. İsteğe tıklayın
3. **Response** sekmesine gidin
4. Şu formatta bir hata göreceksiniz:

```json
{
  "success": false,
  "message": "Validation error",
  "errors": [
    {
      "field": "category_id",
      "message": "Category ID must be a valid UUID"
    },
    {
      "field": "price_per_day",
      "message": "Price per day is required"
    }
  ]
}
```

Bu hataları kopyalayıp paylaşın!


