# HizmetSepetim – Flutter Client (Open Source)

🚀 **HizmetSepetim**, hizmet verenler ile kullanıcıları buluşturmayı amaçlayan bir platformdur.
Bu repository, HizmetSepetim'in **Flutter ile geliştirilmiş istemci (client) uygulamasını** içerir.

> ⚠️ **Önemli:**
> Bu repo **yalnızca Flutter client uygulamasını** kapsar.
> Backend, veritabanı, canlı API servisleri ve marka altyapısı bu repoya dahil değildir.

---

## 🎯 Projenin Amacı

Bu Flutter uygulaması:

- Flutter ile **gerçek bir ürünün** nasıl geliştirildiğini göstermek
- iOS sürümü ve uzun vadede **Android + iOS birleşik client** için temel oluşturmak
- Açık kaynak üzerinden **Flutter mimarisi, UI/UX ve API entegrasyonu** sergilemek
- Geliştirici Flutter bilgisini ileri seviyeye taşımak

Amaç **demo yapmak değil**, gerçek dünyada kullanılan bir yapıyı açık kaynak olarak geliştirmektir.

---

## 📱 Özellikler

### Kullanıcı Yönetimi
- ✅ Kullanıcı kaydı ve girişi (JWT token tabanlı)
- ✅ Profil görüntüleme ve düzenleme
- ✅ Oturum yönetimi (token ve kullanıcı bilgileri kalıcı saklama)
- ✅ Auth state yönetimi (ValueNotifier ile global durum)

### Ürün ve Kategori Sistemi
- ✅ Kategoriler listesi
- ✅ Kategoriye göre ürün listeleme
- ✅ Ürün detay sayfası (açıklama, fiyat, satıcı bilgileri, yorumlar)
- ✅ Ürün arama özelliği

### Sipariş ve Randevu Yönetimi
- ✅ Ürün seçimi ve ek hizmet ekleme
- ✅ Adres yönetimi (ekleme, listeleme, seçim)
- ✅ Randevu tarih/saat seçimi
- ✅ Sipariş oluşturma
- ✅ Randevu listesi görüntüleme (Booking Screen)
- ✅ Randevu durumu takibi (Bekliyor, Onaylandı, Tamamlandı, İptal)

### Ödeme Sistemi
- ✅ **Cüzdan (Wallet) entegrasyonu**
  - Cüzdan bakiyesi görüntüleme
  - Cüzdan ile ödeme yapma
  - Kısmi ödeme desteği (cüzdan + kart karışık ödeme)
  - Otomatik bakiye kontrolü
- ✅ **Kart bilgileri formu** (şu an opsiyonel, görsel amaçlı)
- ✅ Ödeme yöntemi seçimi (wallet, card, mixed)
- ✅ Ödeme dağılımı gösterimi (cüzdan + kart breakdown)

### Cüzdan (Wallet) Özellikleri
- ✅ Bakiye görüntüleme
- ✅ İşlem geçmişi (son 10 işlem)
- ✅ Promosyon kodu kullanımı (promo code redemption)
- ✅ İşlem tipleri: `promo_code`, `order_payment`
- ✅ Pull-to-refresh desteği

### UI/UX Özellikleri
- ✅ Modern gradient bottom navigation bar
- ✅ Card-based tasarım (gölgeli kartlar)
- ✅ Loading ve error state yönetimi
- ✅ Empty state gösterimleri
- ✅ Responsive layout

---

## 🧠 Genel Mimari

### Teknoloji Stack

- **Framework:** Flutter SDK ^3.10.4
- **HTTP Client:** Dio ^5.9.0
- **Güvenli Depolama:** flutter_secure_storage ^9.0.0 (JWT token)
- **Local Storage:** shared_preferences ^2.2.2 (User session)
- **State Management:**
  - `setState` (local state)
  - `ValueNotifier` (global auth state)
  - Provider ^6.0.5 (bağımlılık olarak mevcut, şu an kullanılmıyor)

### Proje Yapısı

```
lib/
├── main.dart                 # Uygulama giriş noktası
├── appData/
│   └── api_service.dart      # API servisleri ve data modelleri
├── gui/
│   ├── main_layout.dart      # Ana layout (bottom navigation)
│   ├── home_screen.dart      # Ana sayfa (kategoriler & ürünler)
│   ├── product_detail_screen.dart
│   ├── checkout_screen.dart  # Adres seçimi
│   ├── payment_screen.dart   # Ödeme ekranı
│   ├── booking_screen.dart   # Randevular listesi
│   ├── wallet_screen.dart    # Cüzdan ekranı
│   ├── profile_screen.dart   # Profil görüntüleme
│   ├── editprofile_screen.dart
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── profile_gate.dart     # Auth guard
│   └── widgets/              # Özel widget'lar
│       ├── payment_wallet.dart
│       ├── payment_addons.dart
│       └── payment_datetime.dart
├── utils/
│   ├── auth_state.dart       # Global auth state
│   ├── token_store.dart      # JWT token yönetimi
│   └── user_store.dart       # Kullanıcı bilgileri yönetimi
└── theme/
    └── colors.dart           # Tema renkleri
```

