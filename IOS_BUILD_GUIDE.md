# Panduan Lengkap: Build Flutter Absensi untuk iOS

## 📱 Overview

Dokumen ini berisi langkah-langkah lengkap untuk membuat versi iOS dari aplikasi Flutter Absensi yang saat ini berjalan di Android.

---

## 📋 Prerequisites (Persyaratan)

### **Hardware:**
- ✅ **Mac** (MacBook, iMac, Mac Mini, atau Mac Pro)
  - Tidak bisa build iOS di Windows/Linux
  - Minimal macOS 12.0 (Monterey) atau lebih baru
  - Minimal 8GB RAM (16GB recommended)
  - Minimal 50GB free storage

### **Software:**
- ✅ **Xcode** (versi terbaru dari App Store)
- ✅ **CocoaPods** (dependency manager untuk iOS)
- ✅ **Flutter SDK** (sudah terinstall)
- ✅ **Apple Developer Account** (untuk testing di real device & publish)

### **Accounts:**
- ✅ **Apple ID** (gratis, untuk testing di simulator)
- ✅ **Apple Developer Program** ($99/tahun, untuk publish ke App Store)

---

## 🚀 Langkah-Langkah Build iOS

### **FASE 1: Persiapan Environment**

#### **1.1. Install Xcode**

```bash
# Cara 1: Dari App Store (Recommended)
# 1. Buka App Store di Mac
# 2. Search "Xcode"
# 3. Klik "Get" atau "Install"
# 4. Tunggu download selesai (±12GB)

# Cara 2: Dari Command Line
xcode-select --install

# Verifikasi instalasi
xcode-select -p
# Output: /Applications/Xcode.app/Contents/Developer
```

#### **1.2. Accept Xcode License**

```bash
sudo xcodebuild -license accept
```

#### **1.3. Install CocoaPods**

```bash
# Install CocoaPods
sudo gem install cocoapods

# Verifikasi instalasi
pod --version
# Output: 1.x.x

# Setup CocoaPods
pod setup
```

#### **1.4. Verifikasi Flutter untuk iOS**

```bash
# Cek Flutter doctor
flutter doctor

# Output yang diharapkan:
# [✓] Flutter (Channel stable, 3.x.x)
# [✓] Xcode - develop for iOS and macOS (Xcode 15.x)
# [✓] Chrome - develop for the web
# [✓] Android Studio (version 2023.x)
# [✓] VS Code (version 1.x)
# [✓] Connected device (x available)
```

---

### **FASE 2: Konfigurasi Project iOS**

#### **2.1. Buka Project di Xcode**

```bash
# Navigasi ke folder project
cd c:\flutterku\flutter_absensi

# Buka iOS project di Xcode
open ios/Runner.xcworkspace
```

⚠️ **PENTING**: Buka file `.xcworkspace`, BUKAN `.xcodeproj`!

#### **2.2. Konfigurasi Bundle Identifier**

Di Xcode:
1. Pilih **Runner** di sidebar kiri
2. Pilih tab **Signing & Capabilities**
3. Ubah **Bundle Identifier**:
   ```
   com.holdingperkebunan.absensi
   ```
   atau
   ```
   com.yourcompany.flutter_absensi
   ```

⚠️ Bundle Identifier harus **unik** dan **tidak boleh sama** dengan app lain di App Store.

#### **2.3. Konfigurasi Team & Signing**

Di Xcode, tab **Signing & Capabilities**:

1. **Untuk Testing (Gratis)**:
   - Centang **"Automatically manage signing"**
   - Pilih **Team**: Your Apple ID
   - Xcode akan auto-generate provisioning profile

2. **Untuk Production (Berbayar)**:
   - Login ke Apple Developer Account
   - Pilih **Team**: Your Organization
   - Pilih **Provisioning Profile** yang sesuai

#### **2.4. Update Info.plist**

