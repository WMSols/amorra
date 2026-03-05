# Amorra iOS App Store Deployment Guide

This guide walks you through building and submitting the Amorra Flutter app to the Apple App Store. Use your **Mac VM** for all steps that require Xcode or Apple tools.

---

## Prerequisites (on Mac)

- **macOS** (your Mac VM)
- **Xcode** (latest from Mac App Store) — required for iOS builds and App Store Connect
- **Flutter** installed and on PATH (`flutter doctor`)
- **Apple Developer Program** membership ($99/year) — [developer.apple.com](https://developer.apple.com/programs/)
- **CocoaPods** (usually installed with Flutter; run `pod --version` to check)

---

## Part 1: One-time setup

### 1.1 Clone / open the project on your Mac VM

```bash
# If not already done, clone or copy the repo to your Mac
cd ~/projects   # or your preferred directory
git clone <your-repo-url> amorra
cd amorra
```

### 1.2 Install Flutter dependencies

```bash
flutter pub get
```

### 1.3 iOS CocoaPods (first time or after adding plugins)

```bash
cd ios
pod install
cd ..
```

### 1.4 Create `.env` file (if not present)

The app loads config from `.env`. Create it from `.env.example` if you have one, or add at minimum any keys your app needs (e.g. Stripe publishable key). Without it the app may still run but some features might not work.

```bash
# Example - adjust keys as per your setup
cp .env.example .env
# Edit .env with your values
```

### 1.5 Verify Flutter and iOS toolchain

```bash
flutter doctor -v
```

Fix any issues reported (Xcode license, CocoaPods, etc.). You should see something like:

- Flutter ✓
- Xcode ✓
- iOS toolchain ✓
- CocoaPods ✓

---

## Part 2: Apple Developer & App Store Connect

### 2.1 Register an App ID (Bundle ID)

1. Go to [Apple Developer → Certificates, Identifiers & Profiles → Identifiers](https://developer.apple.com/account/resources/identifiers/list).
2. Click **+** to add a new Identifier.
3. Choose **App IDs** → **App**.
4. **Description:** e.g. `Amorra AI`.
5. **Bundle ID:**  
   - Current in project: `com.example.amorra`.  
   - For production, Apple recommends a unique reverse-DNS (e.g. `com.amorra.ai` or `com.yourcompany.amorra`).  
   - If you keep `com.example.amorra`, ensure it’s registered here. If you change it, you must update it everywhere (see “Changing bundle ID” below).
6. Enable capabilities you use:
   - **Sign in with Apple** (if you use it)
   - **Push Notifications** (if you use FCM on iOS)
   - **Associated Domains** (if you use universal links, e.g. Stripe)
7. Save.

### 2.2 Create the app in App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com) → **My Apps**.
2. Click **+** → **New App**.
3. **Platforms:** iOS.
4. **Name:** Amorra AI (or your store name).
5. **Primary Language:** your choice.
6. **Bundle ID:** select the App ID you created (e.g. `com.example.amorra`).
7. **SKU:** e.g. `amorra-ios-001`.
8. Create the app.

### 2.3 Create a distribution certificate and provisioning profile

**Option A – Let Xcode manage (easiest)**

1. On your Mac, open the iOS project in Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```
   (Use `.xcworkspace`, not `.xcodeproj`, when using CocoaPods.)
2. Select the **Runner** project in the left sidebar → **Runner** target.
3. Open **Signing & Capabilities**.
4. Check **Automatically manage signing**.
5. Choose your **Team** (your Apple Developer account).
6. Set **Bundle Identifier** to match the App ID (e.g. `com.example.amorra`).
7. Xcode will create/use a distribution certificate and provisioning profile when you archive.

**Option B – Manual (optional)**

- In [Developer → Certificates](https://developer.apple.com/account/resources/certificates/list), create an **Apple Distribution** certificate, download and install it in Keychain.
- In [Profiles → Distribution](https://developer.apple.com/account/resources/profiles/list), create an **App Store** provisioning profile for your App ID and install it.

---

## Part 3: Build the iOS app on Mac

### 3.1 Clean and get dependencies

```bash
cd /path/to/amorra
flutter clean
flutter pub get
cd ios && pod install && cd ..
```

### 3.2 Build an IPA (release)

```bash
flutter build ipa
```

This produces a release build and, if signing is set up, an `.ipa` file. Output is typically under:

`build/ios/ipa/amorra.ipa`

If you see signing errors, fix **Signing & Capabilities** in Xcode (see 2.3) and run `flutter build ipa` again.

### 3.3 Alternative: Archive from Xcode (for upload to App Store Connect)

1. Open workspace:
   ```bash
   open ios/Runner.xcworkspace
   ```
2. In Xcode top bar, select **Any iOS Device (arm64)** (not a simulator).
3. Menu: **Product → Archive**.
4. When the archive is done, the **Organizer** window opens.
5. Select the archive → **Distribute App**.
6. Choose **App Store Connect** → **Upload**.
7. Follow the wizard (signing, options). Leave defaults unless you need something specific.
8. After upload, wait a few minutes and check App Store Connect for the build.

---

## Part 4: Submit for review

### 4.1 In App Store Connect

1. Open your app → **iOS App** tab.
2. Create a **new version** (e.g. 1.0.0) if you haven’t already.
3. Under **Build**, click **+** and select the build you uploaded.
4. Fill in:
   - **What’s New**
   - **Description**, **Keywords**, **Support URL**, **Privacy Policy URL**
   - **Screenshots** (required for each device size you support)
   - **App Privacy** (data collection and usage)
   - **Pricing**
   - **Age Rating** questionnaire
5. Submit for review.

### 4.2 Version and build numbers

- In `pubspec.yaml`: `version: 1.0.0+1`  
  - `1.0.0` → **CFBundleShortVersionString** (marketing version).  
  - `1` → **CFBundleVersion** (build number).
- For each new upload, increase the build number (e.g. `1.0.0+2`). You can do that in `pubspec.yaml` or with:
  ```bash
  flutter build ipa --build-number=2
  ```

---

## Part 5: Changing the bundle ID (optional)

If you move from `com.example.amorra` to e.g. `com.amorra.ai`:

1. **Apple Developer:** Create a new App ID with the new bundle ID and capabilities.
2. **App Store Connect:** If the app is already created with the old ID, you may need to create a new app with the new bundle ID (Apple doesn’t allow changing bundle ID of an existing app).
3. **Project:**
   - In Xcode: **Runner** target → **Signing & Capabilities** → set **Bundle Identifier** to the new ID.
   - Or in `ios/Runner.xcodeproj/project.pbxproj`: replace `com.example.amorra` with the new bundle ID (all occurrences for Runner and RunnerTests).
   - In `ios/Runner/Info.plist`: update the Stripe URL scheme to match (the scheme often matches the bundle ID).
   - In `ios/Runner/GoogleService-Info.plist`: update **BUNDLE_ID** (and re-download from Firebase if needed).
   - In Firebase Console: add the new iOS bundle ID to the project and download a new `GoogleService-Info.plist`.
   - In `lib/firebase_options.dart`: if you use FlutterFire CLI, run `dart run flutterfire configure` and select the new iOS app; otherwise update `iosBundleId` manually.
   - Stripe: if you use a fixed URL scheme, update it to match the new bundle ID.

Then on Mac:

```bash
flutter clean && flutter pub get && cd ios && pod install && cd ..
flutter build ipa
```

---

## Part 6: Troubleshooting

| Issue | What to do |
|-------|------------|
| **Signing errors** | Open `ios/Runner.xcworkspace` in Xcode, set Team and “Automatically manage signing”, ensure Bundle ID matches the App ID. |
| **Pod install fails** | Run `cd ios && pod repo update && pod install`. |
| **Build fails: missing .xcconfig** | Run `flutter pub get` from project root; Flutter generates `Generated.xcconfig`. |
| **White screen on launch** | Check that `GoogleService-Info.plist` is in `ios/Runner/` and added to the Runner target in Xcode. |
| **“No valid code signing”** | In Xcode, select the Runner target → Signing & Capabilities → choose your Team and ensure “Automatically manage signing” is on. |
| **Archive not showing in Organizer** | Make sure you selected “Any iOS Device (arm64)” and did Product → Archive, not just Build. |

---

## Quick reference – build and upload from Mac

```bash
# From project root on Mac
flutter clean && flutter pub get
cd ios && pod install && cd ..
flutter build ipa
# Then either:
# - Upload the IPA from build/ios/ipa/ via Transporter app, or
# - Open ios/Runner.xcworkspace in Xcode → Product → Archive → Distribute App → App Store Connect
```

---

## Summary of code changes made for iOS/App Store

- **`ios/Runner/Info.plist`:** Added `NSPhotoLibraryUsageDescription` for photo library access (required when using `image_picker`; avoids App Store rejection).

No other code changes were required for a basic iOS/App Store build. Ensure your `.env`, Firebase, and Stripe config are correct for production.