### API Entegrasyonu

**Base URL:** `http://92.249.61.58:8080/`

**Endpoints:**
- `GET /get_categories` - Kategori listesi
- `GET /get_products?category_id={id}` - Ürün listesi
- `GET /get_product_detail?id={id}` - Ürün detayı
- `POST /register` - Kullanıcı kaydı
- `POST /login` - Giriş
- `GET /get_addresses` - Adres listesi
- `POST /add_address` - Adres ekleme
- `GET /get_addons` - Ek hizmetler listesi
- `POST /create_order_with_payment` - Sipariş oluşturma (cüzdan + kart desteği)
- `GET /get_orders` - Randevu/sipariş listesi
- `GET /wallet/balance` - Cüzdan bakiyesi
- `GET /wallet/transactions` - Cüzdan işlem geçmişi
- `POST /redeem_promo` - Promosyon kodu kullanımı
- `POST /update_profile` - Profil güncelleme

**Authentication:**
- JWT Bearer token tabanlı
- Token `flutter_secure_storage` ile güvenli saklanır
- Her istekte `Authorization: Bearer {token}` header'ı otomatik eklenir

### State Management

- **Local State:** `StatefulWidget` ve `setState` kullanımı
- **Global State:**
  - `ValueNotifier<bool> authState` - Giriş durumu
  - `ValueNotifier<UserSession?> userSession` - Kullanıcı bilgileri
- **Persistence:**
  - JWT token → `flutter_secure_storage`
  - User session → `shared_preferences`

### Tasarım Sistemi

**Renk Paleti:**
- Primary: `#2A9D8F` (Teal)
- Background: `#F2F6F5` (Light gray)
- Text Dark: `#0F172A`
- Text Soft: `#64748B`

**UI Özellikleri:**
- Material Design
- Gradient bottom navigation bar
- Card-based layout (border-radius: 20px)
- Subtle shadows
- Smooth animations

---

## 📱 Platform Desteği

| Platform | Durum |
|----------|-------|
| Android | ✅ Geliştiriliyor |
| iOS | 🎯 Hedef platform |
| Web | ❌ Şu an hedef değil |
| Windows | ⚠️ Flutter default desteği (test edilmemiş) |
| Linux | ⚠️ Flutter default desteği (test edilmemiş) |
| macOS | ⚠️ Flutter default desteği (test edilmemiş) |

> ℹ️ Android için **ilk Play Store sürümü native Kotlin (Jetpack Compose)** ile çıkacaktır.
> Flutter bu projede **iOS ve uzun vadeli unified client** hedefiyle geliştirilmektedir.

---

## 🚀 Kurulum ve Çalıştırma

### Gereksinimler

- Flutter SDK ^3.10.4 veya üzeri
- Dart SDK (Flutter ile birlikte gelir)
- Android Studio / Xcode (platform-specific development için)
- Git

### Adımlar

1. **Repository'yi klonlayın:**
```bash
git clone <repository-url>
cd hizmetsepetimapp_flutter
```

2. **Bağımlılıkları yükleyin:**
```bash
flutter pub get
```

3. **API Base URL'i kontrol edin:**
   - `lib/appData/api_service.dart` dosyasındaki `baseUrl` değişkenini kontrol edin
   - Gerekirse kendi backend URL'inizi girin

4. **Uygulamayı çalıştırın:**
```bash
# Android
flutter run

# iOS
flutter run -d ios

# Belirli bir cihaz için
flutter devices
flutter run -d <device-id>
```

### Yapılandırma

Uygulama şu an için sabit kodlanmış backend URL'i kullanmaktadır.
Kendi backend'inizi kullanmak için `lib/appData/api_service.dart` dosyasındaki `baseUrl` değişkenini güncelleyin.

---

## 📦 Bağımlılıklar

### Production Dependencies

```yaml
dio: ^5.9.0                    # HTTP client
flutter_secure_storage: ^9.0.0 # Güvenli token saklama
shared_preferences: ^2.2.2     # Local storage
provider: ^6.0.5               # State management (şu an kullanılmıyor)
cupertino_icons: ^1.0.8        # iOS-style icons
```