**File**: `ios/Runner/Info.plist`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- App Name -->
    <key>CFBundleName</key>
    <string>Absensi AGHRIS</string>
    
    <key>CFBundleDisplayName</key>
    <string>Absensi</string>
    
    <!-- App Version -->
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    
    <key>CFBundleVersion</key>
    <string>1</string>
    
    <!-- Location Permission (untuk GPS) -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>Aplikasi memerlukan akses lokasi untuk mencatat posisi saat absensi</string>
    
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>Aplikasi memerlukan akses lokasi untuk mencatat posisi saat absensi</string>
    
    <key>NSLocationAlwaysUsageDescription</key>
    <string>Aplikasi memerlukan akses lokasi untuk mencatat posisi saat absensi</string>
    
    <!-- Network Permission (untuk HTTP) -->
    <key>NSAppTransportSecurity</key>
    <dict>
        <!-- Allow HTTP untuk domain tertentu -->
        <key>NSExceptionDomains</key>
        <dict>
            <key>apis.holding-perkebunan.com</key>
            <dict>
                <key>NSExceptionAllowsInsecureHTTPLoads</key>
                <true/>
                <key>NSIncludesSubdomains</key>
                <true/>
            </dict>
            <key>hcis.holding-perkebunan.com</key>
            <dict>
                <key>NSExceptionAllowsInsecureHTTPLoads</key>
                <true/>
                <key>NSIncludesSubdomains</key>
                <true/>
            </dict>
        </dict>
    </dict>
    
    <!-- Existing keys... -->
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    
    <key>UILaunchStoryboardName</key>
    <string>LaunchScreen</string>
    
    <key>UIMainStoryboardFile</key>
    <string>Main</string>
    
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
    
    <key>UISupportedInterfaceOrientations~ipad</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationPortraitUpsideDown</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
</dict>
</plist>
```

#### **2.5. Update Podfile (Dependencies)**

**File**: `ios/Podfile`

```ruby
# Uncomment this line to define a global platform for your project
platform :ios, '12.0'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure flutter pub get is executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting Generated.xcconfig, then run flutter pub get"
end

require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

flutter_ios_podfile_setup

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
  
  # Tambahkan pod khusus jika diperlukan
  # pod 'GoogleMaps', '~> 7.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    
    # Fix untuk iOS 15+
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
```

#### **2.6. Install iOS Dependencies**

```bash
# Navigasi ke folder ios
cd ios

# Install dependencies
pod install

# Jika ada error, coba:
pod repo update
pod install --repo-update

# Kembali ke root project
cd ..
```

---

### **FASE 3: Update App Icon & Launch Screen**

#### **3.1. App Icon**

**Lokasi**: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

**Ukuran yang diperlukan**:
- 20x20 @2x (40x40 px)
- 20x20 @3x (60x60 px)
- 29x29 @2x (58x58 px)
- 29x29 @3x (87x87 px)
- 40x40 @2x (80x80 px)
- 40x40 @3x (120x120 px)
- 60x60 @2x (120x120 px)
- 60x60 @3x (180x180 px)
- 1024x1024 (App Store)

**Tools untuk generate**:
- https://appicon.co/
- https://www.appicon.build/
- Atau gunakan plugin Flutter: `flutter_launcher_icons`

**Menggunakan flutter_launcher_icons**:

1. Tambahkan di `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  ios: true
  image_path: "assets/icon/app_icon.png"
  remove_alpha_ios: true
```

2. Generate:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

#### **3.2. Launch Screen (Splash Screen)**

**File**: `ios/Runner/Assets.xcassets/LaunchImage.imageset/`

Atau edit di Xcode:
1. Buka `ios/Runner/Base.lproj/LaunchScreen.storyboard`
2. Customize sesuai kebutuhan

---

### **FASE 4: Build & Test**

#### **4.1. Clean Build**

```bash
# Clean Flutter
flutter clean

# Get dependencies
flutter pub get

# Clean iOS build
cd ios
rm -rf Pods
rm -rf Podfile.lock
pod install
cd ..
```

#### **4.2. Build untuk Simulator**

```bash
# List available simulators
flutter emulators

# Launch simulator
flutter emulators --launch apple_ios_simulator

# Build & run
flutter run -d ios
```

#### **4.3. Build untuk Real Device**

```bash
# Connect iPhone via USB

# List connected devices
flutter devices

# Build & run
flutter run -d <device-id>

# Atau langsung
flutter run
```

**Troubleshooting jika error**:
1. Di iPhone: Settings → General → VPN & Device Management
2. Trust developer certificate
3. Coba run lagi

#### **4.4. Build Release (IPA)**

```bash
# Build release IPA
flutter build ios --release