### Development Dependencies

```yaml
flutter_test: sdk              # Unit testing
flutter_lints: ^6.0.0          # Linting rules
flutter_launcher_icons: ^0.14.4 # App icon generation
```

---

## 🎨 Ekranlar ve Özellikler

### 1. Home Screen
- Kategori listesi
- Kategoriye göre ürün listeleme
- Ürün kartları (resim, isim, fiyat)
- Ürün detay sayfasına navigasyon

### 2. Product Detail Screen
- Ürün bilgileri (isim, açıklama, fiyat)
- Satıcı bilgileri (isim, telefon, rating)
- Ürün yorumları
- "Sipariş Ver" butonu

### 3. Checkout Screen
- Adres listesi
- Yeni adres ekleme formu
- Adres seçimi
- Ödeme ekranına navigasyon

### 4. Payment Screen
- Sipariş özeti
- Ek hizmetler seçimi
- Randevu tarih/saat seçimi
- **Cüzdan entegrasyonu:**
  - Bakiye görüntüleme
  - Cüzdan kullanım toggle
  - Ödeme dağılımı gösterimi
- Kart bilgileri formu (opsiyonel)
- Ödeme işlemi

### 5. Booking Screen
- Randevu listesi
- Randevu detayları:
  - Ürün adı
  - Tarih/saat
  - Adres bilgileri
  - Ek hizmetler
  - Toplam tutar
  - Durum (renk kodlu badge)
- Pull-to-refresh
- İptal butonu (şu an disabled)

### 6. Wallet Screen
- Bakiye kartı
- Promosyon kodu girme ve kullanma
- İşlem geçmişi listesi:
  - İşlem tipi
  - Tutar (pozitif/negatif)
  - Açıklama
  - Tarih
- Pull-to-refresh

### 7. Profile Screen
- Kullanıcı bilgileri (isim, email, telefon)
- Profil düzenleme
- Çıkış yapma
- Auth guard (giriş yapmamış kullanıcılar için yönlendirme)

---

## 🔐 Backend Hakkında

- Backend **özel (private)** tutulmaktadır
- Bu repo canlı backend kodlarını **içermez**
- API endpoint'leri örnek / geliştirme amaçlıdır
- Backend **Go (Golang)** ile geliştirilmiştir

### Backend Özellikleri (Referans)

- JWT authentication
- MySQL veritabanı
- CORS desteği
- Wallet/ödeme sistemi
- Promo code sistemi
- Order/booking yönetimi

Eğer proje ileride:
- **Başarılı olursa:** Open-core model devam eder
- **Sonlandırılırsa:** Backend dahil tamamı açık kaynak yapılabilir

---

## 🛠️ Geliştirme Notları

### Ödeme Sistemi Mantığı

1. **Cüzdan Ödeme:**
   - Kullanıcı cüzdan bakiyesini kullanmak isterse toggle açılır
   - Bakiye yeterliyse: Tamamı cüzdandan ödenir (`payment_method: "wallet"`)
   - Bakiye yetersizse: Kısmi ödeme yapılır (`payment_method: "mixed"`)
     - Cüzdan: Mevcut bakiye kadar
     - Kart: Kalan tutar (şu an opsiyonel)

2. **Kart Ödeme:**
   - Cüzdan kullanılmıyorsa: Tamamı karttan (`payment_method: "card"`)
   - Kart bilgileri şu an görsel amaçlı, backend'e gönderilmiyor

### Güvenlik

- JWT token güvenli depolama (`flutter_secure_storage`)
- HTTPS kullanımı önerilir (production için)
- Token her istekte otomatik eklenir
- Token expiration kontrolü backend'de yapılır

### Hata Yönetimi

- Tüm API çağrıları try-catch ile korunur
- Loading ve error state'leri her ekranda mevcuttur
- Kullanıcıya anlamlı hata mesajları gösterilir
- Debug modda console'a log yazılır

---

## 📄 Lisans

Bu proje açık kaynak olarak sunulmaktadır. Detaylar için lisans dosyasına bakın.

---

## 🤝 Katkıda Bulunma

Katkılarınızı bekliyoruz! Lütfen önce bir issue açın veya mevcut issue'ları kontrol edin.

---

## 📞 İletişim

Sorularınız veya önerileriniz için issue açabilirsiniz.

---

**Not:** Bu README, projenin mevcut durumunu yansıtmaktadır ve düzenli olarak güncellenmektedir.