# Output: build/ios/iphoneos/Runner.app
```

**Untuk create IPA file**:
1. Buka Xcode
2. Product → Archive
3. Tunggu archiving selesai
4. Window → Organizer
5. Pilih archive → Distribute App
6. Pilih method distribusi (Ad Hoc, App Store, etc.)

---

### **FASE 5: Testing**

#### **5.1. Testing Checklist**

- [ ] **Login**: Test login dengan NIK & password
- [ ] **GPS/Location**: Test permission & location accuracy
- [ ] **Check-In**: Test check-in dengan semua field
- [ ] **Check-Out**: Test check-out dengan semua field
- [ ] **Map Picker**: Test leaflet map picker
- [ ] **Date/Time Picker**: Test iOS native pickers
- [ ] **Network**: Test API calls (check-in, check-out, login)
- [ ] **Error Handling**: Test error scenarios
- [ ] **UI/UX**: Test di berbagai ukuran screen (iPhone SE, iPhone 14, iPhone 14 Pro Max)
- [ ] **Orientation**: Test portrait & landscape
- [ ] **Dark Mode**: Test jika support dark mode
- [ ] **Performance**: Test app performance & memory usage

#### **5.2. Test di Berbagai Device**

**Simulator**:
- iPhone SE (3rd gen) - Small screen
- iPhone 14 - Standard screen
- iPhone 14 Pro Max - Large screen
- iPad - Tablet

**Real Device** (Recommended):
- Minimal 1 real iPhone untuk testing

---

### **FASE 6: Persiapan App Store**

#### **6.1. App Store Connect Setup**

1. Login ke https://appstoreconnect.apple.com/
2. Klik **"My Apps"**
3. Klik **"+"** → **"New App"**
4. Isi informasi:
   - **Platform**: iOS
   - **Name**: Absensi AGHRIS
   - **Primary Language**: Indonesian
   - **Bundle ID**: com.holdingperkebunan.absensi
   - **SKU**: ABSENSI-AGHRIS-001
   - **User Access**: Full Access

#### **6.2. App Information**

**Required**:
- **App Name**: Absensi AGHRIS (max 30 characters)
- **Subtitle**: Aplikasi Absensi Karyawan (max 30 characters)
- **Description**: Deskripsi lengkap aplikasi
- **Keywords**: absensi, kehadiran, karyawan, AGHRIS
- **Support URL**: https://holding-perkebunan.com/support
- **Marketing URL**: https://holding-perkebunan.com
- **Privacy Policy URL**: https://holding-perkebunan.com/privacy

**Screenshots** (Required):
- 6.5" Display (iPhone 14 Pro Max): 1290 x 2796 px
- 5.5" Display (iPhone 8 Plus): 1242 x 2208 px
- iPad Pro (12.9"): 2048 x 2732 px

**App Icon**:
- 1024 x 1024 px (PNG, no transparency)

#### **6.3. App Privacy**

Deklarasi data yang dikumpulkan:
- **Location**: Untuk mencatat posisi saat absensi
- **User ID**: NIK karyawan
- **Authentication**: Login credentials

#### **6.4. Build Upload**

```bash
# Archive di Xcode
# Product → Archive

# Upload ke App Store Connect
# Window → Organizer → Distribute App → App Store Connect
```

#### **6.5. TestFlight (Beta Testing)**

1. Setelah upload build, tunggu processing (±15-30 menit)
2. Di App Store Connect → TestFlight
3. Add internal testers (max 100)
4. Add external testers (max 10,000)
5. Distribute build untuk testing

#### **6.6. Submit for Review**

1. Lengkapi semua informasi di App Store Connect
2. Pilih build yang akan di-submit
3. Klik **"Submit for Review"**
4. Tunggu review (±1-3 hari)

---

## 🔧 Troubleshooting Common Issues

### **Issue 1: CocoaPods Error**

```bash
# Error: Unable to find a specification for...
pod repo update
pod install --repo-update

# Error: The sandbox is not in sync with the Podfile.lock
cd ios
rm -rf Pods
rm Podfile.lock
pod install
```

### **Issue 2: Signing Error**

```
Error: Signing for "Runner" requires a development team
```

**Solusi**:
1. Buka Xcode
2. Runner → Signing & Capabilities
3. Pilih Team (Apple ID)

### **Issue 3: Deployment Target Error**

```
Error: The iOS deployment target 'IPHONEOS_DEPLOYMENT_TARGET' is set to 8.0
```

**Solusi**:
1. Buka `ios/Podfile`
2. Ubah `platform :ios, '12.0'`
3. Run `pod install`

### **Issue 4: Geolocator Permission**

```
Error: Location permission not granted
```

**Solusi**: Pastikan `Info.plist` sudah ada location permission keys (sudah ada di langkah 2.4)

### **Issue 5: HTTP Not Allowed**

```
Error: App Transport Security has blocked a cleartext HTTP
```

**Solusi**: Pastikan `NSAppTransportSecurity` sudah dikonfigurasi di `Info.plist` (sudah ada di langkah 2.4)

---

## 📊 Perbandingan Android vs iOS

| Aspek | Android | iOS |
|-------|---------|-----|
| **Build Environment** | Windows/Mac/Linux | Mac only |
| **IDE** | Android Studio | Xcode |
| **Permissions** | AndroidManifest.xml | Info.plist |
| **App Store** | Google Play Store | Apple App Store |
| **Review Time** | ~1-3 hari | ~1-3 hari |
| **Developer Fee** | $25 (one-time) | $99/year |
| **Testing** | Emulator/Real device | Simulator/Real device |

---

## 💰 Biaya yang Diperlukan

### **Development**:
- ✅ Mac (jika belum punya): Rp 15.000.000 - Rp 50.000.000
- ✅ Apple Developer Program: $99/tahun (±Rp 1.500.000)

### **Optional**:
- iPhone untuk testing: Rp 10.000.000 - Rp 25.000.000
- App Store optimization tools: Varies
- Marketing & promotion: Varies

---

## ⏱️ Estimasi Waktu

| Tahap | Waktu |
|-------|-------|
| Setup environment (pertama kali) | 2-4 jam |
| Konfigurasi project | 1-2 jam |
| Testing & debugging | 2-4 jam |
| App Store setup | 1-2 jam |
| Review & approval | 1-3 hari |
| **Total** | **1-2 minggu** |

---

## 📝 Checklist Lengkap

### **Persiapan**:
- [ ] Punya Mac dengan macOS 12.0+
- [ ] Install Xcode dari App Store
- [ ] Install CocoaPods
- [ ] Punya Apple ID
- [ ] (Optional) Daftar Apple Developer Program ($99/tahun)

### **Konfigurasi**:
- [ ] Buka project di Xcode (`ios/Runner.xcworkspace`)
- [ ] Set Bundle Identifier
- [ ] Configure Signing & Capabilities
- [ ] Update Info.plist (permissions)
- [ ] Update Podfile
- [ ] Run `pod install`
- [ ] Update app icon
- [ ] Update launch screen

### **Build & Test**:
- [ ] Build di simulator
- [ ] Test semua fitur di simulator
- [ ] Build di real device
- [ ] Test semua fitur di real device
- [ ] Fix bugs & issues
- [ ] Build release IPA

### **App Store**:
- [ ] Create app di App Store Connect
- [ ] Upload screenshots
- [ ] Fill app information
- [ ] Configure app privacy
- [ ] Upload build via Xcode
- [ ] TestFlight testing
- [ ] Submit for review
- [ ] Wait for approval
- [ ] Publish!

---

## 🎯 Next Steps

Setelah dokumentasi ini dipahami:

1. **Persiapkan Mac** (jika belum punya)
2. **Install semua tools** yang diperlukan
3. **Daftar Apple Developer Program** (jika ingin publish)
4. **Ikuti langkah-langkah** di dokumentasi ini
5. **Test thoroughly** sebelum submit
6. **Submit ke App Store**

---

## 📞 Resources & Links

- **Flutter iOS Deployment**: https://docs.flutter.dev/deployment/ios
- **Xcode Download**: https://developer.apple.com/xcode/
- **App Store Connect**: https://appstoreconnect.apple.com/
- **Apple Developer**: https://developer.apple.com/
- **CocoaPods**: https://cocoapods.org/
- **TestFlight**: https://developer.apple.com/testflight/

---

## ⚠️ Important Notes

1. **Mac is Required**: Tidak bisa build iOS tanpa Mac
2. **Apple Developer Account**: Perlu untuk publish ke App Store
3. **Testing**: Test di real device sebelum submit
4. **Review Guidelines**: Baca Apple's App Review Guidelines
5. **Privacy**: Deklarasi semua data yang dikumpulkan
6. **Updates**: Siapkan untuk maintenance & updates berkala

---

## 🆘 Butuh Bantuan?

Jika ada pertanyaan atau kendala:
1. Baca dokumentasi Flutter iOS
2. Check Stack Overflow
3. Flutter Discord/Slack community
4. Konsultasi dengan iOS developer

---

**Good luck with your iOS build! 🚀📱**
